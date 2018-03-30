using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class UIController : MonoBehaviour {

    public rawimg1 myraw;

	// Use this for initialization
	void Start () {

	}
	
	// Update is called once per frame
	void Update () {

	}

    public void popWebCam()
    {
        myraw.transform.position += new Vector3(673, 319, 0);
    }

}
