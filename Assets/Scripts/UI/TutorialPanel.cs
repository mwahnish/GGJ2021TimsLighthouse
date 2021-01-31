using Assets.Scripts.UI;
using TMPro;
using UnityEngine;

public class TutorialPanel : MonoBehaviour
{
    public TextMeshProUGUI title;
    public TextMeshProUGUI text;


    public void Display(TutorialData tool)
    {
        title.text = tool.Title;
        text.text = tool.Text;
    }
}
