//
// Copyright (c) 2015 Harry Cheung
//

package harrycheung.map.cppandroid;

public class HCMTrack {
  public long nativePointer;

  HCMTrack(long[] gates, long start) {
    nativePointer = loadTrack(gates, start);
  }

  private static native long loadTrack(long[] gates, long start);
}
