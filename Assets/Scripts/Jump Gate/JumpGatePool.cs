using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class JumpGatePool : MonoBehaviour
{
    [SerializeField]
    private GameObject jumpGatePrefab;

    private List<JumpGateController> checkedInJumpGates = new List<JumpGateController>();

    public JumpGateController ShowAtPosition(Vector3 target, bool playSound)
    {
        JumpGateController markerController = null;

        if (checkedInJumpGates.Count == 0)
            markerController = GameObject.Instantiate(jumpGatePrefab).GetComponent<JumpGateController>();
        else
        {
            markerController = checkedInJumpGates[0];
            checkedInJumpGates.RemoveAt(0);
        }

        //markerController.transform.position = target;

        markerController.ShowAtLocation(this,target, playSound);

        return markerController;
    }

    public void CheckInJumpGate(JumpGateController aoe)
    {
        aoe.transform.parent = this.transform;

        aoe.transform.position = Vector3.up * 1000f;
        if (!checkedInJumpGates.Contains(aoe))
            checkedInJumpGates.Add(aoe);
    }
}
