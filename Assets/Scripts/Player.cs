using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Player
{

    public int Gold = 0;
    
    public int ShipLevel = 1;
    public int ChestLevel = 1;
    public int CanonLevel;

    public int PlayerLevel = 1;
    public int CrewmateNb;
    public int GunnerNb;

    public void AddGold(int gain)
    {
        Gold += gain;
        if (Gold > ChestLevel * 100) Gold = ChestLevel * 100;

        UIManager.Instance.UpdateGold(Gold);
    }

}
