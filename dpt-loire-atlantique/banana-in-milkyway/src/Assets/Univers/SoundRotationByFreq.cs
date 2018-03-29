using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SoundRotation : MonoBehaviour {

	public float radius, frequency;
	public int beginAngle;
	
	private float angle, speed;
	private AudioSource audio;
	private int counter;
		
	// Use this for initialization
	void Start () {
		angle = beginAngle;
		speed = 4f * radius;
		audio = gameObject.GetComponent<AudioSource>();
		counter = 1;
	}

	// Update is called once per frame
	private void Update () {
		angle = (angle + (Time.deltaTime * speed)) % 360f;
		float radian = angle * 0.0174532925f;
		transform.localPosition = new Vector3(radius * Mathf.Cos(radian), transform.localPosition.y, radius * Mathf.Sin(radian));
		
		counter++;
		if(counter > 100){
			counter = 0;
			if(Random.value < frequency && !audio.isPlaying){
				Debug.Log("Paly !");
				audio.Play();
			}
		}
	}
}
