/*******************************************************
 * Copyright (C) 2016 Ngan Do - dttngan91@gmail.com
 *******************************************************/
using UnityEngine;
using System.Collections;
using Leap;
using UnityEngine.UI;


namespace LeapMotionSimpleControl
{
	public class FaceDownHand : BehaviorHand
	{
        public Slider slider_volume;
        Hand hand;
        public Utilisateur user;
        // Use this for initialization
        protected void Awake ()
		{
			base.Awake ();
			CurrentType = GestureManager.GestureTypes.FaceDown;
            specificEvent = OnFaceDown;
        }
	
		// Update is called once per frame
		void Update ()
		{
	
		}

		protected override bool checkConditionGesture ()
		{
			Hand hand_check = GetCurrent1Hand ();
			if (hand_check != null) {
				if (isOpenFullHand (hand_check) && isStationary (hand_check) && isPalmNormalSameDirectionWith (hand_check, -Vector3.up) && !checkIndexHand(hand_check)) {
                    this.hand = hand_check;
                    return true;
				}
			}
			return false;
		}

        void OnFaceDown()
        {
            // On peut monter le son uniquement si l'utilisateur a déjà attrapé un son
            // On vérifie s'il possède un son
            
            if (this.user.audioSelected)
            {
                // Si oui, alors cela monte le son
                float valeur_slider_future = (this.hand.PalmPosition.y - 0.76f) / (1.30f - 0.76f);
                //print("Valeur future : " + valeur_slider_future + "valeur actuelle : " + slider_volume.value);

                if (valeur_slider_future > slider_volume.value)
                {
                    // L'utilisateur veut monter le son alors que ce geste diminue, on ne fait rien
                }
                else
                {
                    slider_volume.value = valeur_slider_future;
                    print("Son descend à : " + this.user.son_selectionne.son.volume);
                }
                

            }
        }
    }
}