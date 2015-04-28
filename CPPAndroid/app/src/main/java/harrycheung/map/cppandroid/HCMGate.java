//
// Copyright (c) 2015 Harry Cheung
//

package harrycheung.map.cppandroid;

public class HCMGate {
  public long nativePointer;
  public int gateType;

  public HCMGate(int type, int splitNumber, double latitude, double longitude, double bearing) {
    nativePointer = loadGate(type, splitNumber, latitude, longitude, bearing);
    gateType = type;
  }

  private native static long loadGate(int type, int splitNumber,
                                      double latitude, double longitude, double bearing);
}
