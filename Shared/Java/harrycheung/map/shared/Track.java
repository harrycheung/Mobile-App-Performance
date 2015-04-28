//
// Copyright (c) 2015 Harry Cheung
//

package harrycheung.map.shared;

import org.json.*;

import java.util.ArrayList;
import java.util.List;

public final class Track {

  public String name;

  protected Gate[] gates;
  protected int id;
  protected Gate start;

  private Track(JSONObject json) throws Exception {
    JSONObject jsonTrack = json.getJSONObject("track");
    JSONArray jsonGates = jsonTrack.getJSONArray("gates");
    List<Gate> gateList = new ArrayList<Gate>();
    for (int i = 0; i < jsonGates.length(); i++) {
      JSONObject jsonGate = jsonGates.getJSONObject(i);
      Gate gate = new Gate(GateType.valueOf(jsonGate.getString("gate_type")),
          jsonGate.getInt("split_number"),
          jsonGate.getDouble("latitude"),
          jsonGate.getDouble("longitude"),
          jsonGate.getDouble("bearing"));
      if (gate.type == GateType.START_FINISH ||
          gate.type == GateType.START) {
        start = gate;
      }
      gateList.add(gate);
    }
    id   = jsonTrack.getInt("id");
    name = jsonTrack.getString("name");
    gates = new Gate[gateList.size()];
    gateList.toArray(gates);

    assert(id != 0);
    assert(name != null);
    assert(start != null);
  }

  public static Track[] load(String json) {
    try {
      if (json.startsWith("[")) {
        JSONArray jsonArray = new JSONArray(json);
        Track[] array = new Track[jsonArray.length()];
        for (int i = 0; i < jsonArray.length(); i++) {
          array[i] = new Track(jsonArray.getJSONObject(i));
        }
        return array;
      } else {
        return new Track[] { new Track(new JSONObject(json)) };
      }
    } catch (Exception e) {
      System.out.println(e.getMessage());
      return null;
    }
  }

  public int numSplits() {
    return gates.length;
  }

  public double distanceToStart(double latitude, double longitude) {
    return start.distanceTo(new Point(latitude, longitude));
  }
}