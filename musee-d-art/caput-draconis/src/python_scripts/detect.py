import cv2
import os
import numpy as np

from pythonosc import osc_message_builder
from pythonosc import udp_client

def diffImg(t0, t1, t2):
  d1 = cv2.absdiff(t2, t1)
  d2 = cv2.absdiff(t1, t0)
  return cv2.bitwise_and(d1, d2)

# Renvoie la différence entre deux images
def dif(base, im):
    d = cv2.absdiff(base, im)
    d[d<35] = 0
    d[d>=35] = 255
    return d

# Renvoie le barycentre des points
def center(im):
    d = np.argwhere(im > 30)
    if len(d) < 30:
        return (0,0)

    s = np.add.reduce(d)
    l = len(d) if len(d) > 0 else 1
    return ((int)(s[1]/l),(int)(s[0]/l))

# Renvoie le centre d'une enveloppe convexe
def hull_center(hull):
    s = np.add.reduce(hull)
    s = s[0]
    l = len(hull)
    return ((int)(s[0] / l), (int)(s[1] / l))


# Détecte et renvoie les visages d'une image
def detect_faces(f_cascade, colored_img, scaleFactor = 1.1):
    #just making a copy of image passed, so that passed image is not changed
    img_copy = colored_img.copy()

    #convert the test image to gray image as opencv face detector expects gray images
    gray = cv2.cvtColor(img_copy, cv2.COLOR_BGR2GRAY)

    #let's detect multiscale (some images may be closer to camera than others) images
    faces = f_cascade.detectMultiScale(gray, scaleFactor=scaleFactor, minNeighbors=5);

    #go over list of faces and draw them as rectangles on original colored img
    for (x, y, w, h) in faces:
        cv2.rectangle(img_copy, (x, y), (x+w, y+h), (0, 255, 0), 2)

    return img_copy, faces

# Cherche et renvoie les contours et enveloppes convexes d'une images
def contour(im):
    (_, contours, hierarchy) = cv2.findContours(im, cv2.RETR_TREE,cv2.CHAIN_APPROX_SIMPLE)

    ci = 0
    max_area = 0
    cnt = []
    hull = 0
    if len(contours) > 0:
        for i in range(len(contours)):
            cnt=contours[i]
            area = cv2.contourArea(cnt)
            if(area>max_area and area > 100):
                #print(area)
                max_area=area
                ci=i

        cnt=contours[ci]
        hull = cv2.convexHull(cnt)

    return (cnt, hull)

ip = "127.0.0.1"
port = 55555
client = udp_client.SimpleUDPClient(ip, port)

cam = cv2.VideoCapture(2)

winName = "Movement Indicator"
winBg = "Background"
winDiff = "Difference"
winGrey = "Greyscale"

cv2.namedWindow(winName)
cv2.namedWindow(winBg)
cv2.namedWindow(winDiff)
#cv2.namedWindow(winGrey)

# Read three images first:
t_minus = cv2.cvtColor(cam.read()[1], cv2.COLOR_RGB2GRAY)
t = cv2.cvtColor(cam.read()[1], cv2.COLOR_RGB2GRAY)
t_plus = cv2.cvtColor(cam.read()[1], cv2.COLOR_RGB2GRAY)

background = cam.read()[1]
bg_bw = cv2.cvtColor(background, cv2.COLOR_RGB2GRAY)

lbp_face_cascade = cv2.CascadeClassifier('lbpcascade_frontalface_improved.xml')

x = 0
y = 0
cl = (0,0)
cr = (0,0)

while True:
    im = cam.read()[1]
    diff = dif(bg_bw, t_plus)
    faces_detected_img, faces = detect_faces(lbp_face_cascade, im)

    diff_c = cv2.cvtColor(diff, cv2.COLOR_GRAY2BGR)
    if faces != ():
        x = faces[0][0] + faces[0][2] // 2
        y = faces[0][1] + faces[0][3] // 2
        cv2.circle(diff_c, (x, y), 10, (0, 0, 255), -1)
    #blur = cv2.GaussianBlur(diff,(3,3),0)

    half_r = np.copy(diff)
    half_r[:, 0:np.size(diff, 1)//2 + 100] = 0
    cnt, hull = contour(half_r)
    if cnt != []:
        cl = hull_center(hull)
        cv2.drawContours(diff_c,[cnt],-1,(0,255,0),2)
        cv2.drawContours(diff_c,[hull],-1,(0,255,255),2)
        cv2.circle(diff_c, cl, 10, (0, 0, 255), -1)

    half_l = np.copy(diff)
    half_l[:, np.size(diff, 1)//2 - 100:] = 0
    cnt, hull = contour(half_l)
    if cnt != []:
        cr = hull_center(hull)
        cv2.drawContours(diff_c,[cnt],-1,(0,255,0),2)
        cv2.drawContours(diff_c,[hull],-1,(0,255,255),2)
        cv2.circle(diff_c, cr, 10, (0, 0, 255), -1)





    cv2.imshow(winName, diffImg(t_minus, t, t_plus))
    cv2.imshow(winBg, faces_detected_img)
    cv2.imshow(winDiff, diff_c)
    #cv2.imshow(winGrey)

    # Read next image
    t_minus = t
    t = t_plus
    t_plus = cv2.cvtColor(im, cv2.COLOR_RGB2GRAY)

    client.send_message("/coord", str(x) + "," + str(y) + "," + str(cl[0]) + "," + str(cl[1]) + "," + str(cr[0]) + "," + str(cr[1]))


    key = cv2.waitKey(10)

    if key == 27:
        cv2.destroyAllWindows()
        break
    elif key == ord('c'):
        background = cam.read()[1]
        bg_bw = cv2.cvtColor(background, cv2.COLOR_RGB2GRAY)


print("Goodbye")
