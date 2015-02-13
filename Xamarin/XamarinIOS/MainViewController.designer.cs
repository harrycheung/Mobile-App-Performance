// WARNING
//
// This file has been generated automatically by Xamarin Studio from the outlets and
// actions declared in your storyboard file.
// Manual changes to this file will not be maintained.
//
using Foundation;
using System;
using System.CodeDom.Compiler;
using UIKit;

namespace XamarinIOS
{
	[Register ("MainViewController")]
	partial class MainViewController
	{
		[Outlet]
		[GeneratedCode ("iOS Designer", "1.0")]
		UILabel label1000 { get; set; }

		[Outlet]
		[GeneratedCode ("iOS Designer", "1.0")]
		UILabel label10000 { get; set; }

		[Action ("clickRun1000:")]
		[GeneratedCode ("iOS Designer", "1.0")]
		partial void clickRun1000 (UIButton sender);

		[Action ("clickRun10000:")]
		[GeneratedCode ("iOS Designer", "1.0")]
		partial void clickRun10000 (UIButton sender);

		void ReleaseDesignerOutlets ()
		{
			if (label1000 != null) {
				label1000.Dispose ();
				label1000 = null;
			}
			if (label10000 != null) {
				label10000.Dispose ();
				label10000 = null;
			}
		}
	}
}
