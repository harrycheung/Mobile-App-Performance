//
//  HCMPhysics.h
//  ObjC
//
//  Created by harry on 2/27/15.
//  Copyright (c) 2015 Harry Cheung. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HCMPhysics : NSObject

// x = vt + 1/2att
+ (double)distanceFromVelocity:(double)velocity
                  acceleration:(double)acceleration
                          time:(double)time;

// t = (-v + sqrt(2vvax)) / a (quadratic)
+ (double)timeFromDistance:(double)distance
                  velocity:(double)velocity
              acceleration:(double)acceleration;

@end
