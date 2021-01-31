using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[RequireComponent(typeof(LineRenderer))]
public class LaserBeam : MonoBehaviour
{
    LineRenderer line;
    [SerializeField]
    float maxDistance = 90;

    public AsteroidController target { get; private set; }

    // Start is called before the first frame update
    void Start()
    {
        line = GetComponent<LineRenderer>();
    }

    // Update is called once per frame
    void Update()
    {
        RaycastHit ray;

        Vector3 rayDirection = this.transform.TransformDirection(Vector3.up);
        Vector3 endPoint = this.transform.position + rayDirection * maxDistance;

        if (Physics.SphereCast(this.transform.position, 2f, rayDirection , out ray, maxDistance))
        {
            endPoint = this.transform.position + rayDirection * ray.distance;
            target = ray.collider.gameObject.GetComponent<AsteroidController>();
        }
        else
        {
            target = null;
        }

        line.SetPositions(new Vector3[] { Vector3.zero, transform.InverseTransformPoint(  endPoint )});
    }

}
