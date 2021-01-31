using Assets.Scripts.UI;
using UnityEngine;
using UnityEngine.SceneManagement;

public class TutorialManager : MonoBehaviour
{
    private TutorialPanel tutorialPanel;
    private Tutorials tutorials;
    private TutorialKey currentTutorialKey;

    private TutorialData currentTutorial
    {
        get
        {
            if (tutorials.TryGetValue(currentTutorialKey, out TutorialData data))
            {
                return data;
            }
            else
            {
                Debug.Log($"No Tutorial found for id: {currentTutorialKey}");
                return null;
            }
        }
    }

    private static TutorialManager _instance = null;


    public static TutorialManager instance
    {
        get
        {
            if (_instance == null)
            {
                _instance = FindObjectOfType<TutorialManager>();
            }

            return _instance;
        }
    }

    
    private void Awake()
    {
        tutorialPanel = GetComponentInChildren<TutorialPanel>();
    }


    private void Start()
    {
        tutorials = DataLoader.LoadTutorialData();
        currentTutorialKey = TutorialKey.Introduction;
        DisplayTutorialPage();
    }


    #region Public Interface

    /// <summary>
    /// Displays the Tutorial Information Dialog for the specified tutorial
    /// </summary>
    /// <param name="key">Tutorial key</param>
    public void DisplayTutorialPage()
    {
        if (currentTutorial == null)
            return;

        tutorialPanel.Display(currentTutorial);
    }


    public void NextPage()
    {
        if (currentTutorial == null)
            return;

        if (currentTutorial.NextPage == TutorialKey.Menu)
        {
            LoadMenu();
        }
        else
        {
            currentTutorialKey = currentTutorial.NextPage;
            DisplayTutorialPage();
        }
    }


    public void PreviousPage()
    {
        if (currentTutorial == null)
            return;

        if (currentTutorial.PreviousPage == TutorialKey.Menu)
        {
            LoadMenu();
        }
        else
        {
            currentTutorialKey = currentTutorial.PreviousPage;
            DisplayTutorialPage();
        }
    }


    public void Exit()
    {
        LoadMenu();
    }

    #endregion

    #region Private Methods

    private void LoadMenu()
    {
        SceneManager.LoadScene("Menu");
    }

    #endregion
}
