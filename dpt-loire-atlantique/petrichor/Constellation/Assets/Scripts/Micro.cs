using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Micro : MonoBehaviour {
    AudioSource mic;
    string[] devices;

	// Use this for initialization
	void Start () {
        devices = Microphone.devices;
        print(devices[0]);
        mic = GetComponent<AudioSource>();
        mic.clip = Microphone.Start(devices[0], true, 10000, 44100);
        mic.Play();
    }
	
	// Update is called once per frame
	void Update () {
		
	}
}
