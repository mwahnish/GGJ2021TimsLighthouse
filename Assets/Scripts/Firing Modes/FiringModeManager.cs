using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class FiringModeManager : MonoBehaviour
{

    [SerializeField]
    private List<FiringModeBase> firingModes = new List<FiringModeBase>();

    [SerializeField]
    private AudioSource fireAudio;

    [SerializeField]
    private AudioSource cantFire;

    private static FiringModeManager _instance = null;

    int _currentEnergy = 100;

    public int currentEnergy
    {
        get { return _currentEnergy; }
        set
        {
            _currentEnergy = value;
            _currentEnergy = Mathf.Clamp(_currentEnergy, 0, 100);
            UIManager.instance.SetLighthouseHealth(_currentEnergy);
        }
    }

    public static FiringModeManager instance
    {
        get
        {
            if (_instance == null)
                _instance = FindObjectOfType<FiringModeManager>();
            return _instance;
        }
    }


    //[SerializeField]
    //private int selectedFiringMode = 0;

    public void Fire(List<GameObject> target, int firingModeIndex)
    {
        FiringModeBase firingMode = firingModes[firingModeIndex];

        if (currentEnergy - firingMode.cost >= 0)
        {
            fireAudio?.Play();
            firingMode.Fire(target);
            currentEnergy -= firingMode.cost;
        }
        else
        {
            cantFire?.Play();
        }

    }
}
