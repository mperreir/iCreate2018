using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using ZXing;
using ZXing.QrCode;


public class CameraForQR : MonoBehaviour {

    private WebCamTexture camTexture;
    private Rect screenRect;
    
    void Start()
    {
        screenRect = new Rect(0, 0, Screen.width, Screen.height);

        camTexture = new WebCamTexture(WebCamTexture.devices[1].name);
        camTexture.requestedHeight = Screen.height;
        camTexture.requestedWidth = Screen.width;
        if (camTexture != null)
        {
            camTexture.Play();
        }
    }

    public string EvalQR()
    {
        // drawing the camera on screen
        // GUI.DrawTexture(screenRect, camTexture, ScaleMode.ScaleToFit);

        // do the reading — you might want to attempt to read less often than you draw on the screen for performance sake
        try
        {
            IBarcodeReader reader = new BarcodeReader();
            // decode the current frame
            var result = reader.Decode(camTexture.GetPixels32(), camTexture.width, camTexture.height);
            if (result != null)
                return result.Text;
        }
        catch (System.Exception ex) {
            Debug.LogWarning(ex.Message);
        }
        return null;
    }

}
