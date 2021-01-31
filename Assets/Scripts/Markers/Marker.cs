using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Marker : MonoBehaviour
{
    private AsteroidController target;

   

    public void AssignToAsteroid(MarkerPool pool, AsteroidController asteroid)
    {
        GetComponent<PlayRandomSound>().PlayARandomSound(1f);
        StartCoroutine(FollowAsteroid(pool, asteroid));
    }
    
    private IEnumerator FollowAsteroid(MarkerPool pool, AsteroidController asteroid)
    {
        bool finishedFollowing = false;

        asteroid.onFinishedPath += () => {
            finishedFollowing = true;
        };

        while (!finishedFollowing)
        {
            this.transform.position = asteroid.transform.position;
            yield return null;
        }
        pool.CheckInMarker(this);
    }
}
