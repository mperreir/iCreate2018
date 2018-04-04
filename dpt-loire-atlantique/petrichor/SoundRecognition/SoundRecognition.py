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

# Change le champ MESSAGE selon le son qui est reconnu
def printReco(reco, params) :
	if (reco[0] == 1.0) :
		params.MESSAGE = "charriot"
	if (reco[1] == 1.0) :
		params.MESSAGE = "clavier"
	if (reco[2] == 1.0) :
		params.MESSAGE = "ding"
	if (reco[3] == 1.0) :
		params.MESSAGE = "tab"
	if (reco[4] == 1.0) :
		params.MESSAGE == "blanc"

# Entrainement du programme de reconnaissance sur une base de sons pre enregistres
#at.featureAndTrain(["machineAEcrire/charriot", "machineAEcrire/clavier", "machineAEcrire/ding", "machineAEcrire/tab", "testMaison/blanc"], 1.0, 1.0, at.shortTermWindow, at.shortTermStep, "knn", "knnTypeWriterSounds", False);

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
	print ("UDP target IP:", params.UDP_IP)
	print ("UDP target port : ", params.UDP_PORT)
	print ("message : ", params.MESSAGE)
	sock = socket.socket(socket.AF_INET, # Internet
			     socket.SOCK_DGRAM) # UDP
	sock.sendto(params.MESSAGE, (params.UDP_IP, params.UDP_PORT))

# Programme principal
params = UDPparam()
params.MESSAGE = "tab"
sendUDP(params)

'''while (True) :
	recordAudio()
	(_,reco,_) = at.fileClassification("records/file.wav", "knnTypeWriterSounds", "knn")
	printReco(reco, params)
	#sendUDP()
	print(params.MESSAGE)
	params.MESSAGE = "blanc" # sinon on va envoyer le meme ordre en boucle'''
