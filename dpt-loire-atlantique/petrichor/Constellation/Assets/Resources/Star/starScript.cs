using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class starScript : MonoBehaviour {

	public int num = 0;
	// Use this for initialization
	void Start()
	{

	}

	// Update is called once per frame
	void Update()
	{
		this.transform.position = this.transform.position + new Vector3(Mathf.Sin(Time.time*5F + (num / 5F ))/10F, 0, 0);
	}
}
