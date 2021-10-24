package com.example.qrcode;

import androidx.appcompat.app.AppCompatActivity;

import android.content.Intent;
import android.os.Bundle;
import android.view.SoundEffectConstants;
import android.view.View;
import android.widget.Button;
import android.widget.TextView;

import com.google.android.material.textfield.TextInputEditText;
import com.google.firebase.database.DatabaseReference;
import com.google.firebase.database.FirebaseDatabase;
import com.google.gson.JsonObject;

import org.json.JSONException;
import org.json.JSONObject;
import org.w3c.dom.Text;

import java.net.SocketOption;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

public class MainActivity extends AppCompatActivity {
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        Button btn = (Button)findViewById(R.id.checkout);
        String owner = "London Grant Co";
        TextInputEditText inA = (TextInputEditText) findViewById(R.id.num1);
        TextInputEditText comments = (TextInputEditText) findViewById(R.id.comments);
        TextInputEditText inB = (TextInputEditText) findViewById(R.id.num2);
        TextInputEditText inC = (TextInputEditText) findViewById(R.id.num3);
        TextInputEditText inD = (TextInputEditText) findViewById(R.id.num4);
        TextInputEditText inE = (TextInputEditText) findViewById(R.id.num5);
        TextView itemA = (TextView) findViewById(R.id.item1Name);
        TextView itemB = (TextView) findViewById(R.id.item2Name);
        TextView itemC = (TextView) findViewById(R.id.item3Name);
        TextView itemD = (TextView) findViewById(R.id.item4Name);
        TextView itemE = (TextView) findViewById(R.id.item5Name);
        TextView descA = (TextView) findViewById(R.id.item1Disc);
        TextView descB = (TextView) findViewById(R.id.item2Disc);
        TextView descC = (TextView) findViewById(R.id.item3Disc);
        TextView descD = (TextView) findViewById(R.id.item4Disc);
        TextView descE = (TextView) findViewById(R.id.item5Disc);
        TextView[] items = {itemA, itemB, itemC, itemD, itemE};
        TextView[] descs = {descA, descB, descC, descD, descE};
        TextView[] quant = {inA, inB, inC, inD, inE};
        String[] types = {"Clothes", "Clothes", "Accessory", "Clothes", "Accessory"};
        String[] modifier = {"", "", "E", "", "E"};
        int[] price = {23, 35, 18, 30, 15};
        btn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                FirebaseDatabase database = FirebaseDatabase.getInstance();
                DatabaseReference ref = database.getReference().child("ActiveOrder");
                ref.child("Comments").setValue(comments.getText().toString());

                DateTimeFormatter dtf = DateTimeFormatter.ofPattern("yyyy/MM/dd HH:mm:ss");
                LocalDateTime now = LocalDateTime.now();
                ref.child("Time").setValue(dtf.format(now));
                ref.child("Owner").setValue(owner);
                for(int i = 0; i < 5; i++) {
                    if (Integer.parseInt(quant[i].getText().toString()) != 0) {
                        DatabaseReference newRef = ref.child("orderLines").child(items[i].getText().toString());
                        newRef.child("description").setValue(descs[i].getText().toString());
                        newRef.child("unitPrice").setValue(price[i] * Integer.parseInt(quant[i].getText().toString()));
                        newRef.child("modifierCode").setValue(modifier[i]);
                        newRef.child("itemType").setValue(types[i]);
                        newRef.child("productID").child("value").setValue(items[i].getText().toString());
                        newRef.child("quantity").child("value").setValue(quant[i].getText().toString());
                    }
                }



                startActivity(new Intent(MainActivity.this, MainActivity2.class));

            }
        });
    }

}