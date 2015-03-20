//
// Copyright (c) 2015 Harry Cheung
//

package harrycheung.map.shared;

import static org.junit.Assert.*;
import static org.hamcrest.CoreMatchers.is;
import harrycheung.map.shared.Track;

import org.junit.Test;

public final class TrackTest {

  @Test
  public void trackLoadFromJSON() {
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

    Track track = Track.load(trackJSON)[0];

    assertNotNull(track);
    assertThat(track.id, is(1000));
    assertThat(track.name, is("Test Raceway"));
    assertThat(track.numSplits(), is(3));
  }

  @Test
  public void trackLoadFromJSONArray() {
    String trackJSON = ""
        + "[{"
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
        + "}]";

    Track track = Track.load(trackJSON)[0];

    assertNotNull(track);
    assertThat(track.id, is(1000));
    assertThat(track.name, is("Test Raceway"));
    assertThat(track.numSplits(), is(3));
  }

  @Test
  public void trackLoadFailOnId() {
    String trackJSON = ""
        + "{"
        +   "\"track\": {"
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

    assertNull(Track.load(trackJSON));
  }
}