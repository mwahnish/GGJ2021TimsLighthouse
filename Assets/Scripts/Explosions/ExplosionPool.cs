using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ExplosionPool : MonoBehaviour
{
    [SerializeField]
    private GameObject explosionPrefab;

    private List<ExplosionController> checkedInExplosions = new List<ExplosionController>();

    public ExplosionController AssignToShip(GameObject target)
    {
        ExplosionController explosionController = null;

        if (checkedInExplosions.Count == 0)
            explosionController = GameObject.Instantiate(explosionPrefab).GetComponent<ExplosionController>();
        else
        {
            explosionController = checkedInExplosions[0];
            checkedInExplosions.RemoveAt(0);
        }

        //explosionController.transform.position = this.transform.position;


        explosionController.gameObject.SetActive(false);

        explosionController.AssignToShip(this, target);

        return explosionController;
    }

    public void CheckInExplosion(ExplosionController marker)
    {
        marker.transform.parent = this.transform;

        marker.transform.position = Vector3.up * 1000f;
        if (!checkedInExplosions.Contains(marker))
            checkedInExplosions.Add(marker);
    }
}
