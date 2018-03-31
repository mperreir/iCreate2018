import numpy.fft as fft
import numpy as np
import scipy.io.wavfile as wav

# import a wav audio file
def importWav(filename) :
	file = "testMaison/" + filename + ".wav"
	return wav.read(file)

# import of finger sounds
(doigt1r, doigt1) = importWav("doigt1")
(doigt2r, doigt2) = importWav("doigt2")
(doigt3r, doigt3) = importWav("doigt3")
(doigt4r, doigt4) = importWav("doigt4")
(doigt5r, doigt5) = importWav("doigt5")

# import of hand sounds
(main1r, main1) = importWav("main1")
(main2r, main2) = importWav("main2")
(main3r, main3) = importWav("main3")
(main4r, main4) = importWav("main4")
(main5r, main5) = importWav("main5")

# import of mouth sounds
(prout1r, prout1) = importWav("prout1")
(prout2r, prout2) = importWav("prout2")
(prout3r, prout3) = importWav("prout3")
(prout4r, prout4) = importWav("prout4")
(prout5r, prout5) = importWav("prout5")

# list of all the imported sound datas
clips = [doigt1, doigt2, doigt3, doigt4, doigt5, main1, main2, main3, main4, main5, prout1, prout2, prout3, prout4, prout5]



# writing the results file
outputFile = open("fftResults.csv","w");
for sig in clips :
	res = fft.fft(sig)[-512:]
	l = len(res)
	print(l)
	for i in range (l) :
		val = np.sqrt(np.real(res[i][0])**2 + np.real(res[i][1])**2)
		outputFile.write(str(val) + ";")
	outputFile.write("\n");
outputFile.close();