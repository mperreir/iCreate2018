package icreate.icreate2018;

import android.content.Intent;
import android.graphics.Typeface;
import android.hardware.Sensor;
import android.hardware.SensorEvent;
import android.hardware.SensorEventListener;
import android.hardware.SensorManager;
import android.media.MediaPlayer;
import android.os.Bundle;
import android.os.CountDownTimer;
import android.support.constraint.ConstraintLayout;
import android.support.v7.app.AppCompatActivity;
import android.view.Display;
import android.view.Surface;
import android.view.View;
import android.widget.TextView;

import java.util.Random;

public class MainActivity extends AppCompatActivity{
    final static String EXTRA_QUESTION_FINAL = "question_final";
    final static String EXTRA_NUM_QUESTION_FINAL = "numero_question_final";

    final static String Q_CITOYENNETE = "Qu'est-ce-que la citoyenneté Européenne ?";
    final static String Q_ETRE_CITOYEN = "Qu'est-ce-que ça nous \napporte d'être \ncitoyen Européen ?";
    final static String Q_ROLE_CITOYEN = "Quel est notre rôle \nen tant que \ncitoyen Européen ?";
    final static String PUSH_ME = "Pousse moi";

    final static String INTRO_REG_FONT_PATH = "fonts/Intro-Regular.otf";

    private boolean END_PLAYING_QUESTION = false;

    ConstraintLayout start_layout;
    ConstraintLayout question_layout;

    // Déclaration de l'attribut en tant qu'attribut de l'activité
    // Le sensor manager (gestionnaire de capteurs)
    SensorManager sensorManager;
    SensorEventListener sensorListener;

    MediaPlayer mediaPlayer_1;
    MediaPlayer mediaPlayer_2;
    MediaPlayer mediaPlayer_3;

    // L'accéléromètre
    Sensor accelerometer;

    TextView q_1;
    TextView q_2;
    TextView q_3;

    TextView hint;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        start_layout = findViewById(R.id.start_layout);
        question_layout = findViewById(R.id.question_layout);
        start_layout.setVisibility(View.VISIBLE);
        question_layout.setVisibility(View.INVISIBLE);

        initStart();

        initTxt();
        initSensor();


        start_layout.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                question_layout.setVisibility(View.VISIBLE);
                start_layout.setVisibility(View.INVISIBLE);
                launchPlayer();
            }
        });
    }

    protected void launchPlayer() {
        //Gestion de la lecture audio des question
        mediaPlayer_1 = MediaPlayer.create(this, R.raw.q_citoyennete_europeene);
        mediaPlayer_2 = MediaPlayer.create(this, R.raw.q_etre_citoyen_europeen);
        mediaPlayer_3 = MediaPlayer.create(this, R.raw.q_role_citoyen_europeen);

        MediaPlayer[] mpl = {mediaPlayer_1, mediaPlayer_2, mediaPlayer_3};
        TextView[] questions_view = {q_1, q_2, q_3};
        String[] text_questions = {Q_CITOYENNETE, Q_ETRE_CITOYEN, Q_ROLE_CITOYEN};

        // lecture question
        launchQuestion(mpl, questions_view, text_questions, 0);

    }

    protected void launchQuestion(final MediaPlayer[] mpl, final TextView[] questions_view, final String[] text_questions , final int toLaunch) {
        if (toLaunch < mpl.length) {
            CountDownTimer countDownTimer = new CountDownTimer(mpl[toLaunch].getDuration() +1000, 1000) {
                public void onTick(long millisUntilFinished) {
                }

                public void onFinish() {
                    if (toLaunch < mpl.length) {
                        launchQuestion(mpl, questions_view, text_questions, toLaunch + 1);
                    }
                }
            };
            mpl[toLaunch].start();
            questions_view[toLaunch].setText(text_questions[toLaunch]);
            countDownTimer.start();
        } else {
            END_PLAYING_QUESTION = true;
            hint.setText(PUSH_ME);
        }
    }

    protected void initStart() {
        Random r = new Random();
        int rand = r.nextInt(2) % 2;

        if(rand == 0)
            start_layout.setBackground(getDrawable(R.drawable.start_screen));
        else
            start_layout.setBackground(getDrawable(R.drawable.start_screen_bis));
    }

    protected void initTxt() {
        Typeface intro_reg = Typeface.createFromAsset(getAssets(),  INTRO_REG_FONT_PATH);

        q_1 = findViewById(R.id.q_1);
        q_2 = findViewById(R.id.q_2);
        q_3 = findViewById(R.id.q_3);
        hint = findViewById(R.id.hint);

        q_1.setTypeface(intro_reg);
        q_2.setTypeface(intro_reg);
        q_3.setTypeface(intro_reg);
        hint.setTypeface(intro_reg);
    }

    protected void initSensor() {
        // Gérer les capteurs
        // Instancier le gestionnaire des capteurs, le SensorManager
        sensorManager = (SensorManager) this.getSystemService(SENSOR_SERVICE);
        // Instancier l'accéléromètre
        accelerometer = sensorManager.getDefaultSensor(Sensor.TYPE_ACCELEROMETER);


        sensorListener = new SensorEventListener() {
            @Override
            public void onAccuracyChanged(Sensor sensor, int accuracy) {
                // Rien à faire la plupart du temps
            }

            @Override
            public void onSensorChanged(SensorEvent event) {
                Sensor sensor = event.sensor;
                float x,y;
                if (sensor.getType() == Sensor.TYPE_ACCELEROMETER && END_PLAYING_QUESTION) {
                    x = event.values[0];
                    y = event.values[1];

                    //Gestion direction du balancier
                    //TRAITEMENT DES QUESTIONS
                    if(x > 1 && y > 2 || y > -2){
                        if(x > 3 && y < 1 && y > -1){
                            sensorManager.unregisterListener(this);
                            sendQuestion(Q_CITOYENNETE, 1);
                        }
                        else if (y > 1.1){
                            sensorManager.unregisterListener(this);
                            sendQuestion(Q_ETRE_CITOYEN, 2);
                        }
                        else if (y < -1.1){
                            sensorManager.unregisterListener(this);
                            sendQuestion(Q_ROLE_CITOYEN, 3);
                        }
                    }
                }
            }
        };
        sensorManager.registerListener(sensorListener, accelerometer, SensorManager.SENSOR_DELAY_GAME);
    }

    protected void sendQuestion(String question, int noQuestion) {
        Intent intent = new Intent(MainActivity.this, Response.class);
        intent.putExtra(EXTRA_QUESTION_FINAL, question);
        intent.putExtra(EXTRA_NUM_QUESTION_FINAL, noQuestion);
        startActivity(intent);
        overridePendingTransition(0,0);
        finish();
    }
}
