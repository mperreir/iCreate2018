/*******************************************************
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

		AudioSource deadSound, ambiantSound;

		List<List<string>> allPersons;

		List<string> informations = new List<string>();

		int currentPerso = -1;
		int currentInformation = 1;

		// Use this for initialization
		void Start ()
		{
			_countDownSlider = GetComponent<Counter> ();
			Debug.Log (Application.dataPath);
			Debug.Log("commence");
			AudioSource[] audioSources = UnityEngine.Object.FindObjectsOfType(typeof(AudioSource)) as AudioSource[];

			foreach(AudioSource audio in audioSources){
				
				switch(audio.name){
				case "AudioSource(Paroles)":
					Debug.Log("deadSound attributed");
					deadSound = audio;
					break;
				case "AudioSource(Ambiant)":
					Debug.Log("Ambiant attributed");
					ambiantSound = audio;
					break;
				default:
					Debug.Log(audio.name + " not attributed");
					break;
				}
			}

			//audioPizza = new WWW ("file://" + Application.dataPath + "/pizza.ogg").GetAudioClip ();
			//Debug.Log("file://" + Application.dataPath + "/pizza.ogg");
			//Debug.Log (audioPizza.length);


			/*AudioSource.PlayClipAtPoint(deadSound.clip, new Vector3(-1,0,0));
			AudioSource.PlayClipAtPoint(deadSound.clip, new Vector3(-2,0,0));*/

			deadSound.transform.position = new Vector3 (-1, 0, 0); 
			deadSound.Play ();

			informations.Add ("nomDossier");
			informations.Add ("age");
			informations.Add ("volontaire");

			allPersons = new List<List<string>>();
			getAllPerson();
			//testDecreasedSound (deadSound);

			StartCoroutine (testDecreasedSound(deadSound));
			ambiantSound.clip = Resources.Load<AudioClip> ("pizza");
			ambiantSound.Play ();
		}

		// Update is called once per frame
		void Update ()
		{

		}

		#region UI

		private IEnumerator testDecreasedSound(AudioSource audio){
			while(audio.volume > 0f) {
				audio.volume -= 0.05f;
				Debug.Log (audio.volume);
				yield return new WaitForSeconds (1);
			}
		}

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

		private void getAllPerson(){
			String[] allDirectories = Directory.GetDirectories (Application.dataPath + "/Resources");

			foreach (string d in allDirectories) {
				string[] d2 = d.Split('\\');
				informations [0] = d2[1];
				allPersons.Add (new List<string>(randomSort(informations)));
			}
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
			Debug.Log ("Change Gesture: " + type.ToString ());
			UseGesture(type);
			moveSound ();
		}

		private void stopAllSound(){
			Debug.Log("Stop All Sound");
			ambiantSound.Pause ();
		}

		private void changeAttribute(int direction){
			Debug.Log (currentPerso);
			Debug.Log (currentInformation);
			Debug.Log (direction);
			//Si nous sommes en train de jouer une musique
			if (deadSound.isPlaying) {
				// Revenir à la personne précédente
				if (direction + currentInformation < 0) {

					if (currentPerso + direction < 0) {
						currentPerso = allPersons.Count-1;
					} else {
						currentPerso--;
					}

					changePerson ();
				}
				// Sinon si on doit changer de personne
				else if (direction + currentInformation > allPersons [currentPerso].Count) {
					changePerson ();
				} else {
					Debug.Log ("PASSE ICI");
					currentInformation += direction;
					AudioClip currentClip = Resources.Load<AudioClip> (allPersons [currentPerso] [0] + "/" + allPersons [currentPerso] [currentInformation]);
					deadSound.clip = currentClip;
					deadSound.Play ();
				}
			}
		}

		private void changePerson(){
			currentPerso = (currentPerso+1)%allPersons.Count;
			currentInformation = 0;
			AudioClip currentClip = Resources.Load<AudioClip> (allPersons[currentPerso][0] + "/start");
			deadSound.clip = currentClip;
			deadSound.Play();
		}

		public void UseGesture(GestureManager.GestureTypes type){


			switch(type){
			// Next information
			case GestureManager.GestureTypes.SwipingLeft:
				Debug.Log ("launch sound swipingLeft");
				stopAllSound ();
				changeAttribute (1);
				break;
				// previous information
			case GestureManager.GestureTypes.SwipingRight:
				Debug.Log ("launch sound swipingRigth");
				stopAllSound ();
				changeAttribute (-1);
				break;
				// Arrêt
			case GestureManager.GestureTypes.FaceDown:
				Debug.Log("launch sound faceDown");
				stopAllSound();
				break;
				// Lancement des informations
			case GestureManager.GestureTypes.FaceUp:
				stopAllSound ();
				changePerson ();
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