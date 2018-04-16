using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class StarScript : MonoBehaviour {

	private bool Scint = false;
	private float ScintTo = 0;
	private Vector3 galaxyPosition = new Vector3();
	private bool attached = false;

	public int num = 0;
	public int age = 0;
	public string residence = null;
	public string grade = null;
	public string profession = null;
	public string naissance = null;
	public string volontaire = null;
	public float joinSpeed = 2;
	public float ScintProb = 0.1F;
	public float ScintProbActive = 0.5F;
	public float ScintTime = 0.2F;
	public bool ScintActive = false;
	public GalaxyScript galaxy = null;

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
		if (this.Scint)
		{
			if (Time.time > this.ScintTo)
			{
				this.Scint = false;
				this.GetComponent<SpriteRenderer>().enabled = true;
			}
		}
		else
		{
			if (this.ScintActive)
			{
				if (Random.value < this.ScintProbActive * Time.deltaTime)
				{
					this.Scint = true;
					this.GetComponent<SpriteRenderer>().enabled = false;
					this.ScintTo = Time.time + this.ScintTime;
				}
			}
			else
			{
				if (Random.value < this.ScintProb * Time.deltaTime)
				{
					this.Scint = true;
					this.GetComponent<SpriteRenderer>().enabled = false;
					this.ScintTo = Time.time + this.ScintTime;
				}
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
