from pyAudioAnalysis import audioTrainTest as at
import pyaudio
import wave
import socket



# Parametres UDP pour l'envoi des messages
class UDPparam :
	def __init__(self) :
		self.UDP_IP = "127.0.0.1"
		self.UDP_PORT = 5005
		self.MESSAGE = "blanc"


# Trouve l'index du maximum d'une liste
def maxID(reco) :
	maxi = 0.
	res = 0
	for i in range (len(reco)) :
		if (reco[i] >= maxi) :
			maxi = reco[i]
			res = i
	return res



# Change le champ MESSAGE selon le son qui est reconnu
def printReco(reco, params) :
	m = maxID(reco)
	if (m == 0) :
		params.MESSAGE = "charriot"
	if (m == 1) :
		params.MESSAGE = "clavier"
	if (m == 2) :
		params.MESSAGE = "clavier"
	if (m == 3) :
		params.MESSAGE = "ding"
	if (m == 4) :
		params.MESSAGE == "tab"



# Enregistrement du micro pendant une seconde (code donne par pyAudio)
def recordAudio() :
	FORMAT = pyaudio.paInt16
	CHANNELS = 2
	RATE = 44100
	CHUNK = 1024
	RECORD_SECONDS = 1
	WAVE_OUTPUT_FILENAME = "records/file.wav"

	audio = pyaudio.PyAudio();

	# start Recording
	stream = audio.open(format=FORMAT, channels=CHANNELS,
					rate=RATE, input=True,
					frames_per_buffer=CHUNK)
	print("recording...")
	frames = []

	for i in range(0, int(RATE / CHUNK * RECORD_SECONDS)):
		data = stream.read(CHUNK)
		frames.append(data)
	print ("finished recording")

	# stop recording
	stream.stop_stream()
	stream.close()
	audio.terminate()

	waveFile = wave.open(WAVE_OUTPUT_FILENAME, 'wb')
	waveFile.setnchannels(CHANNELS)
	waveFile.setsampwidth(audio.get_sample_size(FORMAT))
	waveFile.setframerate(RATE)
	waveFile.writeframes(b''.join(frames))
	waveFile.close()



# Envoi d'un paquet UDP vers le programme Unity
def sendUDP(params) :
	print("")
	print ("UDP target IP:", params.UDP_IP)
	print ("UDP target port : ", params.UDP_PORT)
	print ("message : ", params.MESSAGE)
	print("")
	sock = socket.socket(socket.AF_INET, # Internet
			     socket.SOCK_DGRAM) # UDP
	sock.sendto(params.MESSAGE, (params.UDP_IP, params.UDP_PORT))



# Addition des resultats de plusieurs analyses
def addReco(recoList) :
	res = [0, 0, 0, 0, 0, 0]
	for i in range (len(recoList)) :
		n = maxID(recoList[i])
		res[n] += 1
	return res




# Programme principal
params = UDPparam()
while (True) :
	recordAudio()
	(_,reco1,_) = at.fileClassification("records/file.wav", "knnTypeWriterSounds", "knn")
	(_,reco2,_) = at.fileClassification("records/file.wav", "svmTypeWriterSounds", "svm")
	(_,reco3,_) = at.fileClassification("records/file.wav", "etTypeWriterSounds", "extratrees")
	(_,reco4,_) = at.fileClassification("records/file.wav", "gbTypeWriterSounds", "gradientboosting")
	(_,reco5,_) = at.fileClassification("records/file.wav", "rfTypeWriterSounds", "randomforest")
	reco = addReco([reco1, reco2, reco3, reco4, reco5])
	print ("")
	print (reco1)
	print (reco2)
	print (reco3)
	print (reco4)
	print (reco5)
	print (reco)
	print("")
	printReco(reco, params)
	sendUDP(params)
	print(params.MESSAGE)
	params.MESSAGE = "blanc" # sinon on va envoyer le meme ordre en boucle
