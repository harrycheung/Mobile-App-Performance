//
// Copyright (c) 2015 Harry Cheung
//

using System;

namespace Xamarin.Shared
{
	public struct Point
	{
		private static double RADIUS = 6371000;

		public double latitude, longitude, speed, bearing;
		public double hAccuracy, vAccuracy, timestamp;
		public double lapDistance, lapTime, acceleration;
		public double splitTime;
		public bool generated;

		public double ConvertToRadians(double angle)  {
			return (Math.PI / 180) * angle;
		}

		public double ConvertToDegrees(double angle)  {
			return angle *(180.0 / Math.PI);
		}

		public Point(double latitude, double longitude, bool inRadians) {
			if (inRadians) {
				this.latitude  = latitude;
				this.longitude = longitude;
			} else {
				this.latitude  = ConvertToRadians(latitude);
				this.longitude = ConvertToRadians(longitude);
			}
			this.generated = false;
		}

		public Point(double latitude, double longitude) : this(latitude, longitude, false) {

		}

		public Point(double latitude, double longitude, double bearing) : this(latitude, longitude, false) {
			this.bearing = bearing;
		}

		public Point(double latitude, double longitude, double speed, double bearing,
			double horizontalAccuracy, double verticalAccuracy, double timestamp) : this(latitude, longitude, false) {
			this.speed     = speed;
			this.bearing   = bearing;
			this.hAccuracy = horizontalAccuracy;
			this.vAccuracy = verticalAccuracy;
			this.timestamp = timestamp;
		}

		public void SetLapTime(double startTime, double splitStartTime) {
			lapTime = timestamp - startTime;
			splitTime = timestamp - splitStartTime;
		}

		public double LatitudeDegrees() {
			return Math.Round(ConvertToDegrees(this.latitude), 6);
		}

		public double LongitudeDegrees() {
			return Math.Round(ConvertToDegrees(this.longitude), 6);
		}

		public Point Subtract(Point Point) {
			return new Point(this.latitude - Point.latitude, this.longitude - Point.longitude, true);
		}

		public double Bearing(Point Point, bool inRadians) {
			double φ1 = latitude;
			double φ2 = Point.latitude;
			double Δλ = Point.longitude - this.longitude;

			double y = Math.Sin(Δλ) * Math.Cos(φ2);
			double x = Math.Cos(φ1) * Math.Sin(φ2) - Math.Sin(φ1) * Math.Cos(φ2) * Math.Cos(Δλ);
			double θ = Math.Atan2(y, x);

			if (inRadians) {
				return Math.Round((θ + 2 * Math.PI) % Math.PI, 6);
			} else {
				return Math.Round((ConvertToDegrees(θ) + 2 * 360) % 360, 6);
			}
		}

		public double Bearing(Point Point) {
			return this.Bearing(Point, false);
		}

		public Point Destination(double bearing, double distance) {
			double θ  = ConvertToRadians(bearing);
			double δ  = distance / RADIUS;
			double φ1 = latitude;
			double λ1 = longitude;
			double φ2 = Math.Asin(Math.Sin(φ1) * Math.Cos(δ) + Math.Cos(φ1) * Math.Sin(δ) * Math.Cos(θ));
			double λ2 = λ1 + Math.Atan2(Math.Sin(θ) * Math.Sin(δ) * Math.Cos(φ1), Math.Cos(δ) - Math.Sin(φ1) * Math.Sin(φ2));
			λ2 = (λ2 + 3.0 * Math.PI) %(2.0 * Math.PI) - Math.PI; // normalise to -180..+180

			return new Point(φ2, λ2, true);
		}

		public double Distance(Point point) {
			double φ1 = latitude;
			double λ1 = longitude;
			double φ2 = point.latitude;
			double λ2 = point.longitude;
			double Δφ = φ2 - φ1;
			double Δλ = λ2 - λ1;

			double a = Math.Sin(Δφ / 2) * Math.Sin(Δφ / 2) + Math.Cos(φ1) * Math.Cos(φ2) * Math.Sin(Δλ / 2) * Math.Sin(Δλ / 2);

			return RADIUS * 2 * Math.Atan2(Math.Sqrt(a), Math.Sqrt(1 - a));
		}

		public static Point IntersectSimple(Point p, Point p2, Point q, Point q2) {
			double s1_x = p2.longitude - p.longitude;
			double s1_y = p2.latitude - p.latitude;
			double s2_x = q2.longitude - q.longitude;
			double s2_y = q2.latitude - q.latitude;

			double den = (-s2_x * s1_y + s1_x * s2_y);
			if (den == 0) { return null; }

			double s = (-s1_y *(p.longitude - q.longitude) + s1_x *(p.latitude - q.latitude)) / den;
			double t = ( s2_x *(p.latitude - q.latitude) - s2_y *(p.longitude - q.longitude)) / den;

			if (s >= 0 && s <= 1 && t >= 0 && t <= 1) {
				return new Point(p.latitude +(t * s1_y), p.longitude +(t * s1_x), true);
			}

			return null;
		}
	}
}

