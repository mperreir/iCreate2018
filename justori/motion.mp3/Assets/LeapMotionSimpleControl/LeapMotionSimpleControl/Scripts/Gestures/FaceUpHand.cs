/*******************************************************
 * Copyright (C) 2016 Ngan Do - dttngan91@gmail.com
 *******************************************************/
using UnityEngine;
using System.Collections;
using Leap;
using UnityEngine.UI;

namespace LeapMotionSimpleControl
{
	public class FaceUpHand : BehaviorHand
	{
        public Slider slider_volume;
        public Utilisateur user;
        // Use this for initialization
        protected void Awake ()
		{
			base.Awake ();
			CurrentType = GestureManager.GestureTypes.FaceUp;
            specificEvent = OnFaceUp;
        }
	
		// Update is called once per frame
		void Update ()
		{
	
		}

		protected override bool checkConditionGesture ()
		{
			Hand hand = GetCurrent1Hand ();
			if (hand != null) {
				if (isOpenFullHand (hand) && isStationary (hand) && isPalmNormalSameDirectionWith (hand, Vector3.up)) {
					return true;
				}
			}
			return false;
		}

        void OnFaceUp()
        {
            // On peut monter le son uniquement si l'utilisateur a déjà attrapé un son
            // On vérifie s'il possède un son
            Hand hand = GetCurrent1Hand();
            if (this.user.audioSelected)
            {
                if(hand!=null)
                {
                    float valeur_slider_future = (hand.PalmPosition.y - 0.76f) / (1.0f - 0.76f);
                    // Si oui, alors cela monte le son
                    //print("Valeur future : " + valeur_slider_future + "valeur actuelle : " + slider_volume.value);
                    if (valeur_slider_future < slider_volume.value)
                    {
                        // L'utilisateur veut diminuer le son alors que ce geste augmente, on ne fait rien
                    }
                    else
                    {
                        slider_volume.value = valeur_slider_future;
                        print("Son monte à : " + this.user.son_selectionne.son.volume);
                    }
                }
                
            }
        }
    }
}