//
// Copyright (c) 2015 Harry Cheung
//

using NUnit.Framework;
using System;
using Xamarin.Shared;

namespace Xamarin.Test
{
	[TestFixture()]
	public class PointTest
	{
		[Test()]
		public void TestSubtraction() {
			Point a = new Point(5, 5);
			Point b = new Point(10, 10);
			Point c = b.Subtract(a);

			Assert.AreEqual(5.0, c.LatitudeDegrees());
			Assert.AreEqual(5.0, c.LongitudeDegrees());
		}

		[Test()]
		public void TestBearingTo() {
			Point a = new Point(5, 5);
			Point b = new Point(5, 10);

			Assert.AreEqual(89.781973, a.Bearing(b));
			Assert.AreEqual(1.566991, a.Bearing(b, true));
		}

		[Test()]
		public void TestDestination() {
			Point a = new Point(37.452602, -122.207069);
			Point d = a.Destination(308, 50);

			Assert.AreEqual(37.452879, d.LatitudeDegrees());
			Assert.AreEqual(-122.207515, d.LongitudeDegrees());
		}

		[Test()]
		public void TestDistance() {
			Point a = new Point(50.06639, -5.71472);
			Point b = new Point(58.64389, -3.07000);

			Assert.AreEqual(968854, Math.Round(a.Distance(b)));
		}

		[Test()]
		public void intersect() {
			Point a = new Point(5, 5);
			Point b = new Point(15, 15);
			Point c = new Point(5, 15);
			Point d = new Point(15, 5);

			Point i = Point.IntersectSimple(a, b, c, d);

			Assert.AreEqual(10.0, i.LatitudeDegrees());
			Assert.AreEqual(10.0, i.LongitudeDegrees());
		}
	}
}

