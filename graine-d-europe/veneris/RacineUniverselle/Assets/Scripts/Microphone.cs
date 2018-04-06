using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Microphone : MonoBehaviour {

    // Use this for initialization
    void Start()
    {
        string[] micros = Microphone.devices;
        AudioSource aud = GetComponent<AudioSource>();
        aud.clip = Microphone.Start("Built-in Microphone", true, 10, 44100);
        aud.Play();
    }

    // Update is called once per frame
    void Update () {
		
	}
}
