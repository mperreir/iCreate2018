/*******************************************************
 * Copyright (C) 2016 Ngan Do - dttngan91@gmail.com
 *******************************************************/
using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using Leap;

namespace LeapMotionSimpleControl
{
    public class FingeredHand : BehaviorHand
    {

        int countNotGrab = 0;
        bool point = false;
        public Utilisateur user;
        // Use this for initialization
        protected void Awake()
        {
            base.Awake();
            CurrentType = GestureManager.GestureTypes.Fingered;
            specificEvent = OnFingered;

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
                if (checkIndexHand(hand)){
                    countNotGrab = 0;
                    point = true;
                    return true;
                }
            }

            Debug.Log("On pointe ou pas : " + point);
            if (point)
            {
                countNotGrab++;
                print("CountNotGrab : " + countNotGrab);
                if (countNotGrab > 10)
                {
                    countNotGrab = 0;
                    for (int i = 0; i < 6; i++)
                    {
                        if(this.user.audioSelected)
                        {
                            if (user.liste_des_histoires[i] != user.son_selectionne)
                            {
                                user.liste_des_histoires[i].son.volume = 0.05f;
                            }
                            else
                            {
                                user.liste_des_histoires[i].son.volume = 0.8f;
                            }
                        }
                        else
                        {
                            user.liste_des_histoires[i].son.volume = 0.5f;
                        }
                        Debug.Log("Histoire" + i + "baisée");
                        
                    }
                    for (int i = 0; i < 4; i++)
                    {
                        Debug.Log("Bruitage" + i + "baisée");
                        user.liste_des_bruitages[i].son.volume = 0.5f;
                    }
                    point = false;
                }
                
            }
            return false;
        }

        void OnFingered()
        {
            Hand hand = GetCurrent1Hand();
            if (hand != null)
            {

                Vector projete = hand.Direction;
                projete.y = 0;
                float angleToX = Mathf.Rad2Deg * (projete.AngleTo(new Vector(1, 0, 0)));
                projete = hand.Direction;
                projete.x = 0;
                float angleToZ = Mathf.Rad2Deg * (projete.AngleTo(new Vector(0, 0, 1)));

                if (angleToZ <= 33)
                {
                    int indice = (int)angleToX / 30;
                    print("Histoire pointée : " + indice);
                    for (int i = 0; i < 6; i++)
                    {
                        if (i == indice)
                        {
                            user.liste_des_histoires[i].son.volume = 0.8f;
                        }
                        else if(user.liste_des_histoires[i] != user.son_selectionne)
                        {
                            user.liste_des_histoires[i].son.volume = 0.05f;
                        }
                    }
                    for (int i = 0; i < 4; i++)
                    {
                        user.liste_des_bruitages[i].son.volume = 0.05f;
                    }


                }
                if (angleToZ > 33)
                {
                    int indice = (int)angleToX / 45;
                    print("Ambiance pointée : " + indice);
                    for (int i = 0; i < 6; i++)
                    {
                        if (i == indice)
                        {
                            user.liste_des_bruitages[i].son.volume = 0.8f;
                        }
                        else if (user.liste_des_bruitages[i] != user.son_selectionne)
                        {
                            user.liste_des_bruitages[i].son.volume = 0.05f;
                        }

                    }
                    for (int i = 0; i < 4; i++)
                    {
                        user.liste_des_histoires[i].son.volume = 0.05f;
                    }
                }
            }
        }
    }
}