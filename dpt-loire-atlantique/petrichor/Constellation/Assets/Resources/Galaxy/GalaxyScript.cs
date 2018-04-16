using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GalaxyScript : MonoBehaviour {

	public string galaxyTag = "";
	public float radius = 5;
	public float speed = 20;
	public Vector3 rotator = new Vector3(0, 1, 2);

	// Use this for initialization
	void Start () {
		
	}
	
	// Update is called once per frame
	void Update () {
		this.transform.Rotate(rotator, this.speed*Time.deltaTime);
	}
}
