using Assets.Scripts.UI;
using UnityEngine;
using UnityEngine.SceneManagement;

public class UIManager : MonoBehaviour
{
    public Score score;
    public HealthMeter lighthouseHealthMeter;
    public HealthMeter shipHealthMeter;

    public NotificationPanel notifications;
    public ToolInformationPanel toolInformation;
    public ShipIcon shipIcon;

    private Messages messages;
    private Tools tools;
    private ToolKey currentTool;

    [SerializeField]
    private GameObject tool2Icon;

    [SerializeField]
    private GameObject tool3Icon;

    [SerializeField]
    private Lives lives;

    [SerializeField]
    private GameObject GameOverScreen;

    private static UIManager _instance = null;

    public static UIManager instance
    {
        get
        {
            if (_instance == null)
                _instance = FindObjectOfType<UIManager>();
            return _instance;
        }
    }


    private void Start()
    {
        messages = DataLoader.LoadMessageData();
        tools = DataLoader.LoadToolData();

        currentTool = ToolKey.Radar;

        Reset();
        DisplayMessage(MessageKey.StartLevel);
    }

    private void Update()
    {
        if (Input.GetKeyDown(KeyCode.Escape))
            MainMenu();
    }

    #region Public Interface

    /// <summary>
    /// Update the score
    /// </summary>
    /// <param name="value">Score value</param>
    public void SetScore(int value)
    {
        score.SetScore(value);
    }


    /// <summary>
    /// Update the lighthouse's health meter
    /// </summary>
    /// <param name="value">Health meter value</param>
    public void SetLighthouseHealth(int value)
    {
        lighthouseHealthMeter.SetHealth(value);
    }


    /// <summary>
    /// Updated the ship's health meter
    /// </summary>
    /// <param name="shipId">Which Ship</param>
    /// <param name="value">Health meter value</param>
    public void SetShipHealthMeter(int shipId, int value)
    {
        shipHealthMeter.SetHealth(value);
    }


    /// <summary>
    /// Display a message in the notification panel
    /// </summary>
    /// <param name="key">Message Key</param>
    public void DisplayMessage(MessageKey key)
    {
        if (messages.TryGetValue(key, out string message))
        {
            notifications.SetMessage(message);
        }
        else
        {
            Debug.Log($"No message found for id: {key}");
        }
    }


    /// <summary>
    /// Displays the Tool Information Dialog for the specified tool
    /// </summary>
    /// <param name="key">Tool key</param>
    public void DisplayToolInformation(int toolSelection)
    {
        if (tools.TryGetValue((ToolKey)toolSelection, out ToolData tool))
        {
            toolInformation.Display(tool);
        }
        else
        {
            Debug.Log($"No tool found for id: {toolSelection}");
        }
    }

    public void ShowShipIcon(bool show)
    {
        if (show)
            shipIcon.SlideIn();
        else
            shipIcon.SlideOut();
    }

    #endregion

    
    public void ShowTool2()
    {
        tool2Icon.SetActive(true);
    }

    public void ShowTool3()
    {
        tool3Icon.SetActive(true);
    }

    public void SetLives(int numLives)
    {
        lives.SetLives(numLives);
    }

    public void ShowGameOver()
    {
        GameOverScreen.SetActive(true);
    }
    public void MainMenu()
    {
        SceneManager.LoadScene(0);
    }


    #region Private Methods

    private void Reset()
    {
        SetScore(0);
        SetLighthouseHealth(100);
        SetShipHealthMeter(1, 100);
        tool2Icon.SetActive(false);
        tool3Icon.SetActive(false);
        GameOverScreen.SetActive(false);
    }

    #endregion
}
