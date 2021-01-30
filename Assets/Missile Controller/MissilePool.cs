using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MissilePool : MonoBehaviour
{
    [SerializeField]
    private GameObject missilePrefab;

    private List<MissileController> CheckedInMissiles = new List<MissileController>();

    public MissileController FireMissile(GameObject target, System.Action onReachedTarget)
    {
        MissileController missileController = null;

        if (CheckedInMissiles.Count == 0)
            missileController = GameObject.Instantiate(missilePrefab).GetComponent<MissileController>();
        else {
            missileController = CheckedInMissiles[0];
            CheckedInMissiles.RemoveAt(0);
        }

        missileController.transform.position = this.transform.position;

        missileController.Fire(this,target, onReachedTarget);

        return missileController;
    }

    public void CheckInMissile(MissileController missile)
    {
        missile.transform.parent = this.transform;

        missile.transform.position = Vector3.up * 1000f;
        if (!CheckedInMissiles.Contains(missile))
            CheckedInMissiles.Add(missile);
    }
}
