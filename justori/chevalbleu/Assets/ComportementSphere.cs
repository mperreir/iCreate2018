using System;
using System.Collections.Generic;
using UnityEngine;

public class ComportementSphere : MonoBehaviour {

    int vitesseRotation;
    int vitesseFormation;
    List<Renderer> listeTransformations;
    List<Renderer> listeExoSquelette;
    int compteurUpdate;
    Color vert1 = new Color((float)173/255, (float)255/255, (float)47/255);
    Color vert2 = new Color((float)127 / 255, (float)255 / 255, (float)0 / 255);
    Color vert3 = new Color((float)154/255, (float)205/255, (float)50/255);
    Color vert4 = new Color((float)0 / 255, (float)128 / 255, (float)0 / 255); //vert 


    Color bleu1 = new Color((float)176 / 255, (float)224 / 255, (float)230 / 255);
    Color bleu2 = new Color((float)135 / 255, (float)206 / 255, (float)235 / 255);
    Color bleu3 = new Color((float)70 / 255, (float)130 / 255, (float)180 / 255);
    Color bleu4 = new Color((float)25 / 255, (float)25 / 255, (float)112 / 255);


    // Use this for initialization
    private void Start () {
       
            vitesseFormation = 1;
            vitesseRotation = 1;
            vitesseFormation = 100;
            listeTransformations = new List<Renderer>();
            listeExoSquelette = new List<Renderer>();
            compteurUpdate = 0;
            foreach (Renderer r in GetComponentsInChildren<Renderer>())
            {
                r.enabled = false;
                r.material.color = vert1;
                listeExoSquelette.Add(r);
            }
        
    }
	
	// Update is called once per frame
	private void Update () {

            transform.Rotate(Vector3.right, Time.deltaTime * vitesseRotation);
            transform.Rotate(Vector3.up, Time.deltaTime * vitesseRotation, Space.World);
            Apparition();
            ChangementVitesseFormation();
            if (compteurUpdate == 199)
            {
                StockageCouleur(listeExoSquelette[0].material.color);
            }
            Debug.Log(listeExoSquelette[0].material.color);
        
    }

    public void ChangementVitesseFormation()
    {
        float micro = MicrophoneListen.avg*10000;
        if(micro >= 20 && micro <= 70)
        {
            this.vitesseFormation = 400;
        }
        else if(micro > 70)
        {
            this.vitesseFormation = 200;
        }
        else
        {
            this.vitesseFormation = 600;
        }
    }

    public void ChangementCouleur(Color newColor)
    {
            foreach (Renderer r in listeExoSquelette)
            {
                float trash = r.material.color.a;
                newColor.a = trash;
                r.material.color = newColor;
            }
    }

    public void Apparition()
    {
        if (compteurUpdate > vitesseFormation)
        {
            SlowUpdateLaunch(ChoixAleatoire());
            foreach (Renderer r in listeTransformations)
            {
                if (r.material.color.a < 1.0f)
                {
                    Color nouvelleCouleur = r.material.color;
                    nouvelleCouleur.a += 0.1f;
                    r.material.color = nouvelleCouleur;
                }
            }
            compteurUpdate = 0;
        }
        compteurUpdate++;
    }

    private Renderer ChoixAleatoire()
    {
        int mongoleUnity = new System.Random().Next(0, 200);
        int cpt = 0;
        foreach (Renderer r in listeExoSquelette)
        {
            cpt++;
            if (mongoleUnity == cpt)
            {
                return r;
            }
        }
        return null;
    }

    private void SlowUpdateLaunch(Renderer r)
    {
        r.enabled = true;
        Color nouvelleCouleur = r.material.color;
        nouvelleCouleur.a = 0.0f;
        r.material.color = nouvelleCouleur;
        listeTransformations.Add(r);
    }

    private void ResetRender(Renderer r)
    {
        Color nouvelleCouleur = r.material.color;
        nouvelleCouleur.a = 0.0f;
        r.enabled = false;
        listeTransformations.Remove(r);
    }

    private void StockageCouleur(Color gestion)
    {
        float peak = MicrophoneListen.peak;
        Color anneau = gestion;
        if(gestion.r.Equals(vert1.r))
        {
            if(peak > 960)
            {
                Color vert2 = new Color((float)127 / 255, (float)255 / 255, (float)0 / 255, gestion.a);
                anneau = vert2;
            }
            else if(peak < 560)
            {
                Color bleu1 = new Color((float)176 / 255, (float)224 / 255, (float)230 / 255, gestion.a);
                anneau = bleu1;
            }
        }
        else if(gestion.r.Equals(vert2.r))
        {
             if(peak > 1152)
            {
                Color vert3 = new Color((float)154 / 255, (float)205 / 255, (float)50 / 255, gestion.a);
                anneau = vert3;
            }
            else if(peak < 960)
            {
                Color vert1 = new Color((float)173 / 255, (float)255 / 255, (float)47 / 255, gestion.a);
                anneau = vert1;
            }
        }
        else if(gestion.r.Equals(vert3.r))
        {
            if (peak > 1344)
            {
                Color vert4 = new Color((float)154 / 255, (float)205 / 255, (float)50 / 255, gestion.a);
                anneau = vert4;
            }
            else if(peak < 1152)
            {
                Color vert2 = new Color((float)127 / 255, (float)255 / 255, (float)0 / 255, gestion.a);
                anneau = vert2;
            }
        }
        else if (gestion.r.Equals(vert4.r))
        {
            if (peak < 1344)
            {
                Color vert3 = new Color((float)154 / 255, (float)205 / 255, (float)50 / 255, gestion.a);
                anneau = vert3;
            }
        }
        else if (gestion.r.Equals(bleu1.r))
        {
            if (peak > 576)
            {
                Color vert1 = new Color((float)173 / 255, (float)255 / 255, (float)47 / 255, gestion.a);
                anneau = vert1;
            }
            else if(peak < 384)
            {
                Color bleu2 = new Color((float)135 / 255, (float)206 / 255, (float)235 / 255, gestion.a);
                anneau = bleu2;
            }
        }
        else if (gestion.r.Equals(bleu2.r))
        {
            if (peak > 384)
            {
                Color bleu1 = new Color((float)176 / 255, (float)224 / 255, (float)230 / 255, gestion.a);
                anneau = bleu1;
            }
            else if(peak < 192)
            {
                Color bleu3 = new Color((float)70 / 255, (float)130 / 255, (float)180 / 255, gestion.a);
                anneau = bleu3;
            }
        }
        else if (gestion.r.Equals(bleu3.r))
        {
            if (peak > 192)
            {
                Color bleu2 = new Color((float)135 / 255, (float)206 / 255, (float)235 / 255, gestion.a);
                anneau = bleu2;
            }
            else if(peak < 70)
            {
                Color bleu4 = new Color((float)25 / 255, (float)25 / 255, (float)112 / 255, gestion.a);
                anneau = bleu4;
            }
        }
        else if (gestion.r.Equals(bleu4.r))
        {
            if (peak > 70)
            {
                Color bleu3 = new Color((float)70 / 255, (float)130 / 255, (float)180 / 255, gestion.a);
                anneau = bleu3;
            }
        } else
        {
            Debug.Log("Fail");
        }
        ChangementCouleur(anneau);
    }
}
