//
//  HCMSession.h
//  ObjC
//
//  Created by harry on 2/27/15.
//  Copyright (c) 2015 Harry Cheung. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HCMTrack.h"
#import "HCMLap.h"

@class HCMLap;

@interface HCMSession : NSObject

@property(retain) HCMTrack *track;
@property double startTime;
@property double duration;
@property(retain) NSMutableArray *laps;
@property(retain) HCMLap *bestLap;

- (id)initWithTrack:(HCMTrack *)track
          startTime:(double)startTime;

- (id)initWithTrack:(HCMTrack *)track;

@end
