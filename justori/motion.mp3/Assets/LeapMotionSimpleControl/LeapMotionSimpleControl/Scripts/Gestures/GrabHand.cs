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

        public Utilisateur user;
        public GameObject CurrentHoldingObj;

		Vector3 _savedBallPosition;
		bool _isHoldingBall = false;

        int countNotGrab = 0;
      

        Vector posDebut;
        Vector orientationDebut;

		// Use this for initialization
		protected void Awake ()
		{
			base.Awake ();
			CurrentType = GestureManager.GestureTypes.Grab;
			specificEvent = onGrab;
			//_savedBallPosition = CurrentHoldingObj.transform.position;
		}
	
		// Update is called once per frame
		void Update ()
		{
		}

		protected void FixedUpdate ()
		{
			base.FixedUpdate ();
			//updateBall ();
		}

		protected override bool checkConditionGesture ()
		{
			Hand hand = GetCurrent1Hand ();
			if (hand != null) {
                if (isGrabHand(hand) && !checkIndexHand(hand) && !user.audioSelected)
                {
                    return true;
                } else
                {
                    onRelease();
                }
            }
			return false;
		}

        void onGrab()
        {

            Hand hand = GetCurrent1Hand();

            if (!_isHoldingBall)
            {
                posDebut = hand.PalmPosition;
                orientationDebut = hand.Direction;
                _isHoldingBall = true;
            }
            Vector orientation = hand.Direction;

        }

        void onRelease()
        {
            if (_isHoldingBall)
            {
                countNotGrab++;
                if (countNotGrab >= 20)
                {
                    countNotGrab = 0;
                    _isHoldingBall = false;
                    Vector posRelease = GetCurrent1Hand().PalmPosition;
                    Vector difference = posRelease - posDebut;
                    if (difference.Magnitude >= 0.05)
                    {
                        chooseAudio();
                    }
                }
            }
        }

        void chooseAudio()
        {
            Hand hand = GetCurrent1Hand();
            if(hand != null)
            {
                Vector projete = orientationDebut;
                projete.y = 0;
                float angleToX = Mathf.Rad2Deg * (projete.AngleTo(new Vector(1, 0, 0)));
                projete = orientationDebut;
                projete.x = 0;
                float angleToZ = Mathf.Rad2Deg * (projete.AngleTo(new Vector(0, 0, 1)));

                if (angleToZ <= 45)
                {
                    int indice = (int)angleToX / 30;
                    print("histoire selectionnée : " + indice);
                    user.selectStory(indice);
                }
            }

        }


        void grabBall ()
		{
			//Debug.Log ("Grab");
			_isHoldingBall = true;
		}

		void releaseBall ()
		{
			//Debug.Log ("Release");
			_isHoldingBall = false;
			CurrentHoldingObj.transform.position = _savedBallPosition;

		}

		void updateBall ()
		{
			bool isUpdating = false;
			if (_isHoldingBall) {
				Hand hand = GetCurrent1Hand ();
				if (hand != null) {
					if (isGrabHand (hand)) {
						if (CurrentHoldingObj != null) {
							CurrentHoldingObj.transform.position = UnityVectorExtension.ToVector3 (hand.PalmPosition + hand.PalmNormal.Normalized * 0.03f);
							isUpdating = true;
						}
					}
				}

				if (!isUpdating)
					releaseBall ();
			}
		}


	}
}