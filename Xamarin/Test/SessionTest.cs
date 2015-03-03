//
// Copyright (c) 2015 Harry Cheung
//

using NUnit.Framework;
using System;
using System.Collections.Generic;
using System.IO;
using Xamarin.Shared;

namespace Xamarin.Test
{
	[TestFixture()]
	public class SessionTest
	{
		private Track track; 

		[SetUp]
		public void Before()
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
		}

		[TearDown]
		public void After()
		{
			SessionManager.Instance().End();
		}

		[Test()]
		public void TestSingleLap() 
		{			
			double startTime = Helper.CurrentTime();
			SessionManager.Instance().Start(track);

			string content = File.ReadAllText("Assets/single_lap_session.csv");
			string[] lines = content.Split('\n');

			foreach (string line in lines) {
				String[] parts = line.Split(',');
				SessionManager.Instance().GPS(Double.Parse(parts[0]),
					Double.Parse(parts[1]),
					Double.Parse(parts[2]),
					Double.Parse(parts[3]),
					5.0, 15.0,
					startTime);
				startTime += 1;
			}

			List<Lap> laps = SessionManager.Instance().session.laps;
			Assert.AreEqual(3, laps.Count);
			Assert.False(laps[0].valid);
			Assert.True(laps[1].valid);
			Assert.False(laps[2].valid);
			Assert.AreEqual(0, laps[0].lapNumber);
			Assert.AreEqual(1, laps[1].lapNumber);
			Assert.AreEqual(2, laps[2].lapNumber);
			Assert.AreEqual(120.64222, laps[1].duration, 0.00001);
			Assert.AreEqual(35.85215, laps[1].splits[0], 0.00001);
			Assert.AreEqual(38.94201, laps[1].splits[1], 0.00001);
			Assert.AreEqual(45.84806, laps[1].splits[2], 0.00001);
			Assert.AreEqual(1298.63, laps[1].distance, 0.01);
		}

		[Test()]
		public void TestMultiLap() {
			double startTime = Helper.CurrentTime();
			SessionManager.Instance().Start(track);

			string content = File.ReadAllText("Assets/multi_lap_session.csv");
			string[] lines = content.Split('\n');

			foreach (string line in lines) {
				String[] parts = line.Split(',');
				SessionManager.Instance().GPS(Double.Parse(parts[0]),
					Double.Parse(parts[1]),
					Double.Parse(parts[2]),
					Double.Parse(parts[3]),
					5.0, 15.0,
					startTime);
				startTime += 1;
			}

			List<Lap> laps = SessionManager.Instance().session.laps;
			Assert.AreEqual(6, laps.Count);
			Assert.False(laps[0].valid);
			Assert.True(laps[1].valid);
			Assert.True(laps[2].valid);
			Assert.True(laps[3].valid);
			Assert.True(laps[4].valid);
			Assert.False(laps[5].valid);
			Assert.AreEqual(0, laps[0].lapNumber);
			Assert.AreEqual(1, laps[1].lapNumber);
			Assert.AreEqual(2, laps[2].lapNumber);
			Assert.AreEqual(3, laps[3].lapNumber);
			Assert.AreEqual(4, laps[4].lapNumber);
			Assert.AreEqual(5, laps[5].lapNumber);
			Assert.AreEqual(120.64222, laps[1].duration, 0.00001);
			Assert.AreEqual(100.01685, laps[2].duration, 0.00001);
			Assert.AreEqual( 96.74609, laps[3].duration, 0.00001);
			Assert.AreEqual( 94.61198, laps[4].duration, 0.00001);
			Assert.AreEqual(1298.63, laps[1].distance, 0.01);
			Assert.AreEqual(1298.69, laps[2].distance, 0.01);
			Assert.AreEqual(1306.85, laps[3].distance, 0.01);
			Assert.AreEqual(1306.55, laps[4].distance, 0.01);
		}
	}
}

