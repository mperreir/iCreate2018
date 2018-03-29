using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SoundRotation : MonoBehaviour {

	public float radius, seconds;
	public int beginAngle;
	
	private float angle, speed;
	private AudioSource audio;
		
	// Use this for initialization
	void Start () {
		angle = beginAngle;
		speed = 4f * radius;
		audio = gameObject.GetComponent<AudioSource>();
		StartCoroutine(PlayDelayedClip());
	}
	 
	IEnumerator PlayDelayedClip()
	{
		yield return new WaitForSeconds(seconds);
		if(!audio.isPlaying)
			audio.Play();
	}

	// Update is called once per frame
	private void Update () {
		angle = (angle + (Time.deltaTime * speed)) % 360f;
		float radian = angle * 0.0174532925f;
		transform.localPosition = new Vector3(radius * Mathf.Cos(radian), transform.localPosition.y, radius * Mathf.Sin(radian));
	}
	
	
}
