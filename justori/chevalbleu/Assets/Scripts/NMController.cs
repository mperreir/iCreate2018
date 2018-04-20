using System.Collections;
using UnityEngine.Networking;
using UnityEngine;
using UnityEngine.XR;

public class NMController : NetworkBehaviour {
    private NetworkManager nm;

    // Use this for initialization
    void Start () {
        //On récupère le NetworkManager
        nm = GetComponent<NetworkManager>();

        //Si l'appareil est sous Android
        if (Application.platform == RuntimePlatform.Android){
            //On remet l'orientation automatique (enlevé pour le startmenu)
            Screen.orientation = ScreenOrientation.AutoRotation;
            //On réactive la VR
            EnableVR();
            //On désigne l'adresse donnée dans le startmenu comme étant l'adresse ou l'on se connecte
            nm.networkAddress = MainMenu.ipText;
            //On démarre une session comme Client
            nm.StartClient();
            
        } //Sinon on est sous PC
        else {
            //On démarre une session comme Hôte.
            nm.StartHost();
        }
    }


    // Update is called once per frame
    void Update () {
        //print("1) L'adresse est : \"" + nm.networkAddress + "\"");
    }


    //Active/Désactive la VR pour Android
    IEnumerator LoadDevice(string newDevice, bool enable)
    {
        XRSettings.LoadDeviceByName(newDevice);
        yield return null;
        XRSettings.enabled = enable;
    }
    void EnableVR() { StartCoroutine(LoadDevice("cardboard", true)); }
    void DisableVR() { StartCoroutine(LoadDevice("", false)); }

}
