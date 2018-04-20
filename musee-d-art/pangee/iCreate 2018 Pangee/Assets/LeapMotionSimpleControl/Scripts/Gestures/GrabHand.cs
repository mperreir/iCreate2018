/*******************************************************
 * Copyright (C) 2016 Ngan Do - dttngan91@gmail.com
 *******************************************************/
using UnityEngine;
using System.Collections;
using Leap;
using Leap.Unity;

namespace LeapMotionSimpleControl
{
	public class GrabHand : BehaviorHand
	{
		private GameObject parent;
		private GameObject frozen;
		private RainCameraController contr;

		// Use this for initialization
		protected void Awake ()
		{
			base.Awake ();
			CurrentType = GestureManager.GestureTypes.Grab;
			specificEvent = grabBall;
			parent = GameObject.Find("ParentFrozen");
			frozen = parent.transform.GetChild(0).gameObject;
			contr = frozen.GetComponent<RainCameraController>();
		}
	
		// Update is called once per frame
		void Update ()
		{
			if (contr.Alpha < (float)1.0)
				contr.Alpha += (float)0.01;
		}

		protected override bool checkConditionGesture ()
		{
			Hand hand = GetCurrent1Hand ();
			if (hand != null) {
				if (isGrabHand (hand) && isStationary(hand) && isPalmNormalSameDirectionWith (hand, Vector3.down))
					return true;
			}
			return false;
		}

		void grabBall ()
		{
			contr.Alpha = (float)0.0;	
			if (frozen.active == false) {
				frozen.SetActive (true);
			} else {
				frozen.SetActive (false);
			}
		}

	}
}