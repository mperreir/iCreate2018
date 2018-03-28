using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using ZXing;

public class ReadBarcodeFromFile : MonoBehaviour {

    public Texture2D inputTexture;
    // Use this for initialization
    void Start () {

        // create a barcode reader instance
        IBarcodeReader reader = new BarcodeReader();
        // get texture Color32 array
        var barcodeBitmap = inputTexture.GetPixels32();
        // detect and decode the barcode inside the Color32 array
        var result = reader.Decode(barcodeBitmap, inputTexture.width, inputTexture.height);
        // do something with the result
        if (result != null)
        {
            Debug.Log(result.BarcodeFormat.ToString());
            Debug.Log(result.Text);
        }

    }
	
	// Update is called once per frame
	void Update () {
		
	}
}
