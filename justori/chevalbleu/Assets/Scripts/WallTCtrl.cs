using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class WallTCtrl : MonoBehaviour {

	// Use this for initialization
	void Start () {
		
	}
	
	// Update is called once per frame
	void Update () {
        if (Input.GetKeyDown("space"))
        {
            print("lol");
            this.transform.Rotate(90, 0, 0);
        }
    }
}
