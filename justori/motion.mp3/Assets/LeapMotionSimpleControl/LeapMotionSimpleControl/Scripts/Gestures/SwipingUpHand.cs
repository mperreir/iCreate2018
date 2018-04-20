/*******************************************************
 * Copyright (C) 2016 Ngan Do - dttngan91@gmail.com
 *******************************************************/
using UnityEngine;
using System.Collections;
using Leap;
using UnityEngine.UI;

namespace LeapMotionSimpleControl
{
	public class SwipingUpHand : BehaviorHand
	{

        public Utilisateur user;
        // Use this for initialization
        protected void Awake ()
		{
			base.Awake ();
			CurrentType = GestureManager.GestureTypes.SwipingUp;
            specificEvent = OnSwipeEvent;
		}
	
		// Update is called once per frame
		void Update ()
		{
	
		}

		protected override bool checkConditionGesture ()
		{
			Hand hand = GetCurrent1Hand ();
			if (hand != null) {
				if (isOpenFullHand (hand) && isMoveUp (hand) && isPalmNormalSameDirectionWith (hand, Vector3.up)) {
					return true;
				}
			}
			return false;
		}

        
        void OnSwipeEvent()
        {
            
        }
        

    }
}