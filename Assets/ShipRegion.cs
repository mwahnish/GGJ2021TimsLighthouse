using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ShipRegion : MonoBehaviour
{
    [SerializeField]
    private float _radius = 30f;

    [SerializeField]
    private List<GameObject> shipPrefabs = new List<GameObject>();


    [SerializeField]
    private int numberOfShips = 0;

    private List<GameObject> shipsInPlay = new List<GameObject>();

    public float radius
    {
        get
        {
            return _radius;
        }
    }

    private void Start()
    {

        StartCoroutine(ManageShips());
    }




    private bool waitingToDeleteShip = false;

    private IEnumerator ManageShips()
    {
        while (numberOfShips == shipsInPlay.Count)
            yield return null;

        if (numberOfShips > shipsInPlay.Count)
            SpawnShip();
        else if (shipsInPlay.Count > 0)
        {
            waitingToDeleteShip = true;
            while (waitingToDeleteShip)
                yield return null;
        }

        StartCoroutine(ManageShips());
    }

    private void SpawnShip()
    {
        GameObject selectedPrototype = shipPrefabs[Random.Range(0, shipPrefabs.Count - 1)];
        GameObject newAsteroid = GameObject.Instantiate(selectedPrototype, Vector3.right * 10000, Quaternion.identity);
        newAsteroid.transform.parent = this.transform;
        shipsInPlay.Add(newAsteroid);
    }

    public void ShipFinishedRoute(GameObject asteroid)
    {
        if (waitingToDeleteShip)
        {
            if (shipsInPlay.Contains(asteroid))
            {
                shipsInPlay.Remove(asteroid);
                waitingToDeleteShip = false;
            }
        }
    }

    private void OnDrawGizmos()
    {
#if UNITY_EDITOR
        UnityEditor.Handles.DrawWireDisc(this.transform.position, Vector3.up, radius);
#endif
    }
}
