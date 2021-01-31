using TMPro;
using UnityEngine;
using UnityEngine.UI;

public class HealthMeter : MonoBehaviour
{
    private Slider slider;
    private TextMeshProUGUI text;


    private void Awake()
    {
        slider = GetComponentInChildren<Slider>();
        text = GetComponentInChildren<TextMeshProUGUI>();
    }


    public void SetHealth(int value)
    {
        if (slider != null)
        {
            slider.value = value;
        }

        if (text != null)
        {
            text.text = $"{value}%";
        }
    }
}
