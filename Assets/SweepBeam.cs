﻿using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SweepBeam : MonoBehaviour
{

    [SerializeField]
    private LaserBeam laser;

    [SerializeField]
    private FiringModeManager firingMode;

    void Start()
    {
        //lastMousePosition = Input.mousePosition;
    }

    // Update is called once per frame
    void Update()
    {
       

        Ray ray =  Camera.main.ScreenPointToRay(Input.mousePosition);
        Plane groundPlane = new Plane(Vector2.up, this.transform.position);

        float intersectDistance = 1000f;
        if(groundPlane.Raycast(ray, out intersectDistance))
        {
            Vector3 IntersectionPoint = ray.GetPoint(intersectDistance);


            float angle = Vector3.SignedAngle(transform.position - IntersectionPoint, Vector3.forward, Vector3.up);
            //Debug.Log(angle);
            this.transform.rotation = Quaternion.Euler(-90, -angle -90, 0f);
        }

        if (Input.GetMouseButtonDown(0))
        {
            if (laser.target != null)
                firingMode.Fire(laser.target.gameObject);
        }

    }

}
