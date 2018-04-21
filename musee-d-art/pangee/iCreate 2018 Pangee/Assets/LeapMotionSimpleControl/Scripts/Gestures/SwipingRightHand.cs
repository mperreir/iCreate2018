/*******************************************************
 * Copyright (C) 2016 Ngan Do - dttngan91@gmail.com
 *******************************************************/
using UnityEngine;
using System.Collections;
using Leap;

namespace LeapMotionSimpleControl
{
	public class SwipingRightHand : BehaviorHand
	{		
		private GameObject parent;
		private GameObject water;
		private Material waterMaterial;
		private AudioSource a;

		// Use this for initialization
		protected void Awake ()
		{
			base.Awake ();
			CurrentType = GestureManager.GestureTypes.SwipingRight;
			specificEvent = onSwipeRightEvent;
			parent = GameObject.Find("ParentWater");
			water = parent.transform.GetChild(0).gameObject;
			waterMaterial = water.GetComponent<Renderer>().material;
			a = water.GetComponent<AudioSource>();
        }
	
		// Update is called once per frame
		void Update ()
		{
	
		}

		protected override bool checkConditionGesture ()
		{
			Hand hand = GetCurrent1Hand ();
			if (hand != null) {
				if (isOpenFullHand (hand) && isMoveRight (hand)) {
					return true;
				}
			}
			return false;
		}
        void onSwipeRightEvent()
		{
			if (water.active == false)
			{
				water.SetActive(true);
				a.volume = (float)0.2;
				waterMaterial.SetVector("WaveSpeed", new Vector4(0,0,0,0));
			}

			//Augmentation de l'intensité du vent
			else
			{
				Vector4 v1 = waterMaterial.GetVector("WaveSpeed");
				Vector4 v2 = new Vector4(v1.x - 20, v1.y, v1.z, v1.w );
				float scale = waterMaterial.GetFloat("WaveScale");

				if (v2.x < 0)
					a.volume += (float)0.2;
				else a.volume -= (float)0.2;

				if (v2.x >= -100)
				{
					waterMaterial.SetFloat("WaveScale", scale +(float)0.02);
					waterMaterial.SetVector("WaveSpeed", v2);
				}
			}
        }
    }
}