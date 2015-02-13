//
// Copyright (c) 2015 Harry Cheung
//

import org.robovm.apple.foundation.*;
import org.robovm.apple.uikit.*;

public class AppDelegate extends UIApplicationDelegateAdapter {

  private UIWindow window = null;

  @Override
  public boolean didFinishLaunching(UIApplication application, 
      UIApplicationLaunchOptions launchOptions) {

    window = new UIWindow(UIScreen.getMainScreen().getBounds());
    window.setRootViewController(new MainViewController());
    window.makeKeyAndVisible();
    addStrongRef(window);

    return true;
  }

  public static void main(String[] args) {
    try (NSAutoreleasePool pool = new NSAutoreleasePool()) {
      UIApplication.main(args, null, AppDelegate.class);
    }
  }
}