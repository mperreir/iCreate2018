using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class mvt : MonoBehaviour {
	private Vector3 target1 = new Vector3(-11, 0, 0);
	private Vector3 target2 = new Vector3(11, 0, 0);
	private Vector3 target;
    private float speed = 1;

    // Use this for initialization
	void Start () {
		target = target2;
    }
	
	// Update is called once per frame
	void Update () {
		float step = speed * Time.deltaTime;

		transform.position = Vector3.MoveTowards(transform.position, target, step);

        if (transform.position.x > 8 && target==target2)
        {
			target = target1;
        }
        if (transform.position.x < -9 && target==target1)
		{
			target = target2;
        }

    }
}
