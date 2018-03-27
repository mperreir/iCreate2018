using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class StarScript : MonoBehaviour {

	public int num;
	public int age;
	public string residence;
	public string grade;
	public string profession;
	public string naissance;
	public string volontaire;

	// Use this for initialization
	void Start()
	{
		this.num = 0;
		this.age = 0;
		this.residence = null;
		this.grade = null;
		this.profession = null;
		this.naissance = null;
		this.volontaire = null;
	}

	// Update is called once per frame
	void Update()
	{
		this.transform.position = this.transform.position + new Vector3(Mathf.Sin(Time.time*5F + (num / 5F ))/10F, 0, 0);
	}
}
