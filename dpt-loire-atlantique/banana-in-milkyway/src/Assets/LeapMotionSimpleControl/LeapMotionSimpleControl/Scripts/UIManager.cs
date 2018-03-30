                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                /*******************************************************
 * Copyright (C) 2016 Ngan Do - dttngan91@gmail.com
 *******************************************************/
using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using UnityEngine.UI;
using CustomUtils;
using System;
using System.IO;

namespace LeapMotionSimpleControl
{
	[RequireComponent (typeof(Counter))]
	public class UIManager : MonoBehaviour
	{
		public Text CurrentGestureText;
		public Transform ListGesturePivot;
		public GameObject prefabSliderUI;

		GameManager _gameManager;
		Counter _countDownSlider;

		Dictionary<GestureManager.GestureTypes, Slider> _listSliders;

		GameManager.EndEvent _endEventCountDown;

		AudioSource deadSound, ambiantSound, battementSound, essouflementSound, pasSound, kidsSound;

		List<List<string>> allPersons;

		List<string> informations = new List<string>();
		Dictionary<string, Vector3> allAudioPosition = new Dictionary<string, Vector3>();

		int currentPerso = -1;
		int currentInformation = 1;
		bool onPlay = false;

		// Use this for initialization
		void Start ()
		{
			_countDownSlider = GetComponent<Counter> ();
			AudioSource[] audioSources = UnityEngine.Object.FindObjectsOfType(typeof(AudioSource)) as AudioSource[];

			foreach(AudioSource audio in audioSources){

				switch(audio.name){
				case "AudioSource(Paroles)":
					Debug.Log ("parole attributed");
					deadSound = audio;
					break;
				case "AudioSource(Ambiant)":
					ambiantSound = audio;
					break;
				case "AudioSource(Battements)":
					Debug.Log ("battement attributed");
					battementSound = audio;
					break;
				case "AudioSource(Essoufflement)":
					Debug.Log ("essouflement attributed");
					essouflementSound = audio;
					break;
				case "AudioSource(Pas)":
					Debug.Log ("pas attributed");
					pasSound = audio;
					break;
				case "AudioSource(Kids)":
					Debug.Log ("kids attributed");
					kidsSound = audio;
					break;
				default:
					
					break;
				}
			}

			allPersons = new List<List<string>>();
			getAllPerson();

			getAllVector3Audio ();
		}

		// Update is called once per frame
		void Update ()
		{

		}

		#region UI

		// Random all elemet position in the list
		private void randomSort(List<List<string>> list){
			System.Random rnd = new System.Random ();
			int length = list.Count;
			int x = 0;
			for (int i = 0; i < length; i++) {
				x = rnd.Next (length);
				List<string> tmp = list [i];
				list [i] = list [x];
				list [x] = tmp;
			}

		}

		private List<string> randomSort(List<string> list){
			System.Random rnd = new System.Random ();
			int x = -1;			
			int length = list.Count;			
			for (int i = 1; i < length; i++) {
				x = rnd.Next (length-1)+1;
				string tmp = list [i];
				list [i] = list [x];
				list [x] = tmp;
			}

			return list;
		}

		private void getAllVector3Audio(){
			allAudioPosition.Add ("1_Italie", new Vector3 (Mathf.Sin (ConstanteAngle.ITALIE), 0, Mathf.Cos (ConstanteAngle.ITALIE)));
			allAudioPosition.Add ("1_Nantes", new Vector3 (Mathf.Sin (ConstanteAngle.NANTES), 0, Mathf.Cos (ConstanteAngle.NANTES)));
			allAudioPosition.Add ("2_Allemagne", new Vector3 (Mathf.Sin (ConstanteAngle.ALLEMAGNE), 0, Mathf.Cos (ConstanteAngle.ALLEMAGNE)));
			allAudioPosition.Add ("2_Chine", new Vector3 (Mathf.Sin (ConstanteAngle.CHINE), 0, Mathf.Cos (ConstanteAngle.CHINE)));
			allAudioPosition.Add ("3_Meurthe_et_Mozelle", new Vector3 (Mathf.Sin (ConstanteAngle.MEURTHE_ET_MOZEL), 0, Mathf.Cos (ConstanteAngle.MEURTHE_ET_MOZEL)));
			allAudioPosition.Add ("3_Serbie", new Vector3 (Mathf.Sin (ConstanteAngle.SERBIE), 0, Mathf.Cos (ConstanteAngle.SERBIE)));
			allAudioPosition.Add ("4_Indochine", new Vector3 (Mathf.Sin (ConstanteAngle.INDOCHINE), 0, Mathf.Cos (ConstanteAngle.INDOCHINE)));
			allAudioPosition.Add ("4_Pyrenes", new Vector3 (Mathf.Sin (ConstanteAngle.PYRENEES), 0, Mathf.Cos (ConstanteAngle.PYRENEES)));
			allAudioPosition.Add ("5_Canada", new Vector3 (Mathf.Sin (ConstanteAngle.CANADA), 0, Mathf.Cos (ConstanteAngle.CANADA)));
			allAudioPosition.Add ("5_Madagascar", new Vector3 (Mathf.Sin (ConstanteAngle.MADAGASCAR), 0, Mathf.Cos (ConstanteAngle.MADAGASCAR)));
			allAudioPosition.Add ("6_Martinique", new Vector3 (Mathf.Sin (ConstanteAngle.MARTINIQUE), 0, Mathf.Cos (ConstanteAngle.MARTINIQUE)));
			allAudioPosition.Add ("6_Tchad", new Vector3 (Mathf.Sin (ConstanteAngle.TCHAD), 0, Mathf.Cos (ConstanteAngle.TCHAD)));
			allAudioPosition.Add ("7_Dakar", new Vector3 (Mathf.Sin (ConstanteAngle.DAKAR), 0, Mathf.Cos (ConstanteAngle.DAKAR)));
			allAudioPosition.Add ("7_Grece", new Vector3 (Mathf.Sin (ConstanteAngle.GRECE), 0, Mathf.Cos (ConstanteAngle.GRECE)));
			allAudioPosition.Add ("8_Algerie", new Vector3 (Mathf.Sin (ConstanteAngle.ALGERIE), 0, Mathf.Cos (ConstanteAngle.ALGERIE)));
			allAudioPosition.Add ("8_Turquie", new Vector3 (Mathf.Sin (ConstanteAngle.TURQUIE), 0, Mathf.Cos (ConstanteAngle.TURQUIE)));
			allAudioPosition.Add ("9_Cuisse_la_motte_front", new Vector3 (Mathf.Sin (ConstanteAngle.CUISSE_LA_MONTTE_FRONT), 0, Mathf.Cos (ConstanteAngle.CUISSE_LA_MONTTE_FRONT)));
			allAudioPosition.Add ("9_Sri_lanka", new Vector3 (Mathf.Sin (ConstanteAngle.SRI_LANTA), 0, Mathf.Cos (ConstanteAngle.SRI_LANTA)));
			allAudioPosition.Add ("10_Meuse_front", new Vector3 (Mathf.Sin (ConstanteAngle.MEUSE_FRONT), 0, Mathf.Cos (ConstanteAngle.MEUSE_FRONT)));
			allAudioPosition.Add ("10_Russie", new Vector3 (Mathf.Sin (ConstanteAngle.RUSSIE), 0, Mathf.Cos (ConstanteAngle.RUSSIE)));
			allAudioPosition.Add ("11_Marne", new Vector3 (Mathf.Sin (ConstanteAngle.MARNE), 0, Mathf.Cos (ConstanteAngle.MARNE)));
			allAudioPosition.Add ("12_Pas_de_calais", new Vector3 (Mathf.Sin (ConstanteAngle.PAS_DE_CALAIS), 0, Mathf.Cos (ConstanteAngle.PAS_DE_CALAIS)));

		}

		private void getAllPerson(){
			String[] allDirectories = Directory.GetDirectories (Application.dataPath + "/Resources");



			foreach (string d in allDirectories) {
				List<string> allInformations = new List<string> ();
				string[] d2 = d.Split('\\');
				allInformations.Add (d2 [1]);
				DirectoryInfo infos = new DirectoryInfo (d);

				foreach (FileInfo info in infos.GetFiles()) {
					string[] extension = info.ToString().Split('.');
					if ((extension [1] == "wav" || extension [1] == "mp3") && extension.Length == 2) {
						string[] file = info.ToString().Split('\\');
						string fileWithoutExtension = file [file.Length - 1].Split ('.') [0];

						if (fileWithoutExtension != "start") {
							allInformations.Add (fileWithoutExtension);
						}
					}
				}
				if (allInformations.Count > 0) {
					allPersons.Add (new List<string>(randomSort(allInformations)));
				}

			}
			randomSort (allPersons);
		}

		public bool IsReady ()
		{
			return _countDownSlider.CurrentState == Counter.CounterState.STOP;
		}

		public void RegisterEventEndCountDown (GameManager.EndEvent end)
		{
			_endEventCountDown = end;
		}

		public void InitUI (GameManager manager)
		{
			_gameManager = manager;

			Dictionary<GestureManager.GestureTypes, object> listActiveGestures = _gameManager.GetCurrentActiveGestures ();
			_listSliders = new Dictionary<GestureManager.GestureTypes, Slider> ();
			foreach (KeyValuePair<GestureManager.GestureTypes, object> gesture in listActiveGestures) {
				GameObject go = GameObject.Instantiate (prefabSliderUI);
				go.transform.SetParent (ListGesturePivot);
				go.transform.localScale = Vector3.one;
				go.transform.localPosition = Vector3.zero;
				go.name = gesture.Key.ToString ();
				go.GetComponentInChildren<Text> ().text = go.name;

				_listSliders.Add (gesture.Key, go.GetComponentInChildren<Slider> ());
			}
		}

		public void UpdateTimerLoadingGesture (GestureManager.GestureTypes type, float percent)
		{
			Slider currentSlider = GetSliderBasedType (type);
			currentSlider.image.color = Color.green;
			currentSlider.value = percent;
		}

		private void moveSound(){

		}

		public void UpdateSliderBlockingGesture (GestureManager.GestureTypes type, float timer)
		{
			Slider currentSlider = GetSliderBasedType (type);

			_countDownSlider.StartTimerUpdatePercentage (timer, () => {
				currentSlider.value = 0;
				currentSlider.image.color = Color.green;

				if (_endEventCountDown != null)
					_endEventCountDown (type);

			}, (float percent) => {
				currentSlider.image.color = Color.red;
				currentSlider.value = Mathf.Clamp01 (1 - percent);
			});

			CurrentGestureText.text = type.ToString ();
			UseGesture(type);
			moveSound ();
		}

		private IEnumerator decreasedSound(){
			float coeff = 0.2f;
			while(ambiantSound.volume > 0f) {
				pasSound.volume -= coeff;

				ambiantSound.volume -= coeff;
				//ambiantSound.UnPause ();
				kidsSound.volume -= coeff;
				essouflementSound.volume -= coeff;
				battementSound.volume -= coeff;
				yield return new WaitForSeconds (1);
			}
			ambiantSound.Pause ();
			changePerson ();
		}

		private IEnumerator increasedSound(){
			float coeff = 0.17f;
			float coeffSoundO = 0.25f;
			deadSound.volume = 0;
			onPlay = false;
			currentInformation = 0;
			ambiantSound.UnPause ();
			while(ambiantSound.volume < 0.7f) {
				pasSound.volume += coeffSoundO;

				ambiantSound.volume += coeff;
				kidsSound.volume += coeffSoundO;
				essouflementSound.volume += coeffSoundO;
				battementSound.volume += coeffSoundO;
				yield return new WaitForSeconds (1);
			}
		}

		private void stopAllSound(){
			
			StartCoroutine (decreasedSound());

		}

		private void startAllSound(){
			
			StartCoroutine (increasedSound());
		}

		private void changeAttribute(int direction){
			if (onPlay) {
				if (currentInformation + direction < 0) {
					if (currentPerso == 0) {
						currentPerso = allPersons.Count - 1;
					} else {
						currentPerso--;
					}
					changePerson ();
				} else if (currentInformation + direction > allPersons[currentPerso].Count - 1) {
					currentPerso = (currentPerso + 1) % allPersons.Count;
					changePerson ();
				} else if (currentInformation + direction == 0) {
					currentInformation = 0;
					AudioClip currentClip = Resources.Load<AudioClip> (allPersons [currentPerso] [0] + "/start");
					deadSound.clip = currentClip;
					deadSound.Stop ();
					deadSound.Play ();
				} else {
					currentInformation += direction;
					AudioClip currentClip = Resources.Load<AudioClip> (allPersons [currentPerso] [0] + "/" + allPersons [currentPerso] [currentInformation]);
					deadSound.clip = currentClip;
					Debug.Log ("audioClip : " + currentClip.length + " : " + UnityEngine.Random.value);
					deadSound.transform.position = allAudioPosition [allPersons [currentPerso] [0]];
					deadSound.Play ();
				}
			}

		}

		private void changePerson(){
			currentInformation = 0;
			AudioClip currentClip = Resources.Load<AudioClip> (allPersons[currentPerso][0] + "/start");
			deadSound.clip = currentClip;
			deadSound.transform.position = allAudioPosition [allPersons [currentPerso] [0]];
			deadSound.Play();
			onPlay = true;
		}

		public void UseGesture(GestureManager.GestureTypes type){


			switch(type){
			// Next information
			case GestureManager.GestureTypes.SwipingLeft:
				changeAttribute (1);
				break;
				// previous information
			case GestureManager.GestureTypes.SwipingRight:
				changeAttribute (-1);
				break;
				// Arrêt
			case GestureManager.GestureTypes.FaceDown:
				startAllSound();
				break;
				// Lancement des informations
			case GestureManager.GestureTypes.SwipingUp:
				currentPerso = (currentPerso + 1) % allPersons.Count;
				stopAllSound ();

				//changePerson ();
				break;
			default:
				Debug.Log("launch ambiance music");
				break;
			}
		}

		#endregion

		#region Addition

		Slider GetSliderBasedType (GestureManager.GestureTypes type)
		{
			if (_listSliders.ContainsKey (type)) {
				return _listSliders [type];
			}
			return _listSliders [0];
		}

		#endregion
	}
}