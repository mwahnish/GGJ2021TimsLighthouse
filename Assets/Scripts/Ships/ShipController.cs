using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.AI;
public class ShipController : MonoBehaviour
{
    ShipRegion parentRegion;
    NavMeshAgent agent;

    [SerializeField]
    private GameObject shield;

    // Start is called before the first frame update
    void Start()
    {
        parentRegion = GetComponentInParent<ShipRegion>();
        agent = GetComponent<NavMeshAgent>();
        StartCoroutine(DoTravel());
    }

    // Update is called once per frame
    void Update()
    {
        
    }


    private IEnumerator DoTravel()
    {
        shield.SetActive(true);
        hitOnce = false;

        float positioningAngle = Random.Range(0, 360f);

        Vector3 startPosition = Quaternion.Euler(new Vector3(0, positioningAngle, 0)) * Vector3.forward * parentRegion.radius;
        agent.Warp(parentRegion.transform.position + startPosition);


        float firingAngle = Random.Range(0, 360f);
        Vector3 targetPosition = Quaternion.Euler(new Vector3(0, firingAngle, 0)) * Vector3.forward * parentRegion.radius;

        agent.SetDestination(parentRegion.transform.position + targetPosition);

        yield return new WaitForSeconds(2f);

        while (Vector3.Distance(this.transform.position, parentRegion.transform.position) < parentRegion.radius-1)
            yield return null;

        parentRegion.ShipFinishedRoute(this.gameObject);
        StartCoroutine(DoTravel());
    }

    bool hitOnce = false;

    private void OnCollisionEnter(Collision collision)
    {
        if (!hitOnce)
        {
            hitOnce = true;
            shield.SetActive(false);
            GetComponent<PlayRandomSound>().PlayARandomSound(1f);
        }
        else
        {

            parentRegion = GetComponentInParent<ShipRegion>();
            StopAllCoroutines();
            ExplosionPool explosion = FindObjectOfType<ExplosionPool>();
            explosion.AssignToShip(this);
            parentRegion.ShipFinishedRoute(this.gameObject);

            StartCoroutine(DoTravel());
        }
    }
}
