using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MusicController : MonoBehaviour
{
    [SerializeField]
    private AudioSource audiosource;

    [SerializeField]
    private List<AudioClip> songs = new List<AudioClip>();

    // Start is called before the first frame update
    void Start()
    {

        StartCoroutine(PlaySong());
    }

    int index = 0;

    private IEnumerator PlaySong()
    {
        Debug.Log("Playing");
        AudioClip selection = songs[index];
        audiosource.PlayOneShot(selection);
        while (audiosource.isPlaying)
            yield return null;

        index = (int)Mathf.Repeat(index + 1, songs.Count-1);
        StartCoroutine(PlaySong());
    }

    
}
