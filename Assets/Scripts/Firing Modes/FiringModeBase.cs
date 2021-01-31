using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public abstract class FiringModeBase : MonoBehaviour
{
    public abstract int cost { get; }

    public virtual void Fire(List<GameObject> target)
    {

    }
}
