using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayRandomSound : MonoBehaviour
{
    [SerializeField]
    private List<AudioClip> sounds = new List<AudioClip>();

    public void PlayARandomSound(float velocity)
    {
        velocity = Mathf.Clamp01(velocity);
        AudioClip selectedClip = sounds[Random.Range(0, sounds.Count - 1)];
        GetComponent<AudioSource>().PlayOneShot(selectedClip, velocity);
    }
}
