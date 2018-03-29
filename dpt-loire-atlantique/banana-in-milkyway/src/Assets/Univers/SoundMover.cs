using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SoundMover : MonoBehaviour {

	public float duration, radius;

	private float progress;
	private Vector3 begin, turn, end;
	
	private Vector3 GetPoint (float t) {
		t = Mathf.Clamp01(t);
		float oneMinusT = 1f - t;
		return
			oneMinusT * oneMinusT * begin +
			2f * oneMinusT * t * turn +
			t * t * end;
	}
	
	private void RandTrajectory(){
		begin = end;
		end = new Vector3(Random.Range(-radius, radius), Random.Range(-radius, radius), Random.Range(-radius, radius));
		bool tmp = (Random.value > 0.5f);
		turn = new Vector3(tmp ? begin.x : (begin.x + (end.x - begin.x) / 2), begin.y, tmp ? (begin.z + (end.z - begin.z) / 2) : begin.z);
		progress = 0f;
	}
	
	// Use this for initialization
	void Start () {
		end = new Vector3(Random.Range(-radius, radius), Random.Range(-radius, radius), Random.Range(-radius, radius));
		RandTrajectory();
	}

	// Update is called once per frame
	private void Update () {
		progress += Time.deltaTime / duration;
		if (progress > 1f) {
			RandTrajectory();
		}

		Vector3 position = GetPoint(progress);
		transform.localPosition = position;
	}
}
