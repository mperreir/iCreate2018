using UnityEngine;

public class ComportementLaine : MonoBehaviour
{
    void Update()
    {
        transform.Rotate(Vector3.right, Time.deltaTime*10);
        transform.Rotate(Vector3.up, Time.deltaTime*10, Space.World);
    }
}
