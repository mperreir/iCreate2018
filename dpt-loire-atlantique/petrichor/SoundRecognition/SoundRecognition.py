from pyAudioAnalysis import audioTrainTest as at
import pyaudio
import wave

def printReco(reco) :
	if (reco[0] == 1.0) :
		print("cloc")
	if (reco[1] == 1.0) :
		print("main")
	if (reco[2] == 1.0) :
		print("doigt")

at.featureAndTrain(["testMaison/cloc", "testMaison/main", "testMaison/doigt", "testMaison/blanc"], 1.0, 1.0, at.shortTermWindow, at.shortTermStep, "knn", "knnTypeWriterSounds", False);

def recordAudio() :
	FORMAT = pyaudio.paInt16
	CHANNELS = 2
	RATE = 44100
	CHUNK = 1024
	RECORD_SECONDS = 1
	WAVE_OUTPUT_FILENAME = "records/file.wav"
	 
	audio = pyaudio.PyAudio()
	 
	# start Recording
	stream = audio.open(format=FORMAT, channels=CHANNELS,
					rate=RATE, input=True,
					frames_per_buffer=CHUNK)
	print ("recording...")
	frames = []
	 
	for i in range(0, int(RATE / CHUNK * RECORD_SECONDS)):
		data = stream.read(CHUNK)
		frames.append(data)
	print ("finished recording")
	 
	 
	# stop Recording
	stream.stop_stream()
	stream.close()
	audio.terminate()
	 
	waveFile = wave.open(WAVE_OUTPUT_FILENAME, 'wb')
	waveFile.setnchannels(CHANNELS)
	waveFile.setsampwidth(audio.get_sample_size(FORMAT))
	waveFile.setframerate(RATE)
	waveFile.writeframes(b''.join(frames))
	waveFile.close()

while (True) :
	recordAudio()
	(_, reco, _) = at.fileClassification("records/file.wav", "knnTypeWriterSounds", "knn")
	printReco(reco)
