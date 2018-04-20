using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

using Leap;

public class Utilisateur : MonoBehaviour
{
    public int univers_courant;
    // Boolean pour simplifier les if savoir s'il a une histoire déjà attrapée
    public bool audioSelected = false;
    // Son que l'utilisateur a attrapé (peut être nul s'il n'en a pas)
    public Leap.Unity.Sound son_selectionne;

    // Son de l'histoire
    public List<Leap.Unity.Sound> liste_des_histoires = new List<Leap.Unity.Sound>();

    // Son du bruitage
    public List<Leap.Unity.Sound> liste_des_bruitages = new List<Leap.Unity.Sound>();

    // Effets sonores
    public Leap.Unity.Sound effet_rewind;
    public Leap.Unity.Sound effet_forward;
    public Leap.Unity.Sound effet_page;
    // Use this for initialization
    void Start () {
        this.effet_page.son.Play();
        for (int i = 0; i < 6; i++) {
            this.liste_des_histoires[i].son.Play();
            this.liste_des_histoires[i].son.loop = true;
            this.liste_des_histoires[i].son.playOnAwake = false;
        }
        for (int i = 0; i < 4; i++)
        {
            this.liste_des_bruitages[i].son.Play();
            this.liste_des_bruitages[i].son.loop = true;
            this.liste_des_bruitages[i].son.playOnAwake = false;
        }
    }
	
	// Update is called once per frame
	void Update () {

        
    }

    public void ChangerSceneDroite()
    {
        print("On est a l'univers " + this.univers_courant);
        this.univers_courant = (this.univers_courant + 1) % 3;
        print("et on passe à l'univers " + this.univers_courant);
        SceneManager.LoadScene("univers"+this.univers_courant);
    }

    public void ChangerSceneGauche()
    {
        print("On est a l'univers " + this.univers_courant);
        this.univers_courant = (this.univers_courant - 1) % 3;
        if(this.univers_courant<0)
        {
            this.univers_courant = 2;
        }
        print("et on passe à l'univers " + this.univers_courant);
        SceneManager.LoadScene("univers"+this.univers_courant);
    }

    public void MonterLeSonSelectionne(float volume)
    {
        print("Son séléctionné passe à :" + volume);
        this.son_selectionne.son.volume = volume;
    }

    public void selectStory(int indice)
    {
        audioSelected = true;
        
        for(int i = 0; i < liste_des_histoires.Count; i++)
        {
            if(i!= indice)
            {
                liste_des_histoires[i].son.volume = 0.05f;
            }
        }

        for (int i = 0; i < liste_des_bruitages.Count; i++)
        {
            liste_des_bruitages[i].son.volume = 0.05f;
        }

        son_selectionne = liste_des_histoires[indice];
        son_selectionne.son.Play();
        son_selectionne.son.volume = 0.8f;
    }

    public void ResetAllSound()
    {
        for (int i = 0; i < liste_des_histoires.Count; i++)
        {
            
             liste_des_histoires[i].son.volume = 0.5f;
            
        }

        for (int i = 0; i < liste_des_bruitages.Count; i++)
        {
            liste_des_bruitages[i].son.volume = 0.5f;
        }
    }

    public void QuietNotSelected()
    {
        for (int i = 0; i < liste_des_histoires.Count; i++)
        {
            if(this.son_selectionne != liste_des_histoires[i])
            {
                liste_des_histoires[i].son.volume = 0.05f;
            }
            

        }
        for (int i = 0; i < liste_des_bruitages.Count; i++)
        {
            liste_des_bruitages[i].son.volume = 0.05f;
        }
    }
}
