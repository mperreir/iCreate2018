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

        public Utilisateur user;
        // Use this for initialization
        protected void Awake ()
		{
			base.Awake ();
			CurrentType = GestureManager.GestureTypes.SwipingRight;
            specificEvent = onSwipeEvent;
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

        void onSwipeEvent()
        {
            // TODO : your own logic 
            Debug.Log("On retourne dans le temps");

            // Si on ecoute de la musique en ce moment
            if(this.user.audioSelected)
            {
                this.user.effet_rewind.son.Play();
                // On ecoute une musique, donc on va remonter de 10 secondes
                if (this.user.son_selectionne.son.time > 10.0f)
                {
                    this.user.son_selectionne.son.time = this.user.son_selectionne.son.time - 2.0f;
                }
                else
                {
                    // Si on est dans les 10 premières secondes, on ne peut aller avant 0, donc on place à 0
                    this.user.son_selectionne.son.time = 0.0f;
                }
            }

        }
    }
}