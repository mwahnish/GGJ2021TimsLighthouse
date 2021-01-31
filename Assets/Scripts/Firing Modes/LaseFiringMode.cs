using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class LaseFiringMode : FiringModeBase
{
    [SerializeField]
    MissilePool missilePool;

    [SerializeField]
    MarkerPool markers;


    public override int cost => 1;

    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        
    }

    public override void Fire(List<GameObject> targets)
    {
        foreach (GameObject target in targets)
        {
            missilePool.FireMissile(target, () =>
            {

                target.GetComponent<Collider>().enabled = false;
                AsteroidController asteroid = target.GetComponent<AsteroidController>();
                if (asteroid != null)
                    markers.AssignToAsteroid(asteroid);

            });
        }
    }
}
