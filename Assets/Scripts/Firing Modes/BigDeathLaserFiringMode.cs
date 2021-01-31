using System.Collections;
using System.Collections.Generic;
using System.Linq;
using UnityEngine;

public class BigDeathLaserFiringMode : FiringModeBase
{
    [SerializeField]
    private ExplosionPool explosionPool;

    [SerializeField]
    BigDeathLaserController bigDeathLaser;

    [SerializeField]
    private float fireTime;

    public override int cost => 55;


    public override void Fire(List<GameObject> targets)
    {
        ExploadTargets(targets);
        StartCoroutine(ContinueFiring());
        bigDeathLaser.Fire();
    }

    private IEnumerator ContinueFiring()
    {
        LaserBeam laser = FindObjectOfType<LaserBeam>();
        float startTime = Time.time;
        yield return null;
        while (Time.time < startTime + fireTime )
        {
            ExploadTargets(laser.targets.Select(x=>x.gameObject).ToList());
            yield return null;
        }

    }

    private void ExploadTargets(List<GameObject> targets)
    {
        foreach (GameObject target in targets)
        {
            AsteroidController asteroid = target.GetComponent<AsteroidController>();
            if (asteroid != null)
            {
                explosionPool.AssignToShip(target);
                asteroid.Kill();
            }
        }
    }
}
