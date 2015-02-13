//
// Copyright (c) 2015 Harry Cheung
//

using System;
using System.Collections.Generic;

namespace Xamarin.Shared
{
	public class Lap
	{
		private Session session;
		private bool outLap;

		public Gate     nextGate;
		public Track    track;
		public double   startTime;
		public int      lapNumber;
		public List<Point> points;
		public double   duration;
		public double   distance;
		public bool  valid;
		public double[] splits;

		public Lap(Session session, Track track, double startTime, int lapNumber) {
			this.session = session;
			this.track = track;
			this.startTime = startTime;
			this.lapNumber = lapNumber;
			this.points = new List<Point>();
			this.duration = 0;
			this.distance = 0;
			this.valid = false;
			this.splits = new double[track.NumSplits()];
			this.outLap = lapNumber == 0;

			if (outLap) { nextGate = track.start; }
		}

		public void Add(Point point) {
			duration = point.lapTime;
			distance = point.lapDistance;
			points.Add(point);
		}
	}
}

