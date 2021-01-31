using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class AsteroidRegion : MonoBehaviour
{
    [SerializeField]
    private float _radius = 30f;

    [SerializeField]
    private List<GameObject> asteroidPrefabs = new List<GameObject>();


    [SerializeField]
    public int numberOfAsteroids = 0;

    private List<GameObject> asteroidsInPlay = new List<GameObject>();

    public float radius
    {
        get {
            return _radius;
        }
    }

    private void Start()
    {

        StartCoroutine(ManageAsteroids());
    }


    

    private bool waitingToDeleteAsteroid = false;

    private IEnumerator ManageAsteroids()
    {
        while (numberOfAsteroids == asteroidsInPlay.Count)
            yield return null;

        if (numberOfAsteroids > asteroidsInPlay.Count)
            SpawnAsteroid();
        else if (asteroidsInPlay.Count > 0)
        {
            waitingToDeleteAsteroid = true;
            while (waitingToDeleteAsteroid)
                yield return null;
        }

        StartCoroutine(ManageAsteroids());
    }

    private void SpawnAsteroid()
    {
        GameObject selectedPrototype = asteroidPrefabs[Random.Range(0, asteroidPrefabs.Count - 1)];
        GameObject newAsteroid = GameObject.Instantiate(selectedPrototype,Vector3.right * 10000, Quaternion.identity);
        newAsteroid.transform.parent = this.transform;
        asteroidsInPlay.Add(newAsteroid);
    }

    public void AsteroidFinishedRoute(GameObject asteroid)
    {
        asteroid.GetComponent<AsteroidController>().lockZAxis = true;
        if (waitingToDeleteAsteroid)
        {
            if(asteroidsInPlay.Contains(asteroid))
            {
                asteroidsInPlay.Remove(asteroid);
                waitingToDeleteAsteroid = false;
            }
        }
    }

    private void OnDrawGizmos()
    {
#if UNITY_EDITOR
        UnityEditor.Handles.DrawWireDisc( this.transform.position, Vector3.up, radius);
#endif
    }
}
