using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CameraRotator : MonoBehaviour
{
    [SerializeField]
    private float maxRotateSpeed = 60f;

    [SerializeField]
    private float acceleration = 10f;

    float targetRotateVelocity;
    float currentRotateVelocity;
    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {

        if (Input.GetKey(KeyCode.A))
            targetRotateVelocity = -maxRotateSpeed;
        else if (Input.GetKey(KeyCode.D))
            targetRotateVelocity = maxRotateSpeed;
        else
            targetRotateVelocity = 0f;

        currentRotateVelocity = Mathf.MoveTowards(currentRotateVelocity, targetRotateVelocity, acceleration * Time.deltaTime);

        currentRotateVelocity = Mathf.Clamp(currentRotateVelocity, -maxRotateSpeed, maxRotateSpeed);

        this.transform.rotation = Quaternion.Euler(this.transform.rotation.eulerAngles + Vector3.up * -currentRotateVelocity * Time.deltaTime);



    }
}
