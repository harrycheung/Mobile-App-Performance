//
//  TrackLoader.m
//  CPPIOS
//
//  Created by harry on 3/18/15.
//  Copyright (c) 2015 Harry Cheung. All rights reserved.
//

#import "TrackLoader.h"
#import <vector>

@implementation TrackLoader

+ (HCMTrack*)loadWithData:(NSData *)jsonData {
  NSDictionary *gateTypes = @{ @"START": [NSNumber numberWithInt:HCMGate::START],
                               @"START_FINISH": [NSNumber numberWithInt:HCMGate::START_FINISH],
                               @"FINISH": [NSNumber numberWithInt:HCMGate::FINISH],
                               @"SPLIT": [NSNumber numberWithInt:HCMGate::SPLIT] };
  
  HCMGate *start = NULL;
  NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData
                                                             options:NSJSONReadingMutableContainers
                                                               error:nil];
  std::vector<HCMGate*> *gates = new std::vector<HCMGate*>();
  NSDictionary *jsonTrack = jsonObject[@"track"];
  NSArray *jsonGates = jsonTrack[@"gates"];
  for (NSDictionary *jsonGate in jsonGates) {
    HCMGate *gate = new HCMGate(static_cast<HCMGate::Type>([[gateTypes valueForKey:jsonGate[@"gate_type"]] intValue]),
                                [jsonGate[@"split_number"] intValue],
                                [jsonGate[@"latitude"] doubleValue],
                                [jsonGate[@"longitude"] doubleValue],
                                [jsonGate[@"bearing"] doubleValue]);
    if (gate->gateType == HCMGate::START_FINISH || gate->gateType == HCMGate::START) {
      start = gate;
    }
    gates->push_back(gate);
  }

  return new HCMTrack(gates, start);
}

@end

