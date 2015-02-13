//
// Copyright (c) 2015 Harry Cheung
//

using System;

namespace Xamarin.Shared
{
	public class Gate : Point
	{
		public enum Type { START, START_FINISH, FINISH, SPLIT };

		static int LINE_WIDTH    = 80;
		static int BEARING_RANGE = 90;

		public Type type;
		public int splitNumber;
		Point leftPoint, rightPoint;

		public Gate(Type type, int splitNumber,
			double latitude, double longitude, double bearing) : base(latitude, longitude, bearing) {
			this.type = type;
			this.splitNumber = splitNumber;
			double leftBearing  = bearing - 90 < 0 ? bearing + 270 : bearing - 90;
			double rightBearing = bearing + 90 > 360 ? bearing - 270 : bearing + 90;
			this.leftPoint  = Destination(leftBearing, LINE_WIDTH / 2);
			this.rightPoint = Destination(rightBearing, LINE_WIDTH / 2);
		}

		public Point Cross(Point start, Point destination) {
			double pathBearing = start.Bearing(destination);
			Point cross = null;
			if (pathBearing > bearing - BEARING_RANGE &&
				pathBearing < bearing + BEARING_RANGE) {
				cross = Point.IntersectSimple(leftPoint, rightPoint, start, destination);
				if (cross != null) {
					double distance = start.Distance(cross);
					double timeDifference = destination.timestamp - start.timestamp;
					double acceleration = (destination.speed - start.speed) / timeDifference;
					double time = Physics.Time(distance, start.speed, acceleration);
					cross.generated = true;
					cross.speed = start.speed + acceleration * time;
					cross.bearing = start.Bearing(destination);
					cross.timestamp = start.timestamp + time;
					cross.lapDistance = start.lapDistance + distance;
					cross.lapTime = start.lapTime + time;
					cross.splitTime = start.splitTime + time;
				}
			}
			return cross;
		}
	}
}

