//
//  HCMTrack.h
//  ObjC
//
//  Created by harry on 2/27/15.
//  Copyright (c) 2015 Harry Cheung. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HCMGate.h"

@interface HCMTrack : NSObject

@property(retain) NSMutableArray *gates;
@property int id;
@property(copy) NSString *name;
@property(retain) HCMGate *start;

- (id)initWithDictionary:(NSDictionary *)jsonObject;

- (id)initWithData:(NSData *)jsonData;

- (id)initWithString:(NSString *)filePath;

- (int)numSplits;

@end
