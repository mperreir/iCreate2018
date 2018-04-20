/*******************************************************
 * Copyright (C) 2016 Ngan Do - dttngan91@gmail.com
 *******************************************************/
using UnityEngine;
using System.Collections;
using Leap;

namespace LeapMotionSimpleControl
{
	public class SwipingLeftHand : BehaviorHand
	{

        public Utilisateur user;
        // Use this for initialization
        protected void Awake ()
		{
			base.Awake ();
			CurrentType = GestureManager.GestureTypes.SwipingLeft;
			// add your custom event 
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
				if (isOpenFullHand (hand) && isMoveLeft (hand)) {
					return true;
				}
			}
			return false;
		}

		void onSwipeEvent(){
			// TODO : your own logic 
			Debug.Log("On avance dans le temps");
            // Si on ecoute de musique en ce moment
            
            if (this.user.audioSelected)
            {
                this.user.effet_forward.son.Play();
                // On ecoute une musique, donc on va avancer de 10 secondes
                // Peut etre vérifier qu'on ne dépasse pas la longueur max du son
                this.user.son_selectionne.son.time = this.user.son_selectionne.son.time + 2.0f;
                
            }
        }
	}
}