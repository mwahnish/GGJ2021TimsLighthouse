using TMPro;
using UnityEngine;

public class NotificationPanel : MonoBehaviour
{
    private TextMeshProUGUI text;


    private void Awake()
    {
        text = GetComponentInChildren<TextMeshProUGUI>();
    }


    public void SetMessage(string message)
    {
        if (text != null)
        {
            text.text = message;
        }
    }
}
