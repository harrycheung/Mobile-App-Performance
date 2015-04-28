//
// Copyright (c) 2015 Harry Cheung
//

using System;
using System.IO;
using System.Collections.Generic;

using Android.App;
using Android.Widget;
using Android.OS;

using Xamarin.Shared;
using System.Diagnostics;

namespace XamarinAndroid
{
	[Activity(Label = "XamarinAndroid", MainLauncher = true, Icon = "@drawable/icon")]
	public class MainActivity : Activity
	{
		Track track;
		Button button1000;
		Button button10000;
		TextView label1000;
		TextView label10000;
		List<Point> points;

		protected override void OnCreate(Bundle bundle)
		{
			base.OnCreate(bundle);

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

			track = Track.Load(trackJSON)[0];

			string contents;
			using (var sr = new StreamReader(Assets.Open("multi_lap_session.csv")))	{
				contents = sr.ReadToEnd();
			}
			string[] lines = contents.Split('\n');
			points = new List<Point>();
			foreach(string line in lines) {
				string[] parts = line.Split(',');
				points.Add(new Point(
					latitude: Double.Parse(parts[0]),
					longitude: Double.Parse(parts[1]),
					speed: Double.Parse(parts[2]),
					bearing: Double.Parse(parts[3]),
					horizontalAccuracy: 5.0,
					verticalAccuracy: 15.0,
					timestamp: 0));
			}

			SetContentView(Resource.Layout.Main);
			button1000 = FindViewById<Button>(Resource.Id.button1000);
			button10000 = FindViewById<Button>(Resource.Id.button10000);
			label1000 = FindViewById<TextView>(Resource.Id.label1000);
			label10000 = FindViewById<TextView>(Resource.Id.label10000);

			button1000.Click += delegate {
        double timestamp = (DateTime.UtcNow - new DateTime(1970, 1, 1)).TotalSeconds;
        Stopwatch stopWatch = new Stopwatch();
        stopWatch.Start();
        for (int i = 0; i < 1000; i++) {
          SessionManager.Instance().Start(track);
          foreach(Point point in points) {
            SessionManager.Instance().GPS(point.LatitudeDegrees(), 
              longitude: point.LongitudeDegrees(), 
              speed: point.speed, 
              bearing: point.bearing, 
              horizontalAccuracy: point.hAccuracy, 
              verticalAccuracy: point.vAccuracy, 
              timestamp: timestamp);
            timestamp++;
          }
          SessionManager.Instance().End();
        }
        stopWatch.Stop();
        label1000.Text = String.Format("{0:0.000}", stopWatch.Elapsed.TotalSeconds);
			};

      button10000.Click += delegate {
        double timestamp = (DateTime.UtcNow - new DateTime(1970, 1, 1)).TotalSeconds;
        Stopwatch stopWatch = new Stopwatch();
        stopWatch.Start();
        for (int i = 0; i < 10000; i++) {
          SessionManager.Instance().Start(track);
          foreach(Point point in points) {
            SessionManager.Instance().GPS(point.LatitudeDegrees(), 
              longitude: point.LongitudeDegrees(), 
              speed: point.speed, 
              bearing: point.bearing, 
              horizontalAccuracy: point.hAccuracy, 
              verticalAccuracy: point.vAccuracy, 
              timestamp: timestamp);
            timestamp++;
          }
          SessionManager.Instance().End();
        }
        stopWatch.Stop();
        label10000.Text = String.Format("{0:0.000}", stopWatch.Elapsed.TotalSeconds);
			};
		}
	}
}


