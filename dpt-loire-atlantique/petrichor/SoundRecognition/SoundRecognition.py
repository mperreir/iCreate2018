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
(cloc1r, cloc1) = importWav("cloc1")
(cloc2r, cloc2) = importWav("cloc2")
(cloc3r, cloc3) = importWav("cloc3")
(cloc4r, cloc4) = importWav("cloc4")
(cloc5r, cloc5) = importWav("cloc5")

#import of silence
(blancr, blanc) = importWav("blanc")

# list of all the imported sound datas
clips = [doigt1, doigt2, doigt3, doigt4, doigt5, main1, main2, main3, main4, main5, cloc1, cloc2, cloc3, cloc4, cloc5, blanc]



# writing the results file
outputFile = open("fftResults.csv","w");
for sig in clips :
	spec = fft.fft(sig)
	l = len(spec)
	res = []
	jump = int(l/256)
	for i in range (256) :
		res.append(spec[i*jump])
	for i in range (len(res)) :
		val = np.sqrt(np.real(res[i][0])**2 + np.real(res[i][1])**2)
		outputFile.write(str(val) + ";")
	outputFile.write("\n");
outputFile.close();