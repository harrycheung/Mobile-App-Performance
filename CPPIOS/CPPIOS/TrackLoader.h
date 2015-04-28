//
//  TrackLoader.h
//  CPPIOS
//
//  Created by harry on 3/18/15.
//  Copyright (c) 2015 Harry Cheung. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "HCMTrack.h"

@interface TrackLoader : NSObject

+ (HCMTrack*)loadWithData:(NSData *)jsonData;

@end
