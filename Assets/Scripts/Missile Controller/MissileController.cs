using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MissileController : MonoBehaviour
{
    Rigidbody rb;
    TrailRenderer trail;
    // Start is called before the first frame update
    void Start()
    {
        rb = GetComponent<Rigidbody>();
    }

    // Update is called once per frame
    void Update()
    {
    }

    public void Fire(MissilePool pool, GameObject target, System.Action onReachedTarget)
    {
        StartCoroutine(FireInternal(pool,target, onReachedTarget));
    }

    private IEnumerator FireInternal(MissilePool pool, GameObject target, System.Action onReachedTarget)
    {
        rb = GetComponent<Rigidbody>();
        trail = GetComponent<TrailRenderer>();
        rb.isKinematic = false;
        float startTime = Time.time;
        rb.velocity = Vector3.zero;
        rb.angularVelocity = Vector3.zero;
        this.rb.rotation = Quaternion.LookRotation(Vector3.down);
        trail.Clear();
        trail.enabled = true;
        trail.time = 1;
       
        rb.AddForce(Vector3.up * 2000);

        yield return new WaitForSeconds(.25f);

        startTime = Time.time;
        while (Time.time < startTime + 0.1f)
        {
            Vector3 targetAngleVector = (target.transform.position - this.transform.position).normalized;
            this.transform.rotation = Quaternion.RotateTowards(this.transform.rotation, Quaternion.LookRotation(-targetAngleVector), 1000f * Time.deltaTime);
            //this.rb.rotation = Quaternion.LookRotation(-targetAngleVector);
            yield return null;
        }
        
       startTime = Time.time;
       float radiusClamp = 90f;
       while (Vector3.Distance(target.transform.position, this.transform.position) > 1f)
       {
           Vector3 targetAngleVector = (target.transform.position - this.transform.position).normalized;
           this.transform.rotation = Quaternion.RotateTowards(this.transform.rotation, Quaternion.LookRotation(-targetAngleVector), 1000f * Time.deltaTime);


           rb.AddForce(targetAngleVector * 7);

           float distanceToTarget = Vector3.Distance(this.transform.position, target.transform.position);
           float forceDistance = distanceToTarget < radiusClamp ? distanceToTarget : radiusClamp;

           rb.position = target.transform.position - targetAngleVector * forceDistance;

           radiusClamp = Mathf.Clamp(radiusClamp - 60 * Time.deltaTime, 0, 500);

           yield return null;
       }

        rb.isKinematic = true;
        this.transform.parent = target.transform;

        onReachedTarget?.Invoke();

        for(float index = 0f; index < 1f; index += Time.deltaTime)
        {
            trail.time = 1 - index;
            yield return null;
        }

        trail.enabled = false;
        trail.Clear();

        AsteroidController asteroid = target.GetComponent<AsteroidController>();
        if (asteroid != null)
            asteroid.onFinishedPath += () => {
                pool.CheckInMissile(this);
            };
    }
}
