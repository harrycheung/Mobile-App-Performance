//
// Copyright (c) 2015 Harry Cheung
//

using NUnit.Framework;
using System;
using Xamarin.Shared;

namespace Xamarin.Test
{
	[TestFixture()]
	public class TrackTest
	{
		[Test()]
		public void TestLoadSingle() {
			String trackJSON = ""
				+ "{"
				+   "\"track\": {"
				+     "\"id\": \"1000\","
				+     "\"name\": \"Isabella Raceway\","
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

			Track track = Track.Load(trackJSON)[0];

			Assert.NotNull(track);
			Assert.AreEqual(1000, track.id);
			Assert.AreEqual("Isabella Raceway", track.name);
			Assert.AreEqual(3, track.NumSplits());
		}

		[Test()]
		public void TestLoadFromArray() {
			String trackJSON = ""
				+ "[{"
				+   "\"track\": {"
				+     "\"id\": \"1000\","
				+     "\"name\": \"Isabella Raceway\","
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
				+ "}]";

			Track track = Track.Load(trackJSON)[0];

			Assert.NotNull(track);
			Assert.AreEqual(1000, track.id);
			Assert.AreEqual("Isabella Raceway", track.name);
			Assert.AreEqual(3, track.NumSplits());
		}

		[Test()]
		public void TestLoadingFailure() {
			String trackJSON = ""
				+ "{"
				+   "\"track\": {"
				+     "\"name\": \"Isabella Raceway\","
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

			Assert.Null(Track.Load(trackJSON));
		}
	}
}

