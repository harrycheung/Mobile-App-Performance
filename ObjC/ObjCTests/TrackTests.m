//
//  TrackTests.m
//  ObjC
//
//  Created by harry on 2/28/15.
//  Copyright (c) 2015 Harry Cheung. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "HCMTrack.h"

@interface TrackTests : XCTestCase

@end

@implementation TrackTests

- (void)testTrackLoadFromJSON {
  NSString *trackJSON = @""
  "{"
    "\"track\": {"
      "\"id\": \"1000\","
      "\"name\": \"Test Raceway\","
      "\"gates\": ["
        "{"
        "\"gate_type\": \"SPLIT\","
        "\"split_number\": \"1\","
        "\"latitude\": \"37.451775\","
        "\"longitude\": \"-122.203657\","
        "\"bearing\": \"136\""
        "},"
        "{"
        "\"gate_type\": \"SPLIT\","
        "\"split_number\": \"2\","
        "\"latitude\": \"37.450127\","
        "\"longitude\": \"-122.205499\","
        "\"bearing\": \"326\""
        "},"
        "{"
        "\"split_number\": \"3\","
        "\"gate_type\": \"START_FINISH\","
        "\"latitude\": \"37.452602\","
        "\"longitude\": \"-122.207069\","
        "\"bearing\": \"32\""
        "}"
      "]"
    "}"
  "}";
  
  HCMTrack *track = [[HCMTrack alloc] initWithData:[trackJSON dataUsingEncoding:NSUTF8StringEncoding]];
  
  XCTAssertEqual(track.id, 1000);
  XCTAssertEqualObjects(track.name, @"Test Raceway");
  XCTAssertEqual([track numSplits], 3);
}

- (void)testTrackLoadFailOnId {
  NSString *trackJSON = @""
  "{"
    "\"track\": {"
      "\"name\": \"Test Raceway\","
      "\"gates\": ["
        "{"
        "\"gate_type\": \"SPLIT\","
        "\"split_number\": \"1\","
        "\"latitude\": \"37.451775\","
        "\"longitude\": \"-122.203657\","
        "\"bearing\": \"136\""
        "},"
        "{"
        "\"gate_type\": \"SPLIT\","
        "\"split_number\": \"2\","
        "\"latitude\": \"37.450127\","
        "\"longitude\": \"-122.205499\","
        "\"bearing\": \"326\""
        "},"
        "{"
        "\"gate_type\": \"START_FINISH\","
        "\"split_number\": \"3\","
        "\"latitude\": \"37.452602\","
        "\"longitude\": \"-122.207069\","
        "\"bearing\": \"32\""
        "}"
      "]"
    "}"
  "}";
  
  HCMTrack *track = [[HCMTrack alloc] initWithData:[trackJSON dataUsingEncoding:NSUTF8StringEncoding]];
  XCTAssertEqual(track.id, 0);
}

@end
