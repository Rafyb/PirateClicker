using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class HitableObject : MonoBehaviour
{
    public Action HitShip;
    
    private void OnMouseDown()
    {
        HitShip?.Invoke();
    }
}
