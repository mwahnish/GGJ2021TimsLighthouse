using Assets.Scripts.UI;
using TMPro;
using UnityEngine;
using UnityEngine.UI;

public class ToolInformationPanel : MonoBehaviour
{
    public Image image;
    public TextMeshProUGUI title;
    public TextMeshProUGUI text;


    public void Display(ToolData tool)
    {
        Time.timeScale = 0f;
        title.text = $"{tool.Title} Tool";
        text.text = tool.Text;
        gameObject.SetActive(true);
    }


    public void Hide()
    {
        Time.timeScale = 1f;
        gameObject.SetActive(false);
    }
}
