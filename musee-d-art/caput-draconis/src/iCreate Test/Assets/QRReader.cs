using ZXing;
using ZXing.Common;

﻿using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using UnityEngine.UI;

public class QRReader : MonoBehaviour
{

    public string decodedResult;
    WebCamTexture webCamTexture;
    BarcodeReader barcodeReader;
    //Webcam Feed
    public RawImage rawimage;
    //Final display
    public Image tableau;
    //Array of paintings
    Sprite[] sprites;
    //Association of sprites with their names
    Dictionary<string, Sprite> dict = new Dictionary<string, Sprite>();

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

        webCamTexture = new WebCamTexture(devices[1].name, 1280, 720);

        rawimage.texture = webCamTexture;
        rawimage.material.mainTexture = webCamTexture;

        webCamTexture.Play();

        //Loading of all exisiting sprites
        sprites = Resources.LoadAll<Sprite>("Sprites/");
        //Adding in the dictionnary, with the name (string) in key
        foreach (Sprite s in sprites)
            dict.Add(s.name, s);
    }

    void Update()
    {
        if (webCamTexture != null && webCamTexture.isPlaying)
            DecodeQR();
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
            //Displaying the right painting
            tableau.sprite = dict[result.Text];
        }
    }

    void OnDestroy()
    {
        if (webCamTexture != null)
            webCamTexture.Stop();
    }
}
