using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class UIManager : MonoBehaviour
{
    public GameObject ShipTab;
    public GameObject CrewTab;
    public GameObject StatsTab;

    public static UIManager Instance;

    private void Awake()
    {
        Instance = this;
    }

    void Start()
    {
        OnClickShipTab();
    }

    // Update is called once per frame
    void Update()
    {
        
    }

    public void OnClickShipTab()
    {
        HideTabs();
        ShipTab.SetActive(true);
    }
    public void OnClickStatsTab()
    {
        HideTabs();
        StatsTab.SetActive(true);
    }
    public void OnClickCrewTab()
    {
        HideTabs();
        CrewTab.SetActive(true);
    }

    private void HideTabs()
    {
        CrewTab.SetActive(false);
        StatsTab.SetActive(false);
        ShipTab.SetActive(false);
    }
}
