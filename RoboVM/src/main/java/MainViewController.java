//
// Copyright (c) 2015 Harry Cheung
//

import java.io.BufferedReader;
import java.io.FileReader;
import java.util.ArrayList;
import java.util.List;

import org.robovm.apple.coregraphics.CGRect;
import org.robovm.apple.foundation.NSBundle;
import org.robovm.apple.uikit.*;

import harrycheung.map.shared.*;

public class MainViewController extends UIViewController {

  private Track track;  
  private UIButton button1000;
  private UIButton button10000;
  private UILabel label1000;
  private UILabel label10000;
  private List<Point> points;

  @Override
  public void viewDidLoad() {
    super.viewDidLoad();

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

    track = Track.load(trackJSON)[0];
    try {
      String lapsFilePath = NSBundle.getMainBundle().getResourcePath() + "/multi_lap_session.csv";
      FileReader fileReader =	new FileReader(lapsFilePath);
      BufferedReader bufferedReader = new BufferedReader(fileReader);
      String line;
      points = new ArrayList<Point>();
      while ((line = bufferedReader.readLine()) != null) {
        String[] parts = line.split(",");
        points.add(new Point(Double.parseDouble(parts[0]),
            Double.parseDouble(parts[1]),
            Double.parseDouble(parts[2]),
            Double.parseDouble(parts[3]),
            5.0, 15.0,
            0));
      }
      bufferedReader.close();
    } catch (Exception e) {
      // TODO Auto-generated catch block
      e.printStackTrace();
    }

    getView().setBackgroundColor(UIColor.white());
    double width = getView().getBounds().getWidth();
    button1000 = UIButton.create(UIButtonType.RoundedRect);
    button1000.setFrame(new CGRect(0, 40, width, 30));
    button1000.setTitle("run 1000", UIControlState.Normal);
    button1000.addOnTouchUpInsideListener(new UIControl.OnTouchUpInsideListener() {
      @Override
      public void onTouchUpInside(UIControl control, UIEvent event) {
        run1000();
      }
    });
    getView().addSubview(button1000);
    label1000 = new UILabel();
    label1000.setFrame(new CGRect(0, 80, width, 30));
    label1000.setTextAlignment(NSTextAlignment.Center);
    getView().addSubview(label1000);

    button10000 = UIButton.create(UIButtonType.RoundedRect);
    button10000.setFrame(new CGRect(0, 120, width, 30));
    button10000.setTitle("run 10000", UIControlState.Normal);
    button10000.addOnTouchUpInsideListener(new UIControl.OnTouchUpInsideListener() {
      @Override
      public void onTouchUpInside(UIControl control, UIEvent event) {
        run10000();
      }
    });
    getView().addSubview(button10000);
    label10000 = new UILabel();
    label10000.setFrame(new CGRect(0, 160, width, 30));
    label10000.setTextAlignment(NSTextAlignment.Center);
    getView().addSubview(label10000);
  }

  public void run1000() {
    label1000.setText("" + run(1000));
  }

  public void run10000() {
    label10000.setText("" + run(10000));  	
  }

  private double run(int n) {
    double start = System.currentTimeMillis();
    double startTime = System.currentTimeMillis() / 1000.0;
    for (int i = 0; i < n; i++) {
      SessionManager.getInstance().startSession(track);
      for (Point point : points) {
        SessionManager.getInstance().gps(point.getLatitudeDegrees(), 
            point.getLongitudeDegrees(), point.speed, point.bearing, 
            point.hAccuracy, point.vAccuracy, startTime++);
      }
      SessionManager.getInstance().endSession();
    }
    return (System.currentTimeMillis() - start) / 1000.0;
  }

}
