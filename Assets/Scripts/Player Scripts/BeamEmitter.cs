using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[RequireComponent(typeof(MeshFilter), typeof(MeshRenderer))]
public class BeamEmitter : MonoBehaviour
{
    MeshFilter meshFilter;

    Mesh mesh;

    [SerializeField]
    int resolution = 40;

    [SerializeField]
    float radius = 42f;

    [SerializeField]
    float angle = 42f;


    // Start is called before the first frame update
    void Start()
    {
        meshFilter = GetComponent<MeshFilter>();
        mesh = new Mesh();
        meshFilter.mesh = mesh;
    }


    Vector3[] vertices = new Vector3[0];
    int[] tris = new int[0];
    // Update is called once per frame
    void Update()
    {
        if (vertices.Length != resolution + 1)
        {
            vertices = new Vector3[resolution+1];
            tris = new int[(resolution - 1) * 3];
        }

        vertices[0] = Vector3.zero;

        float currentAngle = -(angle / 2f);

        for (int index = 1; index < vertices.Length; index++)
        {
            Vector3 meshSpaceRaycastDirection = Quaternion.Euler(0, currentAngle, 0) * Vector3.forward;
            Vector3 worldRaycastDirection = this.transform.rotation * meshSpaceRaycastDirection;

            float distance = radius;
            RaycastHit hit;
            if(Physics.Raycast(this.transform.position, worldRaycastDirection * 1f, out hit, distance))
            {
                distance = hit.distance;
            }

            vertices[index] =  meshSpaceRaycastDirection * distance;

            if (index > 1)
            {
                int trisIndex = (index - 2) * 3;
                tris[trisIndex] = 0;
                tris[trisIndex + 1] = index - 1;
                tris[trisIndex + 2] = index;
            }
            currentAngle += angle / resolution;
        }

        mesh.vertices = vertices;
        mesh.triangles = tris;
    }
}
