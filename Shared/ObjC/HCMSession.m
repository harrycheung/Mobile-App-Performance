//
//  HCMSession.m
//  ObjC
//
//  Created by harry on 2/27/15.
//  Copyright (c) 2015 Harry Cheung. All rights reserved.
//

#import "HCMSession.h"

@implementation HCMSession

- (id)initWithTrack:(HCMTrack *)track
          startTime:(double)startTime {
  self = [super init];
  if (self) {
    _track = track;
    _startTime = startTime;
    _laps = [[NSMutableArray alloc] init];
    _bestLap = nil;
  }
  return self;
}

- (id)initWithTrack:(HCMTrack *)track {
  return [self initWithTrack:track startTime:[[NSDate date] timeIntervalSince1970]];
}

- (void)dealloc {
  [_laps release];
  [super dealloc];
}

@end
