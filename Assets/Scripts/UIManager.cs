using System;
using System.Collections;
using System.Collections.Generic;
using DG.Tweening;
using TMPro;
using UnityEngine;

public class UIManager : MonoBehaviour
{
    [Header("Components")]
    public GameObject ShipTab;
    public GameObject CrewTab;
    public GameObject StatsTab;

    
    [Header("Left UI")]
    public TMP_Text Gold;
    public GameObject PrefabFeedbackText;
    public Color Red;
    public Color Golden;
    
    [Header("Page1")]
    public TMP_Text LvlShip;
    public TMP_Text CostShip;
    public TMP_Text LvlChest;
    public TMP_Text CostChest;
    public TMP_Text LvlCanons;
    public TMP_Text CostCanons;
    
    [Header("Page2")]
    public TMP_Text LvlCaptain;
    public TMP_Text TxtCaptain;
    public TMP_Text CostCaptain;
    public TMP_Text LvlMoussaillon;
    public TMP_Text CostMoussaillon;
    public TMP_Text LvlGunner;
    public TMP_Text CostGunner;
    
    [Header("Page3")]
    public TMP_Text StatGold;
    public TMP_Text StatCrewmate;
    public TMP_Text StatDamagePerSecund;

    
    public static UIManager Instance;
    
    

    private void Awake()
    {
        Instance = this;
    }

    void Start()
    {
        OnClickShipTab();
    }

    public void OnClickUpgrade(int idx)
    {
        if (idx == 0) // Ship
        {
            
        }
        if (idx == 1) // Chests
        {
            
        }
        if (idx == 2) // Canons
        {
            
        }
        if (idx == 3) // Captain
        {
            
        }
        if (idx == 4) // Crewmate
        {
            
        }
        if (idx == 5) // Gunner
        {
            
        }
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

    public void Popup(string text, Color color, Vector3 pos)
    {
        GameObject go = Instantiate(PrefabFeedbackText,pos,new Quaternion(0.0125983804f,0.941236377f,0.00653678318f,-0.337450266f));
        TMP_Text tmptext = go.GetComponentInChildren<TMP_Text>();

        tmptext.text = text;
        tmptext.color = color;

        go.transform.DOMoveY(go.transform.position.y + 50, 1.5f);
        go.GetComponent<CanvasGroup>().DOFade(0, 1.5f);
        
        Destroy(go,1.2f);

    }

    public void UpdateGold(int gold)
    {
        Gold.text = gold + " Gold";
    }
}
