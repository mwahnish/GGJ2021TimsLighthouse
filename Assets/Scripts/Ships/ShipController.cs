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

    [SerializeField]
    private AudioSource spawnSound;

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

    JumpGateController startGate;
    JumpGateController endGate;
    private IEnumerator DoTravel()
    {
        yield return new WaitForSeconds(2f);
        agent.enabled = true;
        shield.SetActive(true);
        hitOnce = false;

        // Calculating start area
        float positioningAngle = Random.Range(0, 360f);
        Vector3 startPosition = Quaternion.Euler(new Vector3(0, positioningAngle, 0)) * Vector3.forward * parentRegion.radius;

        // Calculating endPosition

        float firingAngle = Random.Range(0, 360f);
        Vector3 targetPosition = Quaternion.Euler(new Vector3(0, firingAngle, 0)) * Vector3.forward * parentRegion.radius;


        JumpGatePool jumpGatePool = FindObjectOfType<JumpGatePool>();

        startGate = jumpGatePool.ShowAtPosition(startPosition,true);

        yield return new WaitForSeconds(1f);

        endGate = jumpGatePool.ShowAtPosition(targetPosition,false);


        yield return new WaitForSeconds(1f);

        UIManager.instance.SetShipHealthMeter(1, 100);
        FiringModeManager.instance.currentEnergy = 100;
        UIManager.instance.ShowShipIcon(true);

        agent.Warp(parentRegion.transform.position + startPosition);
        spawnSound.Play();
        UIManager.instance.DisplayMessage(Assets.Scripts.UI.MessageKey.IncomingShip);

        agent.SetDestination(parentRegion.transform.position + targetPosition);

        yield return new WaitForSeconds(2f);

        startGate.Hide(false);
        startGate = null;

        while (Vector3.Distance(this.transform.position, targetPosition) > 10)
            yield return null;

        parentRegion.ShipFinishedRoute(this.gameObject);

        UIManager.instance.AppendScore(hitOnce ? 25: 50);
        UIManager.instance.DisplayMessage(Assets.Scripts.UI.MessageKey.ShipReachedGate);
        UIManager.instance.ShowShipIcon(false);

        endGate.Hide(true);
        endGate = null;
        agent.enabled = false;

        GameManager.instance.OnShipReturned();

        this.transform.position = Vector3.up * 1000f;
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
            UIManager.instance.SetShipHealthMeter(1, 50);
            UIManager.instance.DisplayMessage(Assets.Scripts.UI.MessageKey.ShieldsAt50);
        }
        else
        {
            startGate?.Hide(false);
            endGate?.Hide(true);
            parentRegion = GetComponentInParent<ShipRegion>();
            StopAllCoroutines();
            ExplosionPool explosion = FindObjectOfType<ExplosionPool>();
            explosion.AssignToShip(this.gameObject);
            parentRegion.ShipFinishedRoute(this.gameObject);
            agent.enabled = false;
            this.transform.position = Vector3.up * 1000f;
            UIManager.instance.SetShipHealthMeter(1, 0);
            UIManager.instance.DisplayMessage(Assets.Scripts.UI.MessageKey.ShipDestroyed);
            UIManager.instance.ShowShipIcon(false);
            GameManager.instance.OnShipKilled();
            StartCoroutine(DoTravel());
        }
    }
}
