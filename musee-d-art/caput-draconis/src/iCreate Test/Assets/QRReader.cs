using ZXing;
using ZXing.Common;

﻿using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using UnityEngine.UI;

public class QRReader : MonoBehaviour {

		public string decodedResult;
    WebCamTexture webCamTexture;
    BarcodeReader barcodeReader;
		public RawImage rawimage;

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

				for(int i=0; i<devices.Length; i++)
					Debug.Log(devices[i].name);

        webCamTexture = new WebCamTexture(devices[0].name, 1280, 720);

				rawimage.texture = webCamTexture;
				rawimage.material.mainTexture = webCamTexture;

        webCamTexture.Play();
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
            decodedResult = result.Text;
    }

    void OnDestroy()
    {
        if (webCamTexture != null)
            webCamTexture.Stop();
		}
}
