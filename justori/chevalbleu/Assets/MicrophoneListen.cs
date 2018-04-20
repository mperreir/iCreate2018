using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System.Linq;

public class MicrophoneListen : MonoBehaviour
{
    AudioSource audioSource;
    public static float avg;
    public static float peak;

    // Use this for initialization
    void Start()
    {
        if (Application.platform == RuntimePlatform.Android)
        {
        }
        else
        {
            audioSource = GetComponent<AudioSource>();
            audioSource.clip = Microphone.Start("Built-in Microphone", true, 100000, 44100);
            //audioSource.loop = true;
            while (!(Microphone.GetPosition(null) > 0)) { }
            audioSource.Play();
            InvokeRepeating("ObtainValuesBitch", 0.1f, 3.0f);
        }
            
    }

    // Update is called once per frame
    void Update()
    {
    }

    void ObtainValuesBitch()
    {
        float[] spectrum = new float[256];
        audioSource.GetSpectrumData(spectrum, 0, FFTWindow.Rectangular);
        avg = 0;
        for (int i = 0; i < 15; i++)
        {
            avg = avg + spectrum[i];

        }
        avg = avg / 15;
        float maxValue = spectrum.Max();
        int maxIndex = spectrum.ToList().IndexOf(maxValue);
        peak = (maxIndex * AudioSettings.outputSampleRate) / 250;
    }
}
