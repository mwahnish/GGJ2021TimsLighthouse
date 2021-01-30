using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class LaseFiringMode : FiringModeBase
{
    [SerializeField]
    MissilePool missilePool;

    [SerializeField]
    MarkerPool markers;

    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        
    }

    public override void Fire(GameObject target)
    {
        missilePool.FireMissile(target, ()=> {
            AsteroidController asteroid = target.GetComponent<AsteroidController>();
            if (asteroid != null)
                markers.AssignToAsteroid(asteroid);
                
        });
    }
}
