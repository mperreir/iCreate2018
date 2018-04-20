using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Networking;

public class ControlerAndroid : NetworkBehaviour {

    // Use this for initialization
    void Start () {
        transform.Rotate(0, 90, 0);
        transform.Translate(1, 1, 1);
        transform.position = new Vector3(19, 8, 250);
    }
	
	// Update is called once per frame
	void Update () {
        if (!isLocalPlayer)
        {
            return;
        }
    }

    public override void OnStartLocalPlayer()
    {
        GetComponent<MeshRenderer>().material.color = Color.blue;
    }
}
