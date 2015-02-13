//
// Copyright (c) 2015 Harry Cheung
//

using Foundation;
using UIKit;

namespace XamarinIOS
{
	[Register("AppDelegate")]
	public partial class AppDelegate : UIApplicationDelegate
	{
		UIWindow window;

		public override bool FinishedLaunching(UIApplication app, NSDictionary options)
		{
			window = new UIWindow(UIScreen.MainScreen.Bounds);
			window.MakeKeyAndVisible();
			
			return true;
		}

		public override UIWindow Window {
			get;
			set;
		}
	}
}

