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
    public TMP_Text Stats;


    
    public static UIManager Instance;
    private Game _game;
    private Player _player;

    public void SetInstances(Player p, Game g)
    {
        _player = p;
        _game = g;
    }

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
            int lvl = _player.ShipLevel;
            if (lvl >= _game.Database.Ships.Count) return;

            int cost = _game.Database.ShipCost[lvl];
            if (cost > _player.Gold) return;

            _player.ShipLevel++;
            _player.AddGold(-cost);
            _game.UpgradeShip();

            lvl = _player.ShipLevel;
            
            LvlShip.text = "Lvl " + lvl;
            if (lvl >= _game.Database.Ships.Count) CostShip.text = "MAX";
            else CostShip.text = "Upgrade ("+_game.Database.ShipCost[lvl]+"G)";
        }
        if (idx == 1) // Chests
        {
            int cost = _player.GetChestMax();
            if (cost > _player.Gold) return;
             
            _player.ChestLevel++;
            _player.AddGold(-cost);
            
            LvlChest.text = "Lvl " + _player.ChestLevel;
            CostChest.text = "Upgrade ("+_player.GetChestMax()+"G)";
            
        }
        if (idx == 2) // Canons
        {
            int cost = 50 + (_player.CanonLevel*50);
            if (cost > _player.Gold) return;
            
            _player.CanonLevel++;
            _player.AddGold(-cost);
            
            LvlCanons.text = "Lvl " + _player.CanonLevel;
            CostCanons.text = "Upgrade ("+(50 + (_player.CanonLevel*50))+"G)";
        }
        if (idx == 3) // Captain
        {
            int cost = (_player.PlayerLevel*50);
            if (cost > _player.Gold) return;
            
            _player.PlayerLevel++;
            _player.AddGold(-cost);
            
            LvlCaptain.text = "Lvl " + _player.PlayerLevel;
            CostCaptain.text = "Upgrade ("+(_player.PlayerLevel*50)+"G)";
            TxtCaptain.text = "Earn " + (25 + _player.PlayerLevel * 25) + "G per ship\nYour click make " +
                              _player.PlayerLevel + "DMG";
        }
        if (idx == 4) // Crewmate
        {
            int cost = 100 + (_player.CrewmateNb*100);
            if (cost > _player.Gold) return;

            if (_player.GunnerNb + _player.CrewmateNb >= 2 * _player.ShipLevel) return;
            
            _player.CrewmateNb++;
            _player.AddGold(-cost);
            
            LvlMoussaillon.text = "Nb " + _player.CrewmateNb;
            CostMoussaillon.text = "Upgrade ("+(100 + (_player.CrewmateNb*100))+"G)";
        }
        if (idx == 5) // Gunner
        {
            int cost = 150 + (_player.GunnerNb*150);
            if (cost > _player.Gold) return;
            
            if (_player.GunnerNb + _player.CrewmateNb >= 2 * _player.ShipLevel) return;
            
            _player.GunnerNb++;
            _player.AddGold(-cost);
            
            LvlGunner.text = "Nb " + _player.GunnerNb;
            CostGunner.text = "Upgrade ("+(150 + (_player.GunnerNb*150))+"G)";
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

        RefreshStats();

    }

    public void RefreshStats()
    {
        Stats.text = "Crewmate Number : "+(1+_player.GunnerNb+_player.CrewmateNb)+"/" + (1+2*_player.ShipLevel) +
                     "\nGold : "+_player.Gold+"/"+_player.GetChestMax() +
                     "\nCanon DMG : "+_player.GetCanonsHits()+" dmg/s" +
                     "\nCrewmate DMG : "+(_player.CrewmateNb*_player.PlayerLevel*4)+" dmg/s";
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
        
        Destroy(go,2f);

    }

    public void UpdateGold(int gold)
    {
        Gold.text = gold + " Gold";
        RefreshStats();
    }
}
