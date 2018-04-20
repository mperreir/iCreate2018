using System.Collections;
using System.Collections.Generic;
using UnityEngine;


public class MusicPlayer : MonoBehaviour
{
    public AudioClip clip;  // Drag the clip here on the editor
    private AudioSource au;

    void Start()
    {
        au = GetComponent<AudioSource>();
        au.loop = true;
        au.Play();
    }

}
