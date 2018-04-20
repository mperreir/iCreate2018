/*******************************************************
 * Copyright (C) 2016 Ngan Do - dttngan91@gmail.com
 *******************************************************/
using UnityEngine;
using System.Collections;
using Leap;
using Leap.Unity;

namespace LeapMotionSimpleControl
{
    public class JeterHand : BehaviorHand
    {

        public Utilisateur user;

        // Use this for initialization
        protected void Awake()
        {
            base.Awake();
            CurrentType = GestureManager.GestureTypes.Jeter;
            specificEvent = JeterSon;
        }

        // Update is called once per frame
        void Update()
        {

        }

        protected override bool checkConditionGesture()
        {
            Hand hand = GetCurrent1Hand();
            if (hand != null)
            {
                Vector directionMove = hand.PalmNormal;
                directionMove.y = 0;

                float angleMove = Mathf.Rad2Deg*(directionMove.AngleTo(new Vector(1, 0, 0)));
                if((angleMove >= 60) && (angleMove <= 120))
                {
                    if (isPalmNormalSameDirectionWith(hand, UnityVectorExtension.ToVector3(hand.PalmVelocity))
                       && !isStationary(hand))
                    {
                        return true;
                    }
                }

            }
            return false;
        }

        void JeterSon()
        {

            if (this.user.audioSelected)
            {
                this.user.audioSelected = false;
                this.user.son_selectionne.son.Stop();
                this.user.son_selectionne = null;
                this.user.ResetAllSound();
                print("Son jeté!");
            }
            else
            {
                print("Impossible de jeter car aucun son possédé");
            }
            
        }

        
    }

}