/*******************************************************
 * Copyright (C) 2016 Ngan Do - dttngan91@gmail.com
 *******************************************************/
using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using Leap;

namespace LeapMotionSimpleControl
{
	public class FistHand : BehaviorHand
	{

		// Use this for initialization
		protected void Awake ()
		{
			base.Awake ();
			CurrentType = GestureManager.GestureTypes.Fist;
            specificEvent = onFistEvent;
        }
	
		// Update is called once per frame
		void Update ()
		{
	
		}

		protected override bool checkConditionGesture ()
		{
			Hand hand = GetCurrent1Hand ();
			if (hand != null) {
				if (isCloseHand (hand) && isStationary (hand)) {
					return true;
				}
			}
			return false;
		}
        void onFistEvent()
        {

            GameObject parent = GameObject.Find("ParentFrozen");
            GameObject frozen = parent.transform.GetChild(0).gameObject;
            Debug.Log("nassim Fist 1");
            if (frozen.active == false)
            {
                frozen.SetActive(true);
                Debug.Log("nassim Fist");
            }
            else
            {
                frozen.SetActive(false);
                /*GameObject bubble = waterSplash.transform.GetChild(0).gameObject;
                SimpleRainBehaviour con = bubble.GetComponent<SimpleRainBehaviour>();

                con.Variables.LifetimeMin += 2;
                con.Variables.LifetimeMax += 2;
                con.Variables.EmissionRateMin += 4;
                con.Variables.EmissionRateMax += 4;
                Debug.Log(con);*/

                
            }
        }

    }
}