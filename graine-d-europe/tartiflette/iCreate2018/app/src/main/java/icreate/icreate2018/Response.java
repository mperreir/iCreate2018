package icreate.icreate2018;

import android.content.Intent;
import android.media.MediaPlayer;
import android.net.Uri;
import android.os.CountDownTimer;
import android.os.Handler;
import android.os.Message;
import android.support.constraint.ConstraintLayout;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.view.View;
import android.widget.TextView;
import android.widget.VideoView;

public class Response extends AppCompatActivity {
    public static final long DISCONNECT_TIMEOUT = 20 * 1000; // en ms

    ConstraintLayout reponse_1;
    ConstraintLayout reponse_2;
    ConstraintLayout reponse_3;

    String uriPath_r_1;
    String uriPath_r_2;
    String uriPath_r_3;

    final static String URI_PATH_PROJECT = "android.resource://icreate.icreate2018/";

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_response);


        ConstraintLayout question_1 = findViewById(R.id.question_1);
        ConstraintLayout question_2 = findViewById(R.id.question_2);
        ConstraintLayout question_3 = findViewById(R.id.question_3);

        question_1.setVisibility(View.GONE);
        question_2.setVisibility(View.GONE);
        question_3.setVisibility(View.GONE);

        Intent intent = getIntent();
        if (intent != null) {
            String question_f = intent.getStringExtra(MainActivity.EXTRA_QUESTION_FINAL);

            int noquestion = intent.getIntExtra(MainActivity.EXTRA_NUM_QUESTION_FINAL, -1);

            ConstraintLayout reponse_layout = findViewById(R.id.reponse_layout);
            switch (noquestion) {
                case 1 :
                    reponse_layout.setBackground(getDrawable(R.mipmap.souche_reponse_1));
                    question_1.setVisibility(View.VISIBLE);
                    reponse_1 = findViewById(R.id.reponse_1_1);
                    reponse_2 = findViewById(R.id.reponse_1_2);
                    reponse_3 = findViewById(R.id.reponse_1_3);

                    uriPath_r_1 = URI_PATH_PROJECT + R.raw.q_1_1;
                    uriPath_r_2 = URI_PATH_PROJECT + R.raw.q_1_2;
                    uriPath_r_3 = URI_PATH_PROJECT + R.raw.q_1_3;

                    break;
                case 2 :
                    reponse_layout.setBackground(getDrawable(R.mipmap.souche_reponse_2));
                    question_2.setVisibility(View.VISIBLE);
                    reponse_1 = findViewById(R.id.reponse_2_1);
                    reponse_2 = findViewById(R.id.reponse_2_2);
                    reponse_3 = findViewById(R.id.reponse_2_3);

                    uriPath_r_1 = URI_PATH_PROJECT + R.raw.q_2_1;
                    uriPath_r_2 = URI_PATH_PROJECT + R.raw.q_2_2;
                    uriPath_r_3 = URI_PATH_PROJECT + R.raw.q_2_3;

                    break;
                case 3 :
                    reponse_layout.setBackground(getDrawable(R.mipmap.souche_reponse_3));
                    question_3.setVisibility(View.VISIBLE);
                    reponse_1 = findViewById(R.id.reponse_3_1);
                    reponse_2 = findViewById(R.id.reponse_3_2);
                    reponse_3 = findViewById(R.id.reponse_3_3);

                    uriPath_r_1 = URI_PATH_PROJECT + R.raw.q_3_1;
                    uriPath_r_2 = URI_PATH_PROJECT + R.raw.q_3_2;
                    uriPath_r_3 = URI_PATH_PROJECT + R.raw.q_3_3;

                    break;
                default:
                    System.err.println("Erreur : changement avec -1 : aucune question correct !");
            }

            reponse_1.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View view) {
                    playVideo(uriPath_r_1);
                }
            });

            reponse_2.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View view) {
                    playVideo(uriPath_r_2);
                }
            });

            reponse_3.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View view) {
                    playVideo(uriPath_r_3);
                }
            });
        }
    }

    /// PLAYER PART ///

    private void playVideo(String uriPath) {
        final VideoView video = findViewById(R.id.videoView);
        Uri uri = Uri.parse(uriPath);
        video.setVideoURI(uri);

        MediaPlayer mp = MediaPlayer.create(video.getContext(), Uri.parse(uriPath));
        int duration = mp.getDuration();
        mp.release();

        System.out.println(duration);
        CountDownTimer countDownTimer = new CountDownTimer(duration, 1000) {
            public void onTick(long millisUntilFinished) {
            }

            public void onFinish() {
                video.setVisibility(View.INVISIBLE);
            }
        };
        video.setVisibility(View.VISIBLE);
        video.requestFocus();
        video.start();
        countDownTimer.start();
    }

    /// DISCONNECT PART ///

    private Handler disconnectHandler = new Handler(){
        public void handleMessage(Message msg) {
        }
    };

    private Runnable disconnectCallback = new Runnable() {
        @Override
        public void run() {
            Intent i = new Intent(Response.this, MainActivity.class);
            startActivity(i);
            overridePendingTransition(0,0);
            finish();
        }
    };

    public void resetDisconnectTimer(){
        disconnectHandler.removeCallbacks(disconnectCallback);
        disconnectHandler.postDelayed(disconnectCallback, DISCONNECT_TIMEOUT);
    }

    public void stopDisconnectTimer(){
        disconnectHandler.removeCallbacks(disconnectCallback);
    }

    @Override
    public void onUserInteraction(){
        resetDisconnectTimer();
    }

    @Override
    public void onResume() {
        super.onResume();
        resetDisconnectTimer();
    }

    @Override
    public void onStop() {
        super.onStop();
        stopDisconnectTimer();
    }
}
