using UnityEngine;
using UnityEngine.UI;
using System.Collections;

public class WebCamView : MonoBehaviour
{
    //la raw image sur laquel je vais rendre ma texture de webcam
    [SerializeField]
    private RawImage planeToRenderTexture;

    //la webcam que je choisi
    private WebCamDevice device;

    //la texture de ma webcam activée
    private WebCamTexture mCameraTexture = null;

    public void Start()
    {
#if UNITY_EDITOR
        //pour récupérer la texture de ma webcam, Unity à une fonction toute faite.
        // Les deux gros chiffres c'est la witdth et la height que je souhaite
        //Pourquoi si gros? Ca se met tout seul au max à priori
        mCameraTexture = new WebCamTexture(10000, 10000);
#else
			//je cherche la caméra de derrière. Vous n'y êtes pas obligés!
			//la caméra 0 est la caméra arrière de votre device
			device = WebCamTexture.devices[0];
			
			int width = (int)Screen.width/2;
			int height = (int)Screen.height/2;

			//si je ne suis pas sur l'éditeur de Unity, je prends ma caméra de derrière que j'ai trouvé
			//j'ai pris une résolution moindre pour éviter la latence.
			mCameraTexture = new WebCamTexture (device.name,width,height);
#endif

        OnCameraDisplay();
    }

    public void OnCameraDisplay()
    {
        //je connais la texture qui contiendra l'image de ma webcam
        // il est tant que je l'applique à ma Raw Image
        planeToRenderTexture.texture = mCameraTexture;

        //on lance la webcam
        mCameraTexture.Play();

    }
}