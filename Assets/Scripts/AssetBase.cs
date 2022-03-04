using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class AssetBase : MonoBehaviour
{
    [Header("Ships")]
    public List<GameObject> Ships;
    public List<EnemyShip> Enemys;

    [Header("Upgrade")]
    public int[] ShipCost;
    public int[] ChestCost;
    public int[] CanonCost;
    public int[] CaptainCost;
    public int[] CrewmateCost;
    public int[] GunnerCost;

    private int _idxEnemys;
    public EnemyShip GetNextEnemy()
    {
        return Enemys[_idxEnemys];
    }
}
