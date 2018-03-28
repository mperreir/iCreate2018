package icreate.icreate2018;

import android.content.Intent;
import android.hardware.Sensor;
import android.hardware.SensorEvent;
import android.hardware.SensorEventListener;
import android.hardware.SensorManager;
import android.media.MediaPlayer;
import android.provider.MediaStore;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.TextView;
import android.widget.Toast;

import java.util.ArrayList;
import java.util.List;

public class ThemeActivity extends AppCompatActivity implements SensorEventListener {
    // Déclaration de l'attribut en tant qu'attribut de l'activité
    // Le sensor manager (gestionnaire de capteurs)
    SensorManager sensorManager;

    MediaPlayer mediaPlayer_1;
    MediaPlayer mediaPlayer_2;
    MediaPlayer mediaPlayer_3;


    // L'accéléromètre
    Sensor accelerometer;

    TextView txt_x;
    TextView txt_y;
    TextView txt_z;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_theme);

        // Gérer les capteurs&#160;:
        // Instancier le gestionnaire des capteurs, le SensorManager
        sensorManager = (SensorManager) getSystemService(SENSOR_SERVICE);
        // Instancier l'accéléromètre
        accelerometer = sensorManager.getDefaultSensor(Sensor.TYPE_ACCELEROMETER);
        // Faire d'autres trucs

        txt_x = findViewById(R.id.x);
        txt_y = findViewById(R.id.y);
        txt_z = findViewById(R.id.z);

        Button play_bt = findViewById(R.id.play);
        mediaPlayer_1 = MediaPlayer.create(this, R.raw.citoyennete_europeene);
        mediaPlayer_2 = MediaPlayer.create(this, R.raw.etre_citoyen_europeen);
        mediaPlayer_3 = MediaPlayer.create(this, R.raw.role_citoyen_europeen);

        mediaPlayer_1.setNextMediaPlayer(mediaPlayer_2);
        mediaPlayer_2.setNextMediaPlayer(mediaPlayer_3);

        play_bt.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                mediaPlayer_1.start();
                Toast.makeText(getApplicationContext(), "Coucou ça fonctionne", Toast.LENGTH_SHORT).show();

            }
        });
    }

    @Override
    protected void onPause() {
        // unregister the sensor (désenregistrer le capteur)
        sensorManager.unregisterListener(this, accelerometer);
        super.onPause();
    }

    @Override
    protected void onResume() {
        /* Ce qu'en dit Google&#160;dans le cas de l'accéléromètre :
         * «&#160; Ce n'est pas nécessaire d'avoir les évènements des capteurs à un rythme trop rapide.
         * En utilisant un rythme moins rapide (SENSOR_DELAY_UI), nous obtenons un filtre
         * automatique de bas-niveau qui "extrait" la gravité  de l'accélération.
         * Un autre bénéfice étant que l'on utilise moins d'énergie et de CPU.&#160;»
         */
        sensorManager.registerListener(this, accelerometer, SensorManager.SENSOR_DELAY_UI);
        super.onResume();
    }

    @Override
    public void onAccuracyChanged(Sensor sensor, int accuracy) {
        // Rien à faire la plupart du temps
    }

    @Override
    public void onSensorChanged(SensorEvent event) {
        if (event.sensor.getType() == Sensor.TYPE_ACCELEROMETER) {
            txt_x.setText(""+event.values[0]);
            txt_y.setText(""+event.values[1]);
            txt_z.setText(""+event.values[2]);
        }
    }
}