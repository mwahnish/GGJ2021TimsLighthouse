using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class AOEController : MonoBehaviour
{
    

    public void ShowAtPosition(AOEPool pool, Vector3 position)
    {
        GetComponent<AudioSource>().Play();
        GetComponent<Animation>().Play(); ;
        this.transform.position = position;
        StartCoroutine(Hide(pool));
    }

    private IEnumerator Hide(AOEPool pool)
    {
        yield return new WaitForSeconds(2f);
        pool.CheckInAOE(this);
    }
}
