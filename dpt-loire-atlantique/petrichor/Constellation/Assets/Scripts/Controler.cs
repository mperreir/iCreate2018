using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Controler : MonoBehaviour {

	private float NextChangeTime;

	public CameraScript cam;
	public StarManager SM;
	public int StarsPerKey = 100;
	public float CameraChangeTime = 5;
	public float CameraInitTime = 10;
	public bool changeTime;

	// Use this for initialization
	void Start ()
	{
		this.NextChangeTime = Time.time + this.CameraInitTime;
		this.changeTime = false;
	}
	
	// Update is called once per frame
	void Update () {
		if (Input.GetButtonDown("key"))
		{
			this.KeyAction();
		}
		if (Input.GetButtonDown("tab"))
		{
			this.TabAction();
		}
		if (Input.GetButtonDown("ding"))
		{
			this.DingAction();
		}
		if (Input.GetButtonDown("return"))
		{
			this.ReturnAction();
		}
		if (Time.time > this.NextChangeTime)
		{
			this.NextChangeTime = Time.time + this.CameraChangeTime;
			this.cam.MoveTo(this.SM.NextGalaxy());
		}
		if (changeTime) {
			this.NextChangeTime = Time.time + this.CameraInitTime;
			this.changeTime = false;
		}
	}

	public void KeyAction()
	{
		this.SM.numStars = this.StarsPerKey;
		this.SM.starsWaiting = true;
	}

	public void TabAction()
	{
		this.SM.nextcriteria = true;
		this.cam.Free();
		this.changeTime = true;
	}

	public void DingAction()
	{
		this.SM.Scint();
	}

	public void ReturnAction()
	{
		this.SM.noStars = true;
		this.cam.Free();
		this.changeTime = true;
	}
}
