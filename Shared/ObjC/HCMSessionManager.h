//
//  HCMSessionManager.h
//  ObjC
//
//  Created by harry on 2/27/15.
//  Copyright (c) 2015 Harry Cheung. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HCMSession.h"
#import "HCMLap.h"
#import "HCMPoint.h"
#import "HCMGate.h"

@interface HCMSessionManager : NSObject

@property(retain) HCMSession *session;
@property(retain) HCMLap *currentLap;
@property(retain) HCMLap *bestLap;
@property(retain) HCMPoint *lastPoint;
@property int bestIndex;
@property(retain) HCMGate *nextGate;
@property int gateIter;
@property double *splits;
@property double *splitGaps;
@property double splitStartTime;
@property int splitNumber;
@property(retain) HCMTrack *track;
@property int currentSplit;
@property int lapNumber;
@property double gap;

+ (id)instance;

- (void)startSessionWithTrack:(HCMTrack *)track;

- (void)endSession;

- (void)gpsWithLatitude:(double)latitude
              longitude:(double)longitude
                  speed:(double)speed
                bearing:(double)bearing
     horizontalAccuracy:(double)horizontalAccuracy
       verticalAccuracy:(double)verticalAccuracy
              timestamp:(double)timestamp;

@end
