using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class AssetBase : MonoBehaviour
{
    [Header("Ships")]
    public List<GameObject> Ships;
    //public List<EnemyShip> Enemys;
    public int EnemyLife;

    [Header("Upgrade")]
    public int[] ShipCost;
    public int[] ChestCost;
    public int[] CanonCost;
    public int[] CaptainCost;
    public int[] CrewmateCost;
    public int[] GunnerCost;

    private int _idxEnemys;
    public EnemyShip GetNextEnemy(int wave)
    {
        int idx = wave / 5;
        if (idx >= Ships.Count) idx = Ships.Count-1;

        EnemyShip ship = new EnemyShip();
        ship.Life = wave * EnemyLife;
        ship.Prefab = Ships[idx];

        return ship;
    }
    
}
