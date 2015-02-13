//
// Copyright (c) 2015 Harry Cheung
//

using NUnit.Framework;
using System;
using Xamarin.Shared;

namespace Xamarin.Test
{
	[TestFixture()]
	public class GateTest
	{
		[Test()]
		public void TestCrossing()
		{
			var gate = new Gate(Gate.Type.START_FINISH, 1, 37.452602,-122.207069, 32);    
			var a = new Point(37.452414, -122.207193, 14.210000038146973, 32.09501647949219, 0, 0, 1);
			var b = new Point(37.452523, -122.207107, 14.239999771118164, 32.09501647949219, 0, 0, 2);
			b.lapDistance = 100.0;
			b.lapTime = 0.1;
			var c = new Point(37.45263, -122.207023, 14.15999984741211, 32.09501647949219, 0, 0, 3);
			var cross = gate.Cross(b, c);

			Assert.Null(gate.Cross(a, b));
			Assert.Null(gate.Cross(c, b));
			Assert.True(cross.generated);
			Assert.AreEqual(37.452593, cross.LatitudeDegrees());
			Assert.AreEqual(-122.207052, cross.LongitudeDegrees());
			Assert.AreEqual(14.18, cross.speed, 0.01);
			Assert.AreEqual(31.93, cross.bearing, 0.01);
			Assert.AreEqual(2.64915, cross.timestamp, 0.00001);
			Assert.AreEqual(b.lapDistance + b.Distance  (cross), cross.lapDistance, 0.01);
			Assert.AreEqual(0.74915, cross.lapTime, 0.00001);
			Assert.AreEqual(0.64915, cross.splitTime, 0.00001);
		}
	}
}

