using System.Collections;
using System.Collections.Generic;
using TMPro;
using UnityEngine;

public class Lives : MonoBehaviour
{
    private TextMeshProUGUI text;

    private float currentScore = 0f;
    private int targetValue = 0;

    private void Awake()
    {
        text = GetComponentInChildren<TextMeshProUGUI>();
    }


    public void SetLives(int value)
    {
        text.text = "Lives: " + value.ToString() ;
    }

}
