using ZXing;
using ZXing.Common;

﻿using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using UnityEngine.UI;
using UnityEngine.SceneManagement;

public class main_scene : MonoBehaviour
{

    private string scene_name = "main_scene";
    public string decodedResult;
    WebCamTexture webCamTexture;
    BarcodeReader barcodeReader;
    //Webcam Feed
    public RawImage rawimage;
    //Final display
    public Image tableau;

    void Start()
    {
        var formats = new List<BarcodeFormat>();
        formats.Add(BarcodeFormat.QR_CODE);

        barcodeReader = new BarcodeReader
        {
            AutoRotate = false,
            Options = new DecodingOptions
            {
                PossibleFormats = formats,
                TryHarder = true,
            }
        };

        WebCamDevice[] devices = WebCamTexture.devices;

        foreach (WebCamDevice wc in devices)
            Debug.Log(wc.name);

        int i = 0;

        if(devices.Length > 1)
            i = 1;

        webCamTexture = new WebCamTexture(devices[i].name, 1280, 720);

        rawimage.texture = webCamTexture;
        rawimage.material.mainTexture = webCamTexture;

        webCamTexture.Play();
    }

    void Update()
    {
        if (webCamTexture != null && webCamTexture.isPlaying)
            DecodeQR();
        if (Input.GetKey("escape"))
            Application.Quit();
        if (Input.GetKey("r"))
            SceneManager.LoadScene(scene_name, LoadSceneMode.Single);

    }

    void DecodeQR()
    {
        if (webCamTexture == null)
            return;

        Result result = barcodeReader.Decode(
                            webCamTexture.GetPixels32(),
                            webCamTexture.width,
                            webCamTexture.height);

        if (result != null)
        {
            //QR Code result
            decodedResult = result.Text;
            //Displaying the right scene
            SceneManager.LoadScene(result.Text, LoadSceneMode.Single);
        }
    }

    void OnDestroy()
    {
        if (webCamTexture != null)
            webCamTexture.Stop();
    }
}
