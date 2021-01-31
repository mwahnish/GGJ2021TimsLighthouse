using System.Collections;
using System.Collections.Generic;
using System.Linq;
using UnityEngine;

public class PushFiringMode : FiringModeBase
{
    [SerializeField]
    private float aoeRadius = 10f;

    [SerializeField]
    private AOEPool aoeController;

    [SerializeField]
    MissilePool missilePool;

    public override int cost => 10;

    public override void Fire(List<GameObject> targets)
    {

        foreach (GameObject target in targets)
        {
            missilePool.FireMissile(target, () =>
            {
                //AsteroidController asteroid = target.GetComponent<AsteroidController>();
                //asteroid.lockZAxis = false;

                AsteroidController[] asteroids = FindObjectsOfType<AsteroidController>().Where(x => Vector3.Distance(x.transform.position, target.transform.position) < aoeRadius).ToArray();

                foreach (AsteroidController asteroid in asteroids)
                {
                    asteroid.lockZAxis = false;
                    asteroid.GetComponent<Rigidbody>().AddForce(Vector3.down * 800);
                }
                aoeController.ShowAtPosition(target.transform.position);


            });
        }
    }
}
