using ZXing;
using ZXing.Common;

﻿using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using UnityEngine.UI;
using UnityEngine.SceneManagement;

public class trame_noire : MonoBehaviour
{
    void Update()
    {
        if (Input.GetKey("escape"))
            Application.Quit();
        if (Input.GetKey("r"))
            SceneManager.LoadScene("main_scene", LoadSceneMode.Single);
    }
}
