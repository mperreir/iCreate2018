using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class vidéo : MonoBehaviour {

	// Use this for initialization
	void Start () {
        GameObject parent = GameObject.Find("VideoMonet");
        UnityEngine.Video.VideoPlayer c = parent.GetComponent<UnityEngine.Video.VideoPlayer>();
        c.Play();

	}
	
	// Update is called once per frame
	void Update () {
		
	}
}
