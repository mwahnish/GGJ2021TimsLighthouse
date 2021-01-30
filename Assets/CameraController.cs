using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CameraController : MonoBehaviour
{
    public float CameraRange;
    public float CameraAltitude;
    public float CameraPitch;
    float camX;
    float camZ;
    float camAngle = 0;
    float camAngleDeg;


    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        // Rotate camera radial angle based on input controller
        camAngle += Input.GetAxis("Vertical") * 0.01f;
        if (camAngle > 2.0f * Mathf.PI) camAngle -= 2.0f * Mathf.PI;
        if (camAngle < -2.0f * Mathf.PI) camAngle += 2.0f * Mathf.PI;

        // Determine camera location coordiates on radial at selected range
        camX = CameraRange * Mathf.Sin(camAngle);
        camZ = CameraRange * Mathf.Cos(camAngle);
        transform.position = new Vector3(camX, CameraAltitude, camZ);

        // Rotate camera direction to be opposite of its radial angle
        camAngleDeg = camAngle / (2.0f * Mathf.PI) * 360.0f;
        transform.eulerAngles = new Vector3(CameraPitch, camAngleDeg - 180.0f, 0);
    }
}
