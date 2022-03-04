using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[CreateAssetMenu(fileName = "Ships", menuName = "Ships/EnemyShipScriptableObject", order = 1)]
public class EnemyShip : ScriptableObject
{
    public GameObject Prefab;
    public int Life;
}
