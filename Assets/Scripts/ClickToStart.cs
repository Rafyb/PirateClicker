using System.Collections;
using System.Collections.Generic;
using DG.Tweening;
using UnityEngine;

public class ClickToStart : MonoBehaviour
{
    public CanvasGroup texte;
    private int _faded = 0;
    private bool _clicked = false;
    public Transform CameraDoTransition;
    
    void Start()
    {
        DoFade();
    }

    public void DoFade()
    {
        _faded = (_faded + 1) % 2;
        texte.DOFade(_faded, 1f).OnComplete(() =>
        {
            DoFade();
        });
    }

    public void OnClick()
    {
        if (_clicked) return;

        _clicked = true;
        gameObject.GetComponent<CanvasGroup>().DOFade(0, 0.3f).OnComplete(() =>
        {
            Camera.main.transform.DOMove(CameraDoTransition.position,1.5f);
            Camera.main.transform.DORotate(CameraDoTransition.rotation.eulerAngles, 1.5f).OnComplete(() =>
            {
                UIManager.Instance.gameObject.GetComponent<CanvasGroup>().DOFade(1, 0.5f);
                UIManager.Instance.StartingGame();
                Destroy(gameObject,0.6f);
            });
        });
    }

}
