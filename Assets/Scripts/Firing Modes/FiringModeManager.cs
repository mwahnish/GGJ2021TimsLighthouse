using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class FiringModeManager : MonoBehaviour
{

    [SerializeField]
    private List<FiringModeBase> firingModes = new List<FiringModeBase>();

    private int selectedFiringMode = 0;

    public void Fire(GameObject target)
    {
        firingModes[selectedFiringMode].Fire(target);
    }
}
