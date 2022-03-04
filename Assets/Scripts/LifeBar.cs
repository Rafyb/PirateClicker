using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class LifeBar : MonoBehaviour
{
    public Image Bar;
    private float _lifeMax;

    public void UpdateLife(int life)
    {
        Bar.fillAmount = life / _lifeMax;
    }

    public void ResetBar(int lifeMax)
    {
        _lifeMax = lifeMax;
        Bar.fillAmount = 1;
    }
}
