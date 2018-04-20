using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class FrontText : MonoBehaviour {

	public float distance = 10;
	public Vector3 up = new Vector3(0, 3, 0);

	// Use this for initialization
	void Start () {
		
	}
	
	// Update is called once per frame
	void Update () {
		this.transform.position = Vector3.MoveTowards(this.transform.parent.transform.position, Camera.main.transform.position, this.distance) + this.up;
	}
}
