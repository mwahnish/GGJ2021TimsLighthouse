using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.AI;

public class AsteroidController : MonoBehaviour
{
    AsteroidRegion parentRegion;
    Rigidbody rb;

    NavMeshObstacle obstacle;

    [SerializeField]
    private float minKickSpeed = 25f;


    [SerializeField]
    private float maxKickSpeed = 50f;

    [SerializeField]
    private float maxSpinSpeed = 5f;

    [SerializeField]
    private MeshRenderer renderer;

    public System.Action onFinishedPath;

    public bool lockZAxis = true;

    // Start is called before the first frame update
    void Start()
    {
        parentRegion = GetComponentInParent<AsteroidRegion>();
        rb = GetComponent<Rigidbody>();
        StartCoroutine(DoTravel());
    }
    private void Update()
    {
        if (lockZAxis)
            this.transform.localPosition = new Vector3(transform.localPosition.x, 0, transform.localPosition.z);
    }

    MaterialPropertyBlock block;

    private IEnumerator DoTravel()
    {
        block = new MaterialPropertyBlock();

        float positioningAngle = Random.Range(0, 360f);

        Vector3 startPosition = Quaternion.Euler(new Vector3(0, positioningAngle, 0)) * Vector3.forward * parentRegion.radius;
        rb.isKinematic = true;
        rb.position = startPosition + parentRegion.transform.position;
        rb.isKinematic = false;

        rb.velocity = Vector3.zero;

        renderer.GetPropertyBlock(block);
        block.SetFloat("_Opacity", 0f);
        renderer.SetPropertyBlock(block);

        float firingAngle = Mathf.Repeat(positioningAngle + 180 + Random.Range(-70, 70), 360);


        float force = Random.Range(minKickSpeed, maxKickSpeed);
        rb.AddForce ( Quaternion.Euler(new Vector3(0, firingAngle, 0)) * Vector3.forward * parentRegion.radius * force, ForceMode.Force );

        rb.angularVelocity = new Vector3(Random.Range(-maxSpinSpeed, maxSpinSpeed), Random.Range(-maxSpinSpeed, maxSpinSpeed), Random.Range(-maxSpinSpeed, maxSpinSpeed));

        StartCoroutine(ChangeOpacity(renderer,1f));

        yield return new WaitForSeconds(2f);

        while (Vector3.Distance(this.transform.position, parentRegion.transform.position) < parentRegion.radius)
            yield return null;


        StartCoroutine(ChangeOpacity(renderer, 0f));

        yield return new WaitForSeconds(5f);

        onFinishedPath?.Invoke();
        onFinishedPath = null;
        parentRegion.AsteroidFinishedRoute(this.gameObject);
        StartCoroutine(DoTravel());
    }

    private IEnumerator ChangeOpacity(MeshRenderer renderer, float targetOpacity)
    {
        float currentTime = Time.deltaTime;
        while(Time.deltaTime < currentTime + 2f)
        {
            float currentOpacity = block.GetFloat("_Opacity");
            currentOpacity = Mathf.MoveTowards(currentOpacity, targetOpacity, 0.5f * Time.deltaTime);
            renderer.GetPropertyBlock(block);
            block.SetFloat("_Opacity", currentOpacity );
            renderer.SetPropertyBlock(block);
            yield return null;
        }
        block.SetFloat("_Opacity", targetOpacity);
    }

    private void OnCollisionEnter(Collision collision)
    {
        if (Time.timeSinceLevelLoad < 1f) // preventing collision from triggering noise at spawn
            return;
        float hitMagnitude = collision.impulse.magnitude;
        GetComponent<PlayRandomSound>().PlayARandomSound(hitMagnitude);
    }
}
