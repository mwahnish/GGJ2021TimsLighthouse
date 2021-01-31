using System.Collections;
using System.Collections.Generic;
using System.Linq;
using UnityEngine;

public class JumpGateController : MonoBehaviour
{
    [SerializeField]
    private AudioSource openGateFX;

    [SerializeField]
    private AudioSource closeGateFX;

    JumpGatePool pool;
    public void ShowAtLocation(JumpGatePool pool, Vector3 position, bool playFX)
    {
        this.pool = pool;
        this.transform.position = position;
        GetComponent<Animator>().SetTrigger("Show");
        GetComponent<Animator>().ResetTrigger("Hide");
        if (playFX)
            openGateFX.Play();
        StartCoroutine(KickAsteroids());
    }

    private IEnumerator KickAsteroids()
    {
        yield return new WaitForSeconds(1f);
        AsteroidController[] asteroids = FindObjectsOfType<AsteroidController>().OrderBy(x=>Vector3.Distance(x.transform.position, this.transform.position)).ToArray();
        foreach(AsteroidController asteroid in asteroids)
        {
            Vector3 kickDirection = (asteroid.transform.position - this.transform.position).normalized;
            float amountOfKick = Mathf.Clamp01(30f - Vector3.Distance(asteroid.transform.position, this.transform.position));
            asteroid.GetComponent<Rigidbody>().AddForce(kickDirection * amountOfKick * 400f);
            yield return new WaitForSeconds(0.1f);
        }
        
    }


    public void Hide(bool playFX)
    {
        StartCoroutine(HideInternal(playFX));

    }

    private IEnumerator HideInternal(bool playFX)
    {
        if (playFX)
            closeGateFX.Play();
        GetComponent<Animator>().SetTrigger("Hide");
        GetComponent<Animator>().ResetTrigger("Show");
        yield return new WaitForSeconds(4f);
        
        pool.CheckInJumpGate(this);
    }
}
