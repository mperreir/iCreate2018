using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class CameraMove : MonoBehaviour {

    public float cameraSpeed = 1f;
    public float distanceToCenter = 20f;

    private GameObject target;
    private GameObject center;
    private Vector3 wantedPosition;

    public CameraForQR QR;
    public UIController uicontroller;

    // Use this for initialization
    void Start () {
        center = GameObject.Find("Center");
	}
	
	// Update is called once per frame
	void Update () {
        // Acquire target
        string myQR = QR.EvalQR();
        if (myQR != null)
        {
            target = GameObject.Find(myQR);
            wantedPosition = target.transform.position + Vector3.Normalize(target.transform.position - center.transform.position) * distanceToCenter;
        }

        // If any target, go to computed position
        if (target != null)
        {
            transform.position = Vector3.Slerp(transform.position, wantedPosition, cameraSpeed * Time.deltaTime);
            transform.LookAt(center.transform.position);
        }

        // Launch the webcam
        if (Vector3.Distance(transform.position, wantedPosition) < 1)
        {
            uicontroller.popWebCam();
        }
    }
    
}
