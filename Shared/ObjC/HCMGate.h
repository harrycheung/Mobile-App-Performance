//
//  HCMGate.h
//  ObjC
//
//  Created by harry on 2/27/15.
//  Copyright (c) 2015 Harry Cheung. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HCMPoint.h"

typedef NS_ENUM(NSInteger, HCMGateType) {
  START,
  START_FINISH,
  FINISH,
  SPLIT
};

@interface HCMGate : HCMPoint {

  @public
  HCMGateType type;
  int splitNumber;
}

- (id)initWithType:(HCMGateType)type
       splitNumber:(int)splitNumber
          latitude:(double)latitude
         longitude:(double)longitude
           bearing:(double)bearing;

- (HCMPoint *)crossedWithStart:(HCMPoint *)start
                   destination:(HCMPoint *)destination;

@end
