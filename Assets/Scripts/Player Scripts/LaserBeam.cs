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


    private List<AsteroidController> _targets = new List<AsteroidController>();
    public List<AsteroidController> targets { get { return _targets; } }

    // Start is called before the first frame update
    void Start()
    {
        line = GetComponent<LineRenderer>();
    }

    // Update is called once per frame
    void Update()
    {

        Vector3 rayDirection = this.transform.TransformDirection(Vector3.up);
        Vector3 endPoint = this.transform.position + rayDirection * maxDistance;

        RaycastHit singleHitRay;
        if (Physics.SphereCast(this.transform.position, 2f, rayDirection , out singleHitRay, maxDistance))
        {
            endPoint = this.transform.position + rayDirection * singleHitRay.distance;
            target = singleHitRay.collider.gameObject.GetComponent<AsteroidController>();
        }
        else
        {
            target = null;
        }

        line.SetPositions(new Vector3[] { Vector3.zero, transform.InverseTransformPoint(endPoint) });

        RaycastHit[] allHits = Physics.SphereCastAll(this.transform.position, 2f, rayDirection,  maxDistance);
        targets.Clear();
        foreach(RaycastHit hit in allHits)
        {
            AsteroidController controller = hit.collider.gameObject.GetComponent<AsteroidController>();
            if (controller != null)
                targets.Add(controller);
        }

    }

}
