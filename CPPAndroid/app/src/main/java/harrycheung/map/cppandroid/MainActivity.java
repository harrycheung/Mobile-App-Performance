//
// Copyright (c) 2015 Harry Cheung
//

package harrycheung.map.cppandroid;

import android.app.Activity;
import android.os.Bundle;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.widget.Button;
import android.widget.TextView;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.List;

public class MainActivity extends Activity {
  static {
    System.loadLibrary("cppandroid");
  }

  class Point {
    public double latitude, longitude, speed, bearing;

    public Point(double latitude, double longitude, double speed, double bearing) {
      this.latitude = latitude;
      this.longitude = longitude;
      this.speed = speed;
      this.bearing = bearing;
    }
  }

  HCMTrack track;
  List<Point> points;

  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);

    String trackJSON = ""
        + "{"
        +   "\"track\": {"
        +     "\"id\": \"1000\","
        +     "\"name\": \"Test Raceway\","
        +     "\"gates\": ["
        +       "{"
        +       "\"gate_type\": \"SPLIT\","
        +       "\"latitude\": \"37.451775\","
        +       "\"longitude\": \"-122.203657\","
        +       "\"bearing\": \"136\","
        +       "\"split_number\": \"1\""
        +       "},"
        +       "{"
        +       "\"gate_type\": \"SPLIT\","
        +       "\"latitude\": \"37.450127\","
        +       "\"longitude\": \"-122.205499\","
        +       "\"bearing\": \"326\","
        +       "\"split_number\": \"2\""
        +       "},"
        +       "{"
        +       "\"gate_type\": \"START_FINISH\","
        +       "\"latitude\": \"37.452602\","
        +       "\"longitude\": \"-122.207069\","
        +       "\"bearing\": \"32\","
        +       "\"split_number\": \"3\""
        +       "}"
        +     "]"
        +   "}"
        + "}";

    track = TrackLoader.loadTrack(trackJSON);
    assert(track != null);

    points = new ArrayList<>();
    try {
      BufferedReader bufferedReader = new BufferedReader(new InputStreamReader(getAssets().open("multi_lap_session.csv")));
      String line;
      while ((line = bufferedReader.readLine()) != null) {
        String[] parts = line.split(",");
        points.add(new Point(Double.parseDouble(parts[0]),
            Double.parseDouble(parts[1]),
            Double.parseDouble(parts[2]),
            Double.parseDouble(parts[3])));
      }
      bufferedReader.close();
    } catch (Exception e) {
      assert(false);
    }

    setContentView(R.layout.activity_main);
    final Button button1000 = (Button)findViewById(R.id.button1000);
    final Button button10000 = (Button)findViewById(R.id.button10000);
    final TextView label1000 = (TextView)findViewById(R.id.label1000);
    final TextView label10000 = (TextView)findViewById(R.id.label10000);

    button1000.setOnClickListener(new View.OnClickListener() {
      public void onClick(View v) {
        label1000.setText(run(1000));
      }
    });

    button10000.setOnClickListener(new View.OnClickListener() {
      public void onClick(View v) {
        label10000.setText(run(10000));
      }
    });
  }

  private String run(int n) {
    double start = System.currentTimeMillis();
    double startTime = start / 1000.0;
    for (int i = 0; i < n; i++) {
      HCMSessionManager.getInstance().start(track.nativePointer, start);
      for (Point point : points) {
        HCMSessionManager.getInstance().gps(point.latitude, point.longitude,
            point.speed, point.bearing, startTime++);
      }
      HCMSessionManager.getInstance().end();
    }
    return "" + (System.currentTimeMillis() - start) / 1000;
  }

  @Override
  public boolean onCreateOptionsMenu(Menu menu) {
    // Inflate the menu; this adds items to the action bar if it is present.
    getMenuInflater().inflate(R.menu.menu_main, menu);
    return true;
  }

  @Override
  public boolean onOptionsItemSelected(MenuItem item) {
    // Handle action bar item clicks here. The action bar will
    // automatically handle clicks on the Home/Up button, so long
    // as you specify a parent activity in AndroidManifest.xml.
    int id = item.getItemId();

    //noinspection SimplifiableIfStatement
    if (id == R.id.action_settings) {
      return true;
    }

    return super.onOptionsItemSelected(item);
  }

}
