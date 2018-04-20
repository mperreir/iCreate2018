using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class FacingCamera : MonoBehaviour {

	public Vector3 up = new Vector3(0, 1, 0);
	public bool useup = false;
	public bool flip = false;

	// Use this for initialization
	void Start () {
		
	}
	
	// Update is called once per frame
	void Update () {
		Vector3 targetpos = Camera.main.transform.position;
		if (flip)
		{
			targetpos = 2 * this.transform.position - targetpos;
		}
		if (this.useup)
		{
			this.transform.LookAt(targetpos, this.up);
		}
		else
		{
			this.transform.LookAt(targetpos);
		}
	}
}
