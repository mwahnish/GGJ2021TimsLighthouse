using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class FiringModeManager : MonoBehaviour
{

    [SerializeField]
    private List<FiringModeBase> firingModes = new List<FiringModeBase>();

    //[SerializeField]
    //private int selectedFiringMode = 0;

    public void Fire(GameObject target, int firingMode)
    {
        GetComponent<AudioSource>().Play();
        firingModes[firingMode].Fire(target);
    }
}
