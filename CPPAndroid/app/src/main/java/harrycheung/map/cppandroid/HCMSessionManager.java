//
// Copyright (c) 2015 Harry Cheung
//

package harrycheung.map.cppandroid;

public class HCMSessionManager {
  // Singleton
  protected static HCMSessionManager instance = new HCMSessionManager();
  public static HCMSessionManager getInstance() { return instance; }
  private HCMSessionManager() { }

  public native void start(long track, double startTime);
  public native void gps(double latitude, double longitude, double speed, double bearing, double timestamp);
  public native void end();
}
