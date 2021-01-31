using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class AOEPool : MonoBehaviour
{
    [SerializeField]
    private GameObject aoePrefab;

    private List<AOEController> CheckedInAOE = new List<AOEController>();

    public AOEController ShowAtPosition(Vector3 target)
    {
        AOEController markerController = null;

        if (CheckedInAOE.Count == 0)
            markerController = GameObject.Instantiate(aoePrefab).GetComponent<AOEController>();
        else
        {
            markerController = CheckedInAOE[0];
            CheckedInAOE.RemoveAt(0);
        }

        //markerController.transform.position = target;

        markerController.ShowAtPosition(this, target);

        return markerController;
    }

    public void CheckInAOE(AOEController aoe)
    {
        aoe.transform.parent = this.transform;

        aoe.transform.position = Vector3.up * 1000f;
        if (!CheckedInAOE.Contains(aoe))
            CheckedInAOE.Add(aoe);
    }
}
