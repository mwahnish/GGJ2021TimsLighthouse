using UnityEngine;
using UnityEngine.SceneManagement;

public class MenuController : MonoBehaviour
{
    public void QuitGame()
    {
        Application.Quit();
    }


    public void StartGame()
    {
        SceneManager.LoadScene(1);
    }


    public void Tutorial()
    {
        SceneManager.LoadScene("Tutorial");
    }
}
