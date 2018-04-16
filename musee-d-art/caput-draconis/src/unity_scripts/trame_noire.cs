using ZXing;
using ZXing.Common;

﻿using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using UnityEngine.UI;
using UnityEngine.SceneManagement;

using SharpOSC;

public class trame_noire : MonoBehaviour
{
    void Start()
    {
        AudioSource audio = GetComponent<AudioSource>();
        audio.Play();
    }

    void Update()
    {
        if (Input.GetKey("escape"))
            Application.Quit();
        if (Input.GetKey("r"))
            SceneManager.LoadScene("main_scene", LoadSceneMode.Single);
    }
}
