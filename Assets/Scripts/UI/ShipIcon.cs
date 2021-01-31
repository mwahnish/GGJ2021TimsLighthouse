using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ShipIcon : MonoBehaviour
{
    Animator animator;

    // Start is called before the first frame update
    void Start()
    {
        animator = GetComponent<Animator>();
    }

    public void SlideIn()
    {
        animator.SetTrigger("SlideIn");
    }

    public void SlideOut()
    {
        animator.SetTrigger("SlideOut");
    }
}
