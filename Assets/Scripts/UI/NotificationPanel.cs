using TMPro;
using UnityEngine;

public class NotificationPanel : MonoBehaviour
{
    private TextMeshProUGUI text;

    private Animator messageAnimator;

    private void Awake()
    {
        text = GetComponentInChildren<TextMeshProUGUI>();
        messageAnimator = GetComponent<Animator>();
    }


    public void SetMessage(string message)
    {
        messageAnimator.SetTrigger("Show");

        if (text != null)
        {
            text.text = message;
        }
    }
}
