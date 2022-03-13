using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

[Serializable]
public struct Sound
{
    public string ID;
    public AudioSource Source;
}
public class SoundManager : MonoBehaviour
{
    [SerializeField] public List<Sound> Sounds;
    
    public static SoundManager Instance;

    
    private void Awake()
    {
        Instance = this;
    }

    public void PlaySound(string id)
    {
        foreach (Sound sound in Sounds)
        {
            if(sound.ID.Equals(id)) sound.Source.Play();
        }
    }


    public void OnChange(Slider s)
    {
        float value = s.value;
        foreach (Sound sound in Sounds)
        {
            sound.Source.volume = value;
        }
    }
}
