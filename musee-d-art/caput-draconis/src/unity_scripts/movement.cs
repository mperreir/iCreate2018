using System;
using System.Linq;
﻿using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using SharpOSC;

public class movement : MonoBehaviour {

	Rigidbody rigidbody;
  BoxCollider boxcollider;
  Vector3 v;
  	UDPListener listener;
  	OscMessage messageReceived;

	string s;
	float x;
	float y;

	// Use this for initialization
	void Start () {
		rigidbody = GetComponent <Rigidbody> ();
    		messageReceived = null;
    		listener = new UDPListener(55555);

    boxcollider = GetComponent<BoxCollider>();
    boxcollider.enabled = false;

	}

	// Update is called once per frame
	void Update () {

		messageReceived = (OscMessage)listener.Receive();
		if(messageReceived != null)
		{
      boxcollider.enabled = true;
			s = (string) messageReceived.Arguments[0];
			string[] w = s.Split(',');

	    x = -(Int32.Parse(w[0]) - 200);
			y = -(Int32.Parse(w[1]) - 240);
			v.Set(x, y, 10);

			rigidbody.MovePosition(v);
		}
	}

	void OnDestroy() {
     		print("Script was destroyed");
      		listener.Close();
  	}
}
