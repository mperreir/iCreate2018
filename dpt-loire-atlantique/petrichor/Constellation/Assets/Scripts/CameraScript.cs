using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CameraScript : MonoBehaviour {

	private Vector3 InitPos;
	private Quaternion InitRot;
	private GameObject target;
	private bool done;

	public float Speed = 5;
	public float RotationSpeed = 0.5F;
	public float TargetDistance = 10;
	public Vector3 up = new Vector3(0, 1, 0);

	// Use this for initialization
	void Start () {
		this.InitPos = this.transform.position;
		this.InitRot = this.transform.rotation;
	}
	
	// Update is called once per frame
	void Update () {
		if (this.target == null)
		{
			this.transform.position = Vector3.MoveTowards(this.transform.position, this.InitPos, this.Speed * Time.deltaTime);
			this.transform.rotation = Quaternion.RotateTowards(this.transform.rotation, this.InitRot, this.RotationSpeed * Time.deltaTime);
		}
		else
		{
			this.transform.rotation = Quaternion.RotateTowards(this.transform.rotation, Quaternion.LookRotation(this.target.transform.position - this.transform.position, this.up), this.RotationSpeed * Time.deltaTime);
			float distance = Vector3.Distance(this.target.transform.position, this.transform.position);
			if (distance > this.TargetDistance)
			{
				this.transform.position = Vector3.MoveTowards(this.transform.position, this.target.transform.position, Mathf.Min(distance, this.Speed * Time.deltaTime));
			}
		}
	}

	void MoveTo(GameObject target)
	{
		this.target = target;
	}

	void Free()
	{
		this.target = null;
	}
}
