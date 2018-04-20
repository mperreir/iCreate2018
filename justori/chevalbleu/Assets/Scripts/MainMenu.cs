using System.Collections;
using System.Text.RegularExpressions;
using UnityEngine;
using UnityEngine.SceneManagement;
using UnityEngine.UI;
using UnityEngine.XR;

public class MainMenu : MonoBehaviour {
    //L'IP final en static pour le récupérer via l'autre scène
    public static string ipText="";
    //L'input
    public InputField ipField;
    //Le bouton Valider
    public Button playGameBt;
    //Le Canvas Noir qui masque la vue pour le PC
    public Canvas loader;

	// Use this for initializations
	void Start () {
        //Si l'appareil est sous Android
        if (Application.platform == RuntimePlatform.Android){
            //On désactive la VR pour le startmenu
            DisableVR();
            //On fixe l'orientation en mode portrait
            Screen.orientation = ScreenOrientation.Portrait;
            //On désactive le bouton Valider
            playGameBt.interactable = false;
            //On destroy le Loader qui nous empeche de voir la scène
            Destroy(loader);
        } //Sinon on est sur PC
        else{
            //On va directement à la scène du jeu
            SceneManager.LoadScene("proj");
        }

    }
	
	// Update is called once per frame
	void Update () {
		
	}

    /**
     * Fonction appelée au changement du texte du TextField
     **/
    public void Text_Changed(){
        //Active le bouton valider si le TextField est sous la forme IPV4 (X.X.X.X, ou X est un nombre)
        //Désactive sinon
        playGameBt.interactable = Regex.IsMatch(ipField.text, @"\b\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\b");
    }

    /**
     * Démarre le jeu, passe à la scène suivante.
     **/
    public void StartGame(){
        ipText = ipField.text;
        print("Adress: "+ ipText);
        SceneManager.LoadScene("proj");
    }


    //Active/Désactive la VR pour Android
    IEnumerator LoadDevice(string newDevice, bool enable){
        XRSettings.LoadDeviceByName(newDevice);
        yield return null;
        XRSettings.enabled = enable;
    }
    void EnableVR(){StartCoroutine(LoadDevice("cardboard", true));}
    void DisableVR(){StartCoroutine(LoadDevice("", false));}
}
