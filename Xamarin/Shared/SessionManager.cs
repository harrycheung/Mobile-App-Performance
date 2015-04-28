//
// Copyright (c) 2015 Harry Cheung
//

using System;

namespace Xamarin.Shared
{
	public class SessionManager
	{
		public Session session;

		protected Lap currentLap;
		public Lap bestLap;
		protected Track track;
		private int bestIndex;
		private double gap;
		private double[] splitGaps;
		private int currentSplit;
		private Gate nextGate;
		private Point lastPoint;
		private int lapNumber;
		private double splitStartTime;

		// Singleton
		protected static SessionManager instance = new SessionManager();
		public static SessionManager Instance() { return instance; }
		private SessionManager() { }

		public void Start(Track track)
		{
			if (session == null) {
				this.track = track;
				TimeSpan t = DateTime.UtcNow - new DateTime(1970, 1, 1);
				int secondsSinceEpoch = (int)t.TotalSeconds;
				session = new Session(track, secondsSinceEpoch);
				currentLap = new Lap(session, track, session.startTime, 0);
				session.laps.Add(currentLap);
				nextGate = track.start;
				lastPoint = null;
				lapNumber = 0;
				splitStartTime = session.startTime;
				if (bestLap != null) { bestIndex = 0; }
				splitGaps = new double[track.NumSplits()];
			}
		}

		public void End()
		{
			if (session != null) {
				session = null;
				bestLap = null;
			}
		}

		public void GPS(double latitude, double longitude, double speed, double bearing, 
			              double horizontalAccuracy, double verticalAccuracy, double timestamp) 
		{
			Point point = new Point(latitude, longitude, speed, bearing, horizontalAccuracy, verticalAccuracy, timestamp);
			if (lastPoint != null) {
				Point cross = nextGate.Cross(lastPoint, point);
				if (cross != null) {
					currentLap.Add(cross);
					currentLap.splits[currentSplit] = cross.splitTime;
					switch(nextGate.type) {
					case Gate.Type.START_FINISH:
					case Gate.Type.FINISH:
						if (currentLap.points [0].generated) {
							currentLap.valid = true;
							if (bestLap == null || currentLap.duration < bestLap.duration) {
								bestLap = currentLap;
							}
						}
						goto case Gate.Type.START;
					case Gate.Type.START:
						lapNumber++;
						currentLap = new Lap(session, track, cross.timestamp, lapNumber);
						lastPoint = cross;
						lastPoint = new Point(cross.LatitudeDegrees(), cross.LongitudeDegrees(), cross.speed, cross.bearing, cross.hAccuracy, cross.vAccuracy, cross.timestamp);
						lastPoint.lapDistance = 0;
						lastPoint.lapTime = 0;
						lastPoint.generated = true;
						currentLap.Add(lastPoint);
						session.laps.Add(currentLap);
						gap = 0;
						for ( int i = 0; i < splitGaps.Length;i++ ) {
							splitGaps[i] = 0.0;
						}
						bestIndex = 0;
						currentSplit = 0;
						break;
					case Gate.Type.SPLIT:
						if (bestLap != null) {
							splitGaps [currentSplit] = currentLap.splits [currentSplit] - bestLap.splits [currentSplit];
						}
						currentSplit++;
						break;
					}
					splitStartTime = cross.timestamp;
					nextGate = track.gates[currentSplit];
				}
        if (bestLap != null && bestIndex < bestLap.points.Count) {
          while(bestIndex < bestLap.points.Count) {
            var refPoint = bestLap.points[bestIndex];
            if (refPoint.lapDistance > currentLap.distance) {
              var lastRefPoint = bestLap.points[bestIndex - 1];
              var distanceToLastRefPoint = currentLap.distance - lastRefPoint.lapDistance;
              if (distanceToLastRefPoint > 0) {
                var sinceLastRefPoint = distanceToLastRefPoint / point.speed;
                gap = point.lapTime - sinceLastRefPoint - lastRefPoint.lapTime;
                splitGaps[currentSplit] = point.splitTime - sinceLastRefPoint - lastRefPoint.splitTime;
              }
              break;
            }
            bestIndex++;
          }
        }
				point.lapDistance = lastPoint.lapDistance + lastPoint.Distance(point);
				point.SetLapTime(currentLap.startTime, splitStartTime);
			}
			currentLap.Add(point);
			lastPoint = point;
		}
	}
}

