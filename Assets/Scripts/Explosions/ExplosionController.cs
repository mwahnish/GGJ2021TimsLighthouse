using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ExplosionController : MonoBehaviour
{
    public void AssignToShip(ExplosionPool pool, ShipController target)
    {
        this.transform.position = target.transform.position + (Vector3.up * 3);
        this.gameObject.SetActive(true);
        GetComponent<AudioSource>().Play();
        StartCoroutine(AssignToShipInternal(pool, target));
    }

    private IEnumerator AssignToShipInternal(ExplosionPool pool, ShipController target)
    {
        yield return new WaitForSeconds(6f);
        pool.CheckInExplosion(this);
        this.gameObject.SetActive(false);
    }
}
