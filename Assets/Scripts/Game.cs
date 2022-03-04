using System.Collections;
using System.Collections.Generic;
using DG.Tweening;
using UnityEngine;

public class Game : MonoBehaviour
{
    public AssetBase Database;
    
    public Transform EnemyPos;
    public Transform SpawnPos;
    public Transform PlayerPos;

    public GameObject LifeBar;

    private GameObject _enemyShip;
    private GameObject _playerShip;

    private Player _player;
    private int _enemyLife;
    private bool _battling;

    // Start is called before the first frame update
    void Start()
    {
        _player = new Player();
        _playerShip = Instantiate(Database.Ships[0], PlayerPos.position, Database.Ships[0].transform.rotation);

        StartCoroutine(WaitBeforeNewShip());
    }

    private void NextEnemy()
    {
        EnemyShip enemy = Database.GetNextEnemy();
        _enemyLife = enemy.Life;
        _enemyShip = Instantiate(enemy.Prefab, SpawnPos.position, Quaternion.identity);
        _enemyShip.transform.DOMove(EnemyPos.position, 2).OnComplete(() =>
        {
            LifeBar.GetComponent<LifeBar>().ResetBar(_enemyLife);
            LifeBar.GetComponent<CanvasGroup>().DOFade(1, 0.3f).OnComplete(() =>
            {
                _battling = true;
            });
        });
        _enemyShip.AddComponent<HitableObject>().HitShip += HitShip;
    }

    private void KillEnemy()
    {
        _battling = false;
        StartCoroutine(WaitBeforeNewShip());
        LifeBar.GetComponent<CanvasGroup>().DOFade(0, 0.3f).OnComplete(() => { });
        _enemyShip.transform.DOKill();
        _enemyShip.transform.DOMoveY(_enemyShip.transform.position.y-30, 2).OnComplete(() =>
        {
            Destroy(_enemyShip);
        });;
        _enemyShip.transform.DORotate(new Vector3(30,0,20),0.2f);
    }

    private void HitShip()
    {
        if (_battling)
        {
            _enemyShip.transform.DOKill();
            _enemyShip.transform.DORotate(new Vector3(0, 0, 30), 0.05f).OnComplete(() =>
            {
                _enemyShip.transform.DORotate(new Vector3(0, 0, -30), 0.1f).OnComplete(() =>
                {
                    _enemyShip.transform.DORotate(new Vector3(0, 0, 0), 0.05f);
                });
            });
            
            _enemyLife -= _player.PlayerLevel;
            LifeBar.GetComponent<LifeBar>().UpdateLife(_enemyLife);
            
            if(_enemyLife <= 0) KillEnemy();
        }
    }

    IEnumerator WaitBeforeNewShip()
    {
        yield return new WaitForSeconds(2);
        NextEnemy();
    }

    // Update is called once per frame
    void Update()
    {
        
    }
}
