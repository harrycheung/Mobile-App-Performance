//
//  HCMLap.m
//  ObjC
//
//  Created by harry on 2/27/15.
//  Copyright (c) 2015 Harry Cheung. All rights reserved.
//

#import "HCMLap.h"

@implementation HCMLap

- (id)initWithSession:(HCMSession *)session
                track:(HCMTrack *)track
            startTime:(double)startTime
            lapNumber:(int)lapNumber {
  self = [super init];
  if (self) {
    _session   = session;
    _track     = track;
    _startTime = startTime;
    _lapNumber = lapNumber;
    _points    = [[NSMutableArray alloc] init];
    _duration  = 0;
    _distance  = 0;
    _valid     = false;
    _outLap    = lapNumber == 0;
    _splits    = malloc([track numSplits] * sizeof(double));
  }
  return self;
}

- (void)addPoint:(HCMPoint *)point {
  _duration = point->lapTime;
  _distance = point->lapDistance;
  [_points addObject:point];
}

- (void)dealloc {
  [_points release];
  free(_splits);
  [super dealloc];
}

@end
