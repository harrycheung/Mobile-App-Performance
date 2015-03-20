//
//  HCMLap.h
//  ObjC
//
//  Created by harry on 2/27/15.
//  Copyright (c) 2015 Harry Cheung. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HCMSession.h"
#import "HCMTrack.h"

@class HCMSession;

@interface HCMLap : NSObject

@property(retain) HCMSession *session;
@property(retain) HCMTrack *track;
@property double duration;
@property double distance;
@property bool valid;
@property double startTime;
@property int lapNumber;
@property(retain) NSMutableArray *points;
@property BOOL outLap;
@property double *splits;

- (id)initWithSession:(HCMSession *)session
                track:(HCMTrack *)track
            startTime:(double)startTime
            lapNumber:(int)lapNumber;

- (void)addPoint:(HCMPoint *)point;

@end
