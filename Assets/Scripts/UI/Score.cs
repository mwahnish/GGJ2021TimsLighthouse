using TMPro;
using UnityEngine;

public class Score : MonoBehaviour
{
    private TextMeshProUGUI text;

    private float currentScore = 0f;
    private int targetValue = 0;

    private void Awake()
    {
        text = GetComponentInChildren<TextMeshProUGUI>();
    }


    public void SetScore(int value)
    {
        targetValue = value;
    }

    private void Update()
    {
        currentScore = Mathf.MoveTowards(currentScore, targetValue, 25 * Time.deltaTime);

        if (text != null)
        {
            text.text = ((int)currentScore).ToString("X6");
        }
    }
}
