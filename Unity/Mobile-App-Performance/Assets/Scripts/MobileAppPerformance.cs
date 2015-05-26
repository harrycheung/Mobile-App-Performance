using System;
using System.Collections.Generic;
using System.Diagnostics;
using UnityEngine;
using UnityEngine.UI;
using Xamarin.Shared;

public class MobileAppPerformance : MonoBehaviour {

	public Text label;

	private Track track;
	private List<Point> points;

	public void Start()
	{
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

		TextAsset csv = Resources.Load("multi_lap_session") as TextAsset;
		string contents = csv.text;

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
	}

	public void Run1000()
	{
		label.text = Run(1000);
	}

	public void Run10000()
	{
		label.text = Run(10000);
	}

	private string Run(int n)
	{
		double timestamp = (DateTime.UtcNow - new DateTime(1970, 1, 1)).TotalSeconds;
		Stopwatch stopWatch = new Stopwatch();
		stopWatch.Start();
		for (int i = 0; i < n; i++) {
			SessionManager.Instance().Start(track);
			foreach (Point point in points) {
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
		return String.Format("{0:0.000}", stopWatch.Elapsed.TotalSeconds);
	}

}
