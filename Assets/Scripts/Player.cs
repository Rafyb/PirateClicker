using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.PlayerLoop;

public class Player
{

    public int Gold = 0;
    
    public int ShipLevel = 1;
    public int ChestLevel = 1;
    public int CanonLevel;

    public int PlayerLevel = 1;
    public int CrewmateNb;
    public int GunnerNb;

    private float WaitOneSecond;
    private float WaitQuartSecond;

    public void AddGold(int gain)
    {
        Gold += gain;
        if (Gold > ChestLevel * 100) Gold = ChestLevel * 100;

        UIManager.Instance.UpdateGold(Gold);
    }

    public int GetChestMax()
    {
        return ChestLevel * 100;
    }

    public int GetCanonsHits()
    {
        return CanonLevel * 10 * GunnerNb;
    }

    public void Update(Game g, float delta)
    {
        if (WaitQuartSecond >= 0.25f)
        {
            WaitQuartSecond -= 0.25f;
            if(CrewmateNb > 0) g.IADamage(CrewmateNb*PlayerLevel);
        }
        else WaitQuartSecond += delta;
        
        if (WaitOneSecond >= 1f)
        {
            WaitOneSecond -= 1f;
            int dmg = GetCanonsHits();
            if (dmg > 0)
            {
                SoundManager.Instance.PlaySound("CANON");
                g.IADamage(dmg);
            }
        }
        else WaitOneSecond += delta;
    }

}
