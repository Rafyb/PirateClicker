using System.Collections;
using System.Collections.Generic;
using UnityEditor.UIElements;
using UnityEngine;

public class Clouds : MonoBehaviour
{
    public float speed = 2f;

    void Update()
    {
        Vector3 pos = transform.position;

        if (pos.z > -40)
        {
            pos.z = -340;
        }
        
        pos.z += speed * Time.deltaTime;
        
        transform.position = pos;
    }
}
