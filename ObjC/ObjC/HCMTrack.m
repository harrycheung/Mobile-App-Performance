//
//  HCMTrack.m
//  ObjC
//
//  Created by harry on 2/27/15.
//  Copyright (c) 2015 Harry Cheung. All rights reserved.
//

#import "HCMTrack.h"

@implementation HCMTrack

- (id)initWithDictionary:(NSDictionary *)jsonObject {
  self = [super init];
  if (self) {
    _gates = [[NSMutableArray alloc] init];
    NSDictionary *gateTypes = @{ @"START": [NSNumber numberWithInt:START],
                                 @"START_FINISH": [NSNumber numberWithInt:START_FINISH],
                                 @"FINISH": [NSNumber numberWithInt:FINISH],
                                 @"SPLIT": [NSNumber numberWithInt:SPLIT] };
    
    NSDictionary *jsonTrack = jsonObject[@"track"];
    NSArray *jsonGates = jsonTrack[@"gates"];
    for (NSDictionary *jsonGate in jsonGates) {
      HCMGate *gate = [[HCMGate alloc] initWithType:[[gateTypes valueForKey:jsonGate[@"gate_type"]] intValue]
                                        splitNumber:[jsonGate[@"split_number"] intValue]
                                           latitude:[jsonGate[@"latitude"] doubleValue]
                                          longitude:[jsonGate[@"longitude"] doubleValue]
                                            bearing:[jsonGate[@"bearing"] doubleValue]];
      if (gate->type == START_FINISH || gate->type == START) {
        _start = gate;
      }
      [_gates addObject:gate];
    }
    _id = [jsonTrack[@"id"] intValue];
    _name = jsonTrack[@"name"];
  }
  return self;
}

- (id)initWithData:(NSData *)jsonData {
  NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData
                                                             options:NSJSONReadingMutableContainers
                                                               error:nil];
  return [self initWithDictionary:jsonObject];

}

- (id)initWithString:(NSString *)filePath {
  NSData *content = [NSData dataWithContentsOfFile:filePath];
  return [self initWithData:content];
}

- (int)numSplits {
  return (int)_gates.count;
}

- (void)dealloc {
  NSLog(@"track dealloc");
  [_gates release];
  [super dealloc];
}


@end
