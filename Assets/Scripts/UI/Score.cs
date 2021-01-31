using TMPro;
using UnityEngine;

public class Score : MonoBehaviour
{
    private TextMeshProUGUI text;


    private void Awake()
    {
        text = GetComponentInChildren<TextMeshProUGUI>();
    }


    public void SetScore(int value)
    {
        if (text != null)
        {
            text.text = value.ToString("X6");
        }
    }
}
