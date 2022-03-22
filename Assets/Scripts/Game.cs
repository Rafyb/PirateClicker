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

    [HideInInspector] public int Wave;
    

    // Start is called before the first frame update
    void Start()
    {

        _player = new Player();
        _playerShip = Instantiate(Database.Ships[0], PlayerPos.position, Database.Ships[0].transform.rotation);
        
        UIManager.Instance.SetInstances(_player,this);
        
       
    }

    public void NextEnemy()
    {
        EnemyShip enemy = Database.GetNextEnemy(++Wave);
        _enemyLife = enemy.Life;
        _enemyShip = Instantiate(enemy.Prefab, SpawnPos.position, Quaternion.identity);
        _enemyShip.transform.DOMove(EnemyPos.position, 2).OnComplete(() =>
        {
            LifeBar.GetComponent<LifeBar>().ResetBar(_enemyLife);
            LifeBar.GetComponent<CanvasGroup>().DOKill();
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

        HideShadow();
        _enemyShip.transform.DOMoveY(_enemyShip.transform.position.y-30, 2).OnComplete(() =>
        {
            Destroy(_enemyShip);
        });;
        _enemyShip.transform.DORotate(new Vector3(30,0,20),0.2f);
        
        _player.AddGold(25+25*(_player.PlayerLevel));
        UIManager.Instance.Popup("+"+(25+25*(_player.PlayerLevel))+"Golds",UIManager.Instance.Golden,EnemyPos.position+new Vector3(-5,0,10));
    }

    private void HitShip()
    {
        if (_battling)
        {
            _enemyShip.transform.DOKill();
            _enemyShip.transform.DORotate(new Vector3(0, 0, 10), 0.02f).OnComplete(() =>
            {
                _enemyShip.transform.DORotate(new Vector3(0, 0, -10), 0.1f).OnComplete(() =>
                {
                    _enemyShip.transform.DORotate(new Vector3(0, 0, 0), 0.02f);
                });
            });
            
            _enemyLife -= _player.PlayerLevel;
            UIManager.Instance.Popup("-"+_player.PlayerLevel,UIManager.Instance.Red,EnemyPos.position+new Vector3(-5,8,10));
            LifeBar.GetComponent<LifeBar>().UpdateLife(_enemyLife);
            if(_enemyLife <= 0) KillEnemy();
        }
    }

    public void IADamage(int dmg,Color c)
    {
        if (!_battling) return;
        
        _enemyLife -= dmg;
        
        UIManager.Instance.Popup("-"+dmg,c,EnemyPos.position+new Vector3(-5,8,10));
        LifeBar.GetComponent<LifeBar>().UpdateLife(_enemyLife);
        
        if(_enemyLife <= 0) KillEnemy();
    }



    IEnumerator WaitBeforeNewShip()
    {
        yield return new WaitForSeconds(2);
        NextEnemy();
    }

    // Update is called once per frame
    void Update()
    {
        if (Input.GetKeyDown(KeyCode.A)) KillEnemy();

        _player.Update(this, Time.deltaTime);
    }

    void HideShadow()
    {
        Transform [] list = _enemyShip.GetComponentsInChildren<Transform>();
        foreach(Transform m in list)
        {
            GameObject g = m.gameObject;
            if (g.CompareTag("shadow"))
            {
                g.SetActive(false);
            }
        }
    }

    public void UpgradeShip()
    {
        Destroy(_playerShip);
        _playerShip = Instantiate(Database.Ships[_player.ShipLevel-1], PlayerPos.position, Database.Ships[_player.ShipLevel-1].transform.rotation);
    }
}
