using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class CameraMove : MonoBehaviour {

    public float cameraSpeed = 1f;
    public float distanceToCenter = 20f;
    public RawImage screenPrefab;
    public Canvas canvas;

    private GameObject target;
    private GameObject center;
    private Vector3 wantedPosition;
    private RawImage screen;

	// Use this for initialization
	void Start () {
        center = GameObject.Find("Center");
	}
	
	// Update is called once per frame
	void Update () {
        // Acquire target
        if (Input.GetKeyDown(KeyCode.F))
        {
            target = GameObject.Find("France");
            wantedPosition = target.transform.position + Vector3.Normalize(target.transform.position - center.transform.position) * distanceToCenter;
            if (screen != null)
                Destroy(screen);
        }
        else if (Input.GetKeyDown(KeyCode.A))
        {
            target = GameObject.Find("Allemagne");
            wantedPosition = target.transform.position + Vector3.Normalize(target.transform.position - center.transform.position) * distanceToCenter;
            if (screen != null)
            {
                print("coucou");
                Destroy(screen);
            }
        }

        // If any target, go to computed position
        if (target != null)
        {
            transform.position = Vector3.Slerp(transform.position, wantedPosition, cameraSpeed * Time.deltaTime);
            transform.LookAt(center.transform.position);
            if (Vector3.Distance(transform.position, wantedPosition) < 0.5f && screen == null)
            {
                screen = Instantiate(screenPrefab);
                screen.transform.SetParent(canvas.transform);
                screen.transform.position +=  new Vector3(337, 160, 0);
            }
        }
    }
}
