//
//  SessionTests.m
//  CPPIOS
//
//  Created by harry on 3/1/15.
//  Copyright (c) 2015 Harry Cheung. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "TrackLoader.h"
#include "HCMSessionManager.h"
#include "HCMSession.h"
#include "HCMTrack.h"

@interface SessionTests : XCTestCase

@end

@implementation SessionTests

HCMTrack *track = nil;

- (void)setUp {
  [super setUp];
  
  if (track == nil) {
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
    
    track = [TrackLoader loadWithData:[trackJSON dataUsingEncoding:NSUTF8StringEncoding]];
  }
}

- (void)testSingleLapSession {
  NSString *lapsFilePath = [[NSBundle mainBundle] pathForResource:@"single_lap_session"
                                                           ofType:@"csv"
                                                      inDirectory:@"Data"];
  NSString *contents = [NSString stringWithContentsOfFile:lapsFilePath encoding:NSUTF8StringEncoding error:nil];
  NSArray *lines = [contents componentsSeparatedByString:@"\n"];
  
  double startTime = [[NSDate date] timeIntervalSince1970];
  HCMSessionManager::instance->start(track, startTime);
  for (NSString *line in lines) {
    NSArray *parts = [line componentsSeparatedByString:@","];
    HCMSessionManager::instance->gps([parts[0] doubleValue], [parts[1] doubleValue],
                                     [parts[2] doubleValue], [parts[3] doubleValue],
                                     5.0, 5.0,
                                     startTime);
    startTime++;
  }
  
  HCMSession *session = HCMSessionManager::instance->session;
  XCTAssertEqual(session->laps.size(), 3);
  XCTAssertFalse(session->laps[0]->valid);
  XCTAssertTrue(session->laps[1]->valid);
  XCTAssertFalse(session->laps[2]->valid);
  XCTAssertEqual(session->laps[0]->lapNumber, 0);
  XCTAssertEqual(session->laps[1]->lapNumber, 1);
  XCTAssertEqual(session->laps[2]->lapNumber, 2);
  XCTAssertEqualWithAccuracy(120.64222, session->laps[1]->duration, 0.00001);
  XCTAssertEqualWithAccuracy(35.85215, session->laps[1]->splits[0], 0.00001);
  XCTAssertEqualWithAccuracy(38.94201, session->laps[1]->splits[1], 0.00001);
  XCTAssertEqualWithAccuracy(45.84806, session->laps[1]->splits[2], 0.00001);
  XCTAssertEqualWithAccuracy(1298.63, session->laps[1]->distance, 0.01);
  
  HCMSessionManager::instance->end();
}
   
- (void)testMultiLapSession {
  NSString *lapsFilePath = [[NSBundle mainBundle] pathForResource:@"multi_lap_session"
                                                           ofType:@"csv"
                                                      inDirectory:@"Data"];
  NSString *contents = [NSString stringWithContentsOfFile:lapsFilePath encoding:NSUTF8StringEncoding error:nil];
  NSArray *lines = [contents componentsSeparatedByString:@"\n"];
  
  double startTime = [[NSDate date] timeIntervalSince1970];
  HCMSessionManager::instance->start(track, startTime);
  for (NSString *line in lines) {
    NSArray *parts = [line componentsSeparatedByString:@","];
    HCMSessionManager::instance->gps([parts[0] doubleValue], [parts[1] doubleValue],
                                     [parts[2] doubleValue], [parts[3] doubleValue],
                                     5.0, 5.0,
                                     startTime);
    startTime++;
  }
  
  HCMSession *session = HCMSessionManager::instance->session;
  XCTAssertEqual(session->laps.size(), 6);
  XCTAssertFalse(session->laps[0]->valid);
  XCTAssertTrue(session->laps[1]->valid);
  XCTAssertTrue(session->laps[2]->valid);
  XCTAssertTrue(session->laps[3]->valid);
  XCTAssertTrue(session->laps[4]->valid);
  XCTAssertFalse(session->laps[5]->valid);
  XCTAssertEqual(session->laps[0]->lapNumber, 0);
  XCTAssertEqual(session->laps[1]->lapNumber, 1);
  XCTAssertEqual(session->laps[2]->lapNumber, 2);
  XCTAssertEqual(session->laps[3]->lapNumber, 3);
  XCTAssertEqual(session->laps[4]->lapNumber, 4);
  XCTAssertEqual(session->laps[5]->lapNumber, 5);
  XCTAssertEqualWithAccuracy(120.64222, session->laps[1]->duration, 0.00001);
  XCTAssertEqualWithAccuracy(100.01685, session->laps[2]->duration, 0.00001);
  XCTAssertEqualWithAccuracy( 96.74609, session->laps[3]->duration, 0.00001);
  XCTAssertEqualWithAccuracy( 94.61198, session->laps[4]->duration, 0.00001);
  XCTAssertEqualWithAccuracy(1298.63, session->laps[1]->distance, 0.01);
  XCTAssertEqualWithAccuracy(1298.69, session->laps[2]->distance, 0.01);
  XCTAssertEqualWithAccuracy(1306.85, session->laps[3]->distance, 0.01);
  XCTAssertEqualWithAccuracy(1306.55, session->laps[4]->distance, 0.01);
  
  HCMSessionManager::instance->end();
}

@end
