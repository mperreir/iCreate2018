package icreate.icreate2018;

import android.content.Intent;
import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.view.View;
import android.widget.Button;

import java.util.ArrayList;

public class MainActivity extends AppCompatActivity {
    final static String EXTRA_THEME_NAME = "theme_name";


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        ArrayList<Button> buttonList = new ArrayList<>();
        buttonList.add((Button)findViewById(R.id.button_1));
        buttonList.add((Button)findViewById(R.id.button_2));
        buttonList.add((Button)findViewById(R.id.button_3));


        for (final Button bt : buttonList) {
            bt.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View view) {

                    Intent intent1 = new Intent(MainActivity.this, ThemeActivity.class);
                    intent1.putExtra(EXTRA_THEME_NAME, bt.getText());

                    startActivity(intent1);
                }
            });
        }
    }
}
