//
//  HCMPoint.h
//  ObjC
//
//  Created by harry on 2/27/15.
//  Copyright (c) 2015 Harry Cheung. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HCMPoint : NSObject

@property double latitude;
@property double longitude;
@property double speed;
@property double bearing;
@property double hAccuracy;
@property double vAccuracy;
@property double timestamp;
@property double lapDistance;
@property double lapTime;
@property double splitTime;
@property double acceleration;
@property BOOL generated;

- (id)initWithLatitude:(double)latitude
             longitude:(double)longitude
             inRadians:(BOOL)inRadians;

- (id)initWithLatitude:(double)latitude
             longitude:(double)longitude;

- (id)initWithLatitude:(double)latitude
             longitude:(double)longitude
               bearing:(double)bearing;

- (id)initWithLatitude:(double)latitude
             longitude:(double)longitude
                 speed:(double)speed
               bearing:(double)bearing
    horizontalAccuracy:(double)horizontalAccuracy
      verticalAccuracy:(double)verticalAccuracy
             timestamp:(double)timestamp;

- (void)setLapTimeWithStartTime:(double)startTime splitStartTime:(double)splitStartTime;

- (double)latitudeDegrees;

- (double)longitudeDegrees;

- (HCMPoint*)subtractWithPoint:(HCMPoint*)point;

- (double)bearingToPoint:(HCMPoint*)point inRadians:(BOOL)inRadians;

- (double)bearingToPoint:(HCMPoint*)point;

- (HCMPoint*)destinationWithBearing:(double)bearing distance:(double)distance;

- (double)distanceToPoint:(HCMPoint*)point;

+ (HCMPoint*)intersectSimpleWithPoint:(HCMPoint*)p
                            withPoint:(HCMPoint*)p2
                            withPoint:(HCMPoint*)q
                            withPoint:(HCMPoint*)q2;
                             
@end
