//
// Copyright (c) 2015 Harry Cheung
//

using System;

namespace Xamarin.Shared
{
	public class Physics
	{
		// x = vt + 1/2att
		public static double Distance(double velocity,
			double acceleration,
			double time) {
			return velocity * time +(acceleration * time * time) / 2;
		}

		// t = (-v + sqrt(2vvax)) / a(quadratic)
		public static double Time(double distance,
		                           double velocity,
															 double acceleration)
		{
			if (acceleration == 0.0) {
				return distance / velocity;
			} else {
				return (-velocity +
					Math.Sqrt(velocity * velocity + 2 * acceleration * distance)) / acceleration;
			}
		}
	}
}

