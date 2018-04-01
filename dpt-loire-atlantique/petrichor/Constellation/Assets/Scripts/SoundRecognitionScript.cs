﻿using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System.IO;

public class SoundRecognitionScript : MonoBehaviour
{
    // Fields
    float[][] spectrums;    // Spectrums of the prerocorded clips (computed with a python script)
    string[] devices;       // List of all the microphones
    AudioSource mic;        // Contains the AudioClip generated by listening to the microphone
    float time;             // Time since the last recognition was launch

    public Controler controler;

    // Use this for initialization
    void Start()
    {
        spectrums = new float[16][];
        time = 0;
        GetSpectrums();
        AnalyseClips();

        devices = Microphone.devices;
        print(devices[0]);
        mic = GetComponent<AudioSource>();
        mic.clip = Microphone.Start(devices[0], true, 10000, 44100);
        while (Microphone.GetPosition(devices[0]) < 50)
        {
        }
        mic.Play();
    }

    // Update is called once per frame
    void Update()
    {
        if(Time.time - time > 0.200)
        {
            time = Time.time;
            Recognize(mic);
        }
    }

    // Load prerecorded clips spectrums from a file
    void GetSpectrums()
    {
        StreamReader dataFile = new StreamReader(Application.streamingAssetsPath + "/fftResults.csv");
        for (int i=0; i<spectrums.Length; i++)
        {
            string line = dataFile.ReadLine();
            string[] elts = line.Split(';');
            float[] res = new float[elts.Length];
            for (int j=0; j<elts.Length-1; j++)
            {
                res[j] = float.Parse(elts[j]);
            }
            spectrums[i] = res;
        }
    }

    // Mean + vars of the prerecorded clips
    void AnalyseClips()
    {
        int l = spectrums.Length;
        for (int i = 0; i < l; i++)
        {
            Normalize(spectrums[i]);
        }
    }

    // Normalize an array
    void Normalize(float[] t)
    {
        float max = 0;
        for (int i=0; i<t.Length; i++)
        {
            if (t[i] > max) max = t[i];
        }
        for (int i= 0; i< t.Length; i++)
        {
            t[i] /= max;
        }
    }

    // Distance (euclidian) between two points
    float Dist(float[] t1, float[] t2)
    {
        float res = 0;
        for (int i= 0; i< Mathf.Min(t1.Length, t2.Length); i++)
        {
            res += Mathf.Pow(t1[i] - t2[i],2);
        }
        return Mathf.Sqrt(res);
    }

    // Trying to recognise a sound from the microphone
    void Recognize(AudioSource a)
    {
        // Analyse signal
        float[] spec = new float[256];
        a.GetSpectrumData(spec, 0, FFTWindow.Rectangular);
        Normalize(spec);

        // Comparison with prerecorded sounds
        float[] dists = new float[spectrums.Length];
        for (int i = 0; i < spectrums.Length; i++)
        {
            dists[i] = Dist(spectrums[i], spec);
        }
        float min = float.PositiveInfinity;
        int minId = 0;
        for (int i = 0; i < spectrums.Length; i++)
        {
            if (dists[i] < min)
            {
                minId = i;
                min = dists[i];
            }
        }

        // Recognition
        switch (minId)
        {
            case 0:
            case 1:
            case 2:
            case 3:
            case 4:
                print("Doigt " + min + " " + (minId));
                //controler.KeyAction();
                break;
            case 5:
            case 6:
            case 7:
            case 8:
            case 9:
                //print("Main " + min + " " + (minId - 5));
                break;
            case 10:
            case 11:
            case 12:
            case 13:
            case 14:
                print("Cloc " + min + " " + (minId - 10));
                break;
            default:
                break;
        }
    }

    void PrintTab(float[] t)
    {
        int l = t.Length;
        string res = "";
        for (int i = 0; i < l; i++)
        {
            res += "[" + t[i] + "]";
        }
        print(res);
    }

    void PrintTab(string[] t)
    {
        int l = t.Length;
        string res = "";
        for (int i = 0; i < l; i++)
        {
            res += "[" + t[i] + "]";
        }
        print(res);
    }
}