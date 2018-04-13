using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class stream : MonoBehaviour {

    public string url = "https://appr.tc/r/099526651";
    // Use this for initialization
    IEnumerator Start()
    {
        using (WWW www = new WWW(url))
        {
            yield return www;
            Renderer renderer = GetComponent<Renderer>();
            renderer.material.mainTexture = www.texture;
        }
    }

    // Update is called once per frame
    void Update () {
		
	}
}
