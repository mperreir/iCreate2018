using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Controler : MonoBehaviour {

	public CameraScript cam;
	public StarManager SM;
	public int StarsPerKey = 100;

	// Use this for initialization
	void Start () {
		
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
	}

	public void KeyAction()
	{
		this.SM.SpawnStars(this.StarsPerKey);
	}

	public void TabAction()
	{
		this.SM.NextCriteria();
	}

	public void DingAction()
	{
		this.SM.Scint();
	}

	public void ReturnAction()
	{
		this.SM.ResetStars();
	}
}
