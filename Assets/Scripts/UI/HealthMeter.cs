using TMPro;
using UnityEngine;
using UnityEngine.UI;

public class HealthMeter : MonoBehaviour
{
    private Slider slider;
    private TextMeshProUGUI text;

    private float currentSliderValue = 0f;
    private int targetValue = 0;


    private void Awake()
    {
        slider = GetComponentInChildren<Slider>();
        text = GetComponentInChildren<TextMeshProUGUI>();
    }


    public void SetHealth(int value)
    {
        targetValue = value;
    }

    private void Update()
    {
        currentSliderValue = Mathf.MoveTowards(currentSliderValue, targetValue, 25 * Time.deltaTime);

        if (slider != null)
        {
            slider.value = (int)currentSliderValue;
        }

        if (text != null)
        {
            text.text = $"{(int)currentSliderValue}%";
        }
    }
}
