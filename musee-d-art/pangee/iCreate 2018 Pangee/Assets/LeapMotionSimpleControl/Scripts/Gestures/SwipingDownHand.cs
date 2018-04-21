/*******************************************************
 * Copyright (C) 2016 Ngan Do - dttngan91@gmail.com
 *******************************************************/
using UnityEngine;
using System.Collections;
using Leap;

namespace LeapMotionSimpleControl
{
	public class SwipingDownHand : BehaviorHand
	{

		private GameObject parent;
		private GameObject waterSplash;
		private GameObject bubble;
		private AudioSource a;
		private SimpleRainBehaviour con;

		// Use this for initialization
		protected void Awake ()
		{
			base.Awake ();
			CurrentType = GestureManager.GestureTypes.SwipingDown;
            specificEvent = onSwipeDownEvent;
			parent = GameObject.Find ("ParentSplashIn");
			waterSplash = parent.transform.GetChild (0).gameObject;
			bubble = waterSplash.transform.GetChild(0).gameObject;
			con = bubble.GetComponent<SimpleRainBehaviour>();
			a = bubble.GetComponent<AudioSource>();
        }
	
		// Update is called once per frame
		void Update ()
		{
	
		}

		protected override bool checkConditionGesture ()
		{
			Hand hand = GetCurrent1Hand ();
			if (hand != null) {
				if (isOpenFullHand (hand) && isMoveDown (hand) && isPalmNormalSameDirectionWith (hand, -Vector3.up)) {
					return true;
				}
			}
			return false;
        }
        void onSwipeDownEvent()
		{
			//Activation et reinitialisation des variables
			if (waterSplash.active == false) {
				waterSplash.SetActive (true);
				a.volume = (float)0.2;
				con.Variables.MaxRainSpawnCount = 5;
				con.Variables.LifetimeMin = (float)2.9;
				con.Variables.LifetimeMax = 3;
			}
			
			//Augmentation progressive de l'intensité
			else if (con.Variables.LifetimeMin > 1.5) {
                a.volume += (float)0.16;
				con.Variables.LifetimeMin -= (float)0.3;
				con.Variables.LifetimeMax -= (float)0.15;
				con.Variables.MaxRainSpawnCount += 5;
            }
		}
	}
}