using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GameManager : MonoBehaviour
{
    [SerializeField]
    AsteroidRegion asteroids;

    public bool tool2Enabled { get; private set; }
    public bool tool3Enabled { get; private set; }

    private int shipReturnCount = 0;

    private static GameManager _instance = null;

    [SerializeField]
    private int enableTool2AfterXReturns=10;


    [SerializeField]
    private int enableTool3AfterXReturns = 20;

    [SerializeField]
    private int maxLives;
    private int lives;

    public static GameManager instance
    {
        get
        {
            if (_instance == null)
                _instance = FindObjectOfType<GameManager>();
            return _instance;
        }
    }

    // Start is called before the first frame update
    void Start()
    {
        Time.timeScale = 1f;
        UIManager.instance.SetLives(maxLives);
        lives = maxLives;
    }

    // Update is called once per frame
    void Update()
    {
        
    }

    public void OnShipReturned()
    {
        asteroids.numberOfAsteroids += 1;
        shipReturnCount++;

        if (shipReturnCount > enableTool2AfterXReturns && shipReturnCount <= enableTool3AfterXReturns)
        {
            UIManager.instance.ShowTool2();
            tool2Enabled = true;
        }
        else if (shipReturnCount > enableTool3AfterXReturns)
        {
            UIManager.instance.ShowTool3();
            tool3Enabled = true;
        }
    }

    public void OnShipKilled()
    {
        lives--;
        UIManager.instance.SetLives(lives);
        if (lives == 0)
        {
            Time.timeScale = 0f;
            UIManager.instance.ShowGameOver();
        }

    }
}
