using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MarkerPool : MonoBehaviour
{
    [SerializeField]
    private GameObject markerPrefab;

    private List<Marker> CheckedInMarkers = new List<Marker>();

    public Marker AssignToAsteroid(AsteroidController target)
    {
        Marker markerController = null;

        if (CheckedInMarkers.Count == 0)
            markerController = GameObject.Instantiate(markerPrefab).GetComponent<Marker>();
        else
        {
            markerController = CheckedInMarkers[0];
            CheckedInMarkers.RemoveAt(0);
        }

        markerController.transform.position = this.transform.position;

        markerController.AssignToAsteroid(this, target);

        return markerController;
    }

    public void CheckInMarker(Marker marker)
    {
        marker.transform.parent = this.transform;

        marker.transform.position = Vector3.up * 1000f;
        if (!CheckedInMarkers.Contains(marker))
            CheckedInMarkers.Add(marker);
    }
}
