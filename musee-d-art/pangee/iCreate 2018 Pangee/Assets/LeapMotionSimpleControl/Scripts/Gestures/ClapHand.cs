/*******************************************************
 * Copyright (C) 2016 Ngan Do - dttngan91@gmail.com
 *******************************************************/
using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using Leap;

namespace LeapMotionSimpleControl
{
	public class ClapHand : BehaviorHand
	{

		// Use this for initialization
		protected void Awake ()
		{
			base.Awake ();
			CurrentType = GestureManager.GestureTypes.ClapHand;
            specificEvent = onClapHandEvent;

        }
	
		// Update is called once per frame
		void Update ()
		{
	
		}

		protected override bool checkConditionGesture ()
		{
			List<Hand> currentList = GetCurrent2Hands ();
			if (currentList != null) {
				Hand leftHand = currentList [0].IsLeft ? currentList [0] : currentList [1];
				Hand rightHand = currentList [0].IsRight ? currentList [0] : currentList [1];
				if (leftHand == null || rightHand == null) {
					Debug.Log ("Please present the correct left hand and right hand");
				} else {
					if (isOpenFullHand (leftHand) && isOpenFullHand (rightHand)
					  && isOppositeDirection (leftHand.PalmNormal, rightHand.PalmNormal)
					  && isOppositeDirection (leftHand.PalmVelocity, rightHand.PalmVelocity)
					  && isHandMoveForward (leftHand) && isHandMoveForward (rightHand)) {
						return true;
					}

				}
			}
			return false;
		}
        void onClapHandEvent()
        {
			//On desactive tous les effets lors d'un changement de saison
            GameObject parent1 = GameObject.Find("ParentWater");
            GameObject water = parent1.transform.GetChild(0).gameObject;
            GameObject parent2 = GameObject.Find("ParentFrozen");
            GameObject frozen = parent2.transform.GetChild(0).gameObject;
            GameObject parent3 = GameObject.Find("ParentSplashIn");
            GameObject waterSplash = parent3.transform.GetChild(0).gameObject;
            water.SetActive(false);
            frozen.SetActive(false);
            waterSplash.SetActive(false);

			// Changement du tableau a chaque clap dans l'ordre des saison
			GameObject parent = GameObject.Find("ParentNympheas");
			GameObject nympheas = parent.transform.GetChild(0).gameObject;

            SpriteRenderer nym = nympheas.GetComponent<SpriteRenderer>();
            if (nym.sprite == Resources.Load("automne", typeof(Sprite)) as Sprite)
            {
                nym.sprite = Resources.Load("hiver", typeof(Sprite)) as Sprite;
                AudioSource a = nympheas.GetComponent<AudioSource>();
                a.clip = Resources.Load("HIVER", typeof(AudioClip)) as AudioClip;
                a.Play();
            }
            else if (nym.sprite == Resources.Load("hiver", typeof(Sprite)) as Sprite)
            {
                nym.sprite = Resources.Load("printemps", typeof(Sprite)) as Sprite;
                AudioSource a = nympheas.GetComponent<AudioSource>();
                a.clip = Resources.Load("PRINTEMPS", typeof(AudioClip)) as AudioClip;
                a.Play();
                Debug.Log(a.clip);
            }
            else if (nym.sprite == Resources.Load("printemps", typeof(Sprite)) as Sprite)
            {
                nym.sprite = Resources.Load("été", typeof(Sprite)) as Sprite;
                AudioSource a = nympheas.GetComponent<AudioSource>();
                a.clip = Resources.Load("ETE", typeof(AudioClip)) as AudioClip;
                a.Play();
            }
            else if (nym.sprite == Resources.Load("été", typeof(Sprite)) as Sprite)
            {
                nym.sprite = Resources.Load("automne", typeof(Sprite)) as Sprite;
                AudioSource a = nympheas.GetComponent<AudioSource>();
                a.clip = Resources.Load("AUTOMNE", typeof(AudioClip)) as AudioClip;
                a.Play();
            }

			Debug.Log("Changement de saison (Clap)");
    
        }
    }
}

