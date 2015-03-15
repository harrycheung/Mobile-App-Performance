//
//  HCMSessionManager.m
//  ObjC
//
//  Created by harry on 2/27/15.
//  Copyright (c) 2015 Harry Cheung. All rights reserved.
//

#import "HCMSessionManager.h"

@implementation HCMSessionManager

+ (id)instance {
  static HCMSessionManager *sharedInstance = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    sharedInstance = [[self alloc] init];
  });
  return sharedInstance;
}

- (id)init {
  return [super init];
}


- (void)startSessionWithTrack:(HCMTrack *)track {
  if (_session == nil) {
    _track = track;
    _session = [[HCMSession alloc] initWithTrack:track];
    _currentLap = [[HCMLap alloc] initWithSession:_session
                                            track:track
                                        startTime:_session.startTime
                                        lapNumber:0];
    [_session.laps addObject:_currentLap];
    _splits = malloc([track numSplits] * sizeof(double));
    _splitGaps = malloc([track numSplits] * sizeof(double));
    _splitStartTime = _session.startTime;
    _splitNumber = 0;
    _currentSplit = 0;
    _lapNumber = 0;
    _gap = 0;
    _bestIndex = 0;
    _nextGate = track.start;
    _bestLap = nil;
    _lastPoint = nil;
  }
}

- (void)endSession {
  if (_session != nil) {
    [_session release];
    free(_splits);
    free(_splitGaps);
    [_currentLap release];
    _session = nil;
    _currentLap = nil;
    _bestLap = nil;
  }
}

- (void)gpsWithLatitude:(double)latitude
              longitude:(double)longitude
                  speed:(double)speed
                bearing:(double)bearing
     horizontalAccuracy:(double)horizontalAccuracy
       verticalAccuracy:(double)verticalAccuracy
              timestamp:(double)timestamp {
  HCMPoint *point = [[[HCMPoint alloc] initWithLatitude:latitude
                                             longitude:longitude
                                                 speed:speed
                                               bearing:bearing
                                    horizontalAccuracy:horizontalAccuracy
                                      verticalAccuracy:verticalAccuracy
                                             timestamp:timestamp] autorelease];
  if (_lastPoint != nil) {
    HCMPoint *cross = [_nextGate crossedWithStart:_lastPoint destination:point];
    if (cross != nil) {
      [_currentLap addPoint:cross];
      _currentLap.splits[_currentSplit] = cross->splitTime;
      switch (_nextGate->type) {
        case START_FINISH:
        case FINISH:
          if (((HCMPoint *)_currentLap.points[0])->generated) {
            _currentLap.valid = true;
            if (_bestLap == nil || _currentLap.duration < _bestLap.duration) {
              _bestLap = _currentLap;
            }
          }
        case START:
          _lapNumber++;
          [_currentLap release];
          _currentLap = [[HCMLap alloc] initWithSession:_session
                                                  track:_track
                                              startTime:cross->timestamp
                                              lapNumber:_lapNumber];
          _lastPoint = [[[HCMPoint alloc] initWithLatitude:[cross latitudeDegrees]
                                                longitude:[cross longitudeDegrees]
                                                    speed:cross->speed
                                                  bearing:cross->bearing
                                       horizontalAccuracy:cross->hAccuracy
                                         verticalAccuracy:cross->vAccuracy
                                                timestamp:cross->timestamp] autorelease];
          _lastPoint->lapDistance = 0;
          _lastPoint->lapTime = 0;
          _lastPoint->generated = true;
          [_currentLap addPoint:_lastPoint];
          [_session.laps addObject:_currentLap];
          _gap = 0;
          for (int i = 0; i < [_track numSplits]; i++) {
            _splitGaps[i] = 0.0;
          }
          _bestIndex = 0;
          _currentSplit = 0;
          break;
        case SPLIT:
          if (_bestLap != nil) {
            _splitGaps[_currentSplit] = _currentLap.splits[_currentSplit] - _bestLap.splits[_currentSplit];
          }
          _currentSplit++;
      }
      _splitStartTime = cross->timestamp;
      _nextGate = _track.gates[_currentSplit];
    }
    if (_bestLap != nil && _bestIndex < _bestLap.points.count) {
      while (_bestIndex < _bestLap.points.count) {
        HCMPoint *refPoint = _bestLap.points[_bestIndex];
        if (refPoint->lapDistance > _currentLap.distance) {
          HCMPoint *lastRefPoint = _bestLap.points[_bestIndex - 1];
          double distanceToLastRefPoint = _currentLap.distance - lastRefPoint->lapDistance;
          if (distanceToLastRefPoint > 0) {
            double sinceLastRefPoint = distanceToLastRefPoint / point->speed;
            _gap = point->lapTime - sinceLastRefPoint - lastRefPoint->lapTime;
            _splitGaps[_currentSplit] = point->splitTime - sinceLastRefPoint - lastRefPoint->splitTime;
          }
          break;
        }
        _bestIndex++;
      }
    }
    point->lapDistance = _lastPoint->lapDistance + [_lastPoint distanceToPoint:point];
    [point setLapTimeWithStartTime:_currentLap.startTime splitStartTime:_splitStartTime];
  }
  [_currentLap addPoint:point];
  _lastPoint = point;
}

@end
