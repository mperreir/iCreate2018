using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class rawimg2 : MonoBehaviour {

    public RawImage rawImage;
    // Use this for initialization
    void Start()
    {


        WebCamDevice[] webc = WebCamTexture.devices;
        WebCamTexture webcamTexture = new WebCamTexture(webc[0].name);

        rawImage.texture = webcamTexture;
        rawImage.material.mainTexture = webcamTexture;
        webcamTexture.Play();


        string[] micros = Microphone.devices;
        print("coucou");
        for (int i = 0; i <= 1; i++)
            print(micros[i]);
        AudioSource aud = GetComponent<AudioSource>();
        aud.clip = Microphone.Start("Logitech HD Webcam C270", true, 10, 44100);
        aud.loop = true;
        while (!(Microphone.GetPosition(null) > 0)) { }
        aud.Play();

    }

    // Update is called once per frame
    void Update()
    {

    }
}
