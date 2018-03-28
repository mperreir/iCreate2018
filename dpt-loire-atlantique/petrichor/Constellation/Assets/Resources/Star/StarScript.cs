using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class StarScript : MonoBehaviour {

	public int num = 0;
	public int age = 0;
	public string residence = null;
	public string grade = null;
	public string profession = null;
	public string naissance = null;
	public string volontaire = null;

	// Use this for initialization
	void Start()
	{
	}

	// Update is called once per frame
	void Update()
	{
		this.transform.position = this.transform.position + new Vector3(Mathf.Sin(Time.time*5F + (this.num / 50F ))/10F, 0, 0);
	}
}
