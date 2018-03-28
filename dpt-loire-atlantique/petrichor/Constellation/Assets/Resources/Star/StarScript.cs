﻿using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class StarScript : MonoBehaviour {

	public int num = 0;
	public int age = 0;
	public float galaxyDistance = 0;
	public float joinSpeed = 2;
	public string residence = null;
	public string grade = null;
	public string profession = null;
	public string naissance = null;
	public string volontaire = null;
	public GalaxyScript galaxy = null;
	public bool attached = false;

	// Use this for initialization
	void Start()
	{
	}

	public void MoveTo(GalaxyScript galaxy)
	{
		this.galaxy = galaxy;
		this.galaxyDistance = Random.value*galaxy.radius;
		this.attached = false;
	}

	// Update is called once per frame
	void Update()
	{
		if (this.galaxy == null)
		{
			this.transform.position = this.transform.position + new Vector3(Time.deltaTime * Mathf.Sin(Time.time * 5F + (this.num / 50F)), 0, 0);
		}
		else if (!attached)
		{
			if (Vector3.Distance(this.galaxy.transform.position, this.transform.position) < this.galaxyDistance)
			{
				this.attached = true;
				this.transform.SetParent(this.galaxy.transform);
			}
			else
			{
				this.transform.transform.position = Vector3.MoveTowards(this.transform.position, this.galaxy.transform.position, this.joinSpeed * Time.deltaTime);
			}
		}
	}
}
