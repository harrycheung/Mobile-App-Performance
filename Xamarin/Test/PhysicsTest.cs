//
// Copyright (c) 2015 Harry Cheung
//

using NUnit.Framework;
using Xamarin.Shared;

namespace Xamarin.Shared
{
	[TestFixture()]
	public class PhysicsTest
	{
		[Test()]
		public void TestDistance() {
			Assert.AreEqual(0.0, Physics.Distance(0, 0, 0));
			Assert.AreEqual(1.5, Physics.Distance(1, 1, 1));
			Assert.AreEqual(8.0, Physics.Distance(2, 2, 2));
			Assert.AreEqual(9.0, Physics.Distance(3, 0, 3));
		}

		[Test()]
		public void TestTime() {
			Assert.AreEqual(1.0, Physics.Time(1.5, 1, 1));
			Assert.AreEqual(2.0, Physics.Time(8.0, 2, 2));
			Assert.AreEqual(3.0, Physics.Time(9.0, 3, 0));
		}
	}
}

