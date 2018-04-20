using UnityEngine;
using System.Collections;
using System.Collections.Generic;

using Leap;

namespace LeapMotionSimpleControl
{
    public class DoubleSwipingLeftHand : BehaviorHand
    {

        public Utilisateur user;
        // Use this for initialization
        protected void Awake()
        {
            base.Awake();
            CurrentType = GestureManager.GestureTypes.DoubleSwipingLeft;
            // add your custom event 
            specificEvent = onDoubleSwipeLeftEvent;
        }

        // Update is called once per frame
        void Update()
        {

        }

        protected override bool checkConditionGesture()
        {
            
            List<Hand> currentList = GetCurrent2Hands();
            if (currentList != null)
            {
                Hand leftHand = currentList[0].IsLeft ? currentList[0] : currentList[1];
                Hand rightHand = currentList[0].IsRight ? currentList[0] : currentList[1];
                if (leftHand == null || rightHand == null)
                {
                    Debug.Log("Please present the correct left hand and right hand");
                }
                else
                {
                    if(!this.user.audioSelected)
                    {
                        if (isOpenFullHand(leftHand))
                        {
                            if (isOpenFullHand(rightHand))
                            {
                                if (isMoveLeft(leftHand))
                                {
                                    if (isMoveLeft(rightHand))
                                    {
                                        return true;
                                    }
                                }
                            }
                        }
                    }
                    
                }
            }
            return false;
        }

        void onDoubleSwipeLeftEvent()
        {
            // TODO : your own logic 
            this.user.ChangerSceneDroite();

        }
    }
}
