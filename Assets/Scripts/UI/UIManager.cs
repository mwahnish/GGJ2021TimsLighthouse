﻿using Assets.Scripts.UI;
using UnityEngine;

public class UIManager : MonoBehaviour
{
    public Score score;
    public HealthMeter lighthouseHealthMeter;
    public HealthMeter shipHealthMeter;

    public NotificationPanel notifications;
    public ToolInformationPanel toolInformation;

    private Messages messages;
    private Tools tools;
    private ToolKey currentTool;


    private void Start()
    {
        messages = DataLoader.LoadMessageData();
        tools = DataLoader.LoadToolData();

        currentTool = ToolKey.Radar;

        Reset();
        DisplayMessage(MessageKey.StartLevel);
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
    public void DisplayToolInformation()
    {
        if (tools.TryGetValue(currentTool, out ToolData tool))
        {
            toolInformation.Display(tool);
        }
        else
        {
            Debug.Log($"No tool found for id: {currentTool}");
        }
    }

    #endregion

    #region Private Methods

    private void Reset()
    {
        SetScore(0);
        SetLighthouseHealth(100);
        SetShipHealthMeter(1, 100);
    }

    #endregion
}
