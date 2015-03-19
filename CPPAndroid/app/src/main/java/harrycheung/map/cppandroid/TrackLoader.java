//
// Copyright (c) 2015 Harry Cheung
//

package harrycheung.map.cppandroid;

import org.json.*;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class TrackLoader {
  private static final Map<String, Integer> gateTypes;
  static {
    Map<String, Integer> aMap = new HashMap<>();
    aMap.put("START", 0);
    aMap.put("START_FINISH", 1);
    aMap.put("FINISH", 2);
    aMap.put("SPLIT", 3);
    gateTypes = Collections.unmodifiableMap(aMap);
  }

  public static HCMTrack loadTrack(String jsonStr) {
    try {
      JSONObject json = new JSONObject(jsonStr);
      JSONObject jsonTrack = json.getJSONObject("track");
      JSONArray jsonGates = jsonTrack.getJSONArray("gates");
      List<HCMGate> gateList = new ArrayList<HCMGate>();
      for (int i = 0; i < jsonGates.length(); i++) {
        JSONObject jsonGate = jsonGates.getJSONObject(i);
        HCMGate gate = new HCMGate(gateTypes.get(jsonGate.getString("gate_type")).intValue(),
            jsonGate.getInt("split_number"),
            jsonGate.getDouble("latitude"),
            jsonGate.getDouble("longitude"),
            jsonGate.getDouble("bearing"));
        gateList.add(gate);
      }
      long[] gates = new long[gateList.size()];
      long start = 0;
      for (int i = 0; i < gateList.size(); i++) {
        HCMGate gate = gateList.get(i);
        gates[i] = gate.nativePointer;
        if (gate.gateType == 0 || gate.gateType == 1) {
          start = gate.nativePointer;
        }
      }
      return new HCMTrack(gates, start);
    } catch (Exception e) {
      return null;
    }
  }
}
