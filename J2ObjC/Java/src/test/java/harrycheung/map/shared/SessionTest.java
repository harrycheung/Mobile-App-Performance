//
// Copyright (c) 2015 Harry Cheung
//

package harrycheung.map.shared;

import org.junit.Test;
import org.junit.Before;
import org.junit.After;

import java.io.BufferedReader;
import java.io.FileReader;
import java.util.List;

import static org.junit.Assert.*;
import static org.hamcrest.CoreMatchers.*;

public final class SessionTest {

  private Track track;

  @Before
  public void setUp() throws Exception {
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
  }

  @After
  public void tearDown() {
    SessionManager.getInstance().endSession();
  }

  @Test
  public void singleLapSession() throws Exception {
    FileReader fileReader =	new FileReader("../Shared/Data/single_lap_session.csv");
    BufferedReader bufferedReader = new BufferedReader(fileReader);
    String line;
    SessionManager.getInstance().startSession(track);
    double startTime = System.currentTimeMillis() / 1000;
    while ((line = bufferedReader.readLine()) != null) {
      String[] parts = line.split(",");
      SessionManager.getInstance().gps(Double.parseDouble(parts[0]),
          Double.parseDouble(parts[1]),
          Double.parseDouble(parts[2]),
          Double.parseDouble(parts[3]),
          5.0, 15.0,
          startTime);
      startTime += 1;
    }
    Session session = SessionManager.getInstance().session;
    bufferedReader.close();
    SessionManager.getInstance().endSession();

    List<Lap> laps = session.laps;
    assertThat(laps.size(), is(3));
    assertFalse(laps.get(0).valid);
    assertTrue(laps.get(1).valid);
    assertFalse(laps.get(2).valid);
    assertThat(laps.get(0).lapNumber, is(0));
    assertThat(laps.get(1).lapNumber, is(1));
    assertThat(laps.get(2).lapNumber, is(2));
    assertEquals(120.64222, laps.get(1).duration, 0.00001);
    assertEquals(35.85215, laps.get(1).splits[0], 0.00001);
    assertEquals(38.94201, laps.get(1).splits[1], 0.00001);
    assertEquals(45.84806, laps.get(1).splits[2], 0.00001);
    assertEquals(1298.63, laps.get(1).distance, 0.01);
  }

  @Test
  public void multiLapSession() throws Exception {
    FileReader fileReader =	new FileReader("../Shared/Data/multi_lap_session.csv");
    BufferedReader bufferedReader = new BufferedReader(fileReader);
    String line;
    SessionManager.getInstance().startSession(track);
    double startTime = System.currentTimeMillis() / 1000;
    while ((line = bufferedReader.readLine()) != null) {
      String[] parts = line.split(",");
      SessionManager.getInstance().gps(Double.parseDouble(parts[0]),
          Double.parseDouble(parts[1]),
          Double.parseDouble(parts[2]),
          Double.parseDouble(parts[3]),
          5.0, 15.0,
          startTime);
      startTime += 1;
    }
    Session session = SessionManager.getInstance().session;
    bufferedReader.close();
    SessionManager.getInstance().endSession();

    List<Lap> laps = session.laps;
    assertThat(laps.size(), is(6));
    assertFalse(laps.get(0).valid);
    assertTrue(laps.get(1).valid);
    assertTrue(laps.get(2).valid);
    assertTrue(laps.get(3).valid);
    assertTrue(laps.get(4).valid);
    assertFalse(laps.get(5).valid);
    assertThat(laps.get(0).lapNumber, is(0));
    assertThat(laps.get(1).lapNumber, is(1));
    assertThat(laps.get(2).lapNumber, is(2));
    assertThat(laps.get(3).lapNumber, is(3));
    assertThat(laps.get(4).lapNumber, is(4));
    assertThat(laps.get(5).lapNumber, is(5));
    assertEquals(120.64222, laps.get(1).duration, 0.00001);
    assertEquals(100.01685, laps.get(2).duration, 0.00001);
    assertEquals( 96.74609, laps.get(3).duration, 0.00001);
    assertEquals( 94.61198, laps.get(4).duration, 0.00001);
    assertEquals(1298.63, laps.get(1).distance, 0.01);
    assertEquals(1298.69, laps.get(2).distance, 0.01);
    assertEquals(1306.85, laps.get(3).distance, 0.01);
    assertEquals(1306.55, laps.get(4).distance, 0.01);
  }
}