using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class StarScript : MonoBehaviour {

	public int num = 0;
	public int age = 0;
	public Vector3 galaxyPosition = new Vector3();
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
	
	// Update is called once per frame
	void Update()
	{
		if (this.galaxy == null)
		{
			this.transform.position = this.transform.position + new Vector3(Time.deltaTime * Mathf.Sin(Time.time * 5F + (this.num / 50F)), 0, 0);
		}
		else if (!this.attached)
		{
			if (Vector3.Distance(this.transform.position, this.galaxy.transform.position - this.galaxyPosition) < Time.deltaTime * this.joinSpeed)
			{
				this.attached = true;
				this.transform.SetParent(this.galaxy.transform);
				this.transform.transform.position = this.galaxy.transform.position - this.galaxyPosition;
			}
			else
			{
				this.transform.transform.position = Vector3.MoveTowards(this.transform.position, this.galaxy.transform.position - this.galaxyPosition, this.joinSpeed * Time.deltaTime);
			}
		}
	}

	public void MoveTo(GalaxyScript galaxy)
	{
		this.galaxy = galaxy;
		this.galaxyPosition = Random.insideUnitSphere*galaxy.radius;
		this.attached = false;
	}

	public void FreeStar(GameObject newParent)
	{
		this.galaxy = null;
		this.transform.SetParent(newParent.transform);
		this.attached = false;
	}
}
