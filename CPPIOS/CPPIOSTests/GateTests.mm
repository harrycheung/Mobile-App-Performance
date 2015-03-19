//
//  GateTests.m
//  CPPIOS
//
//  Created by harry on 2/28/15.
//  Copyright (c) 2015 Harry Cheung. All rights reserved.
//

#import <XCTest/XCTest.h>
#include "HCMGate.h"
#include "HCMPoint.h"

@interface GateTests : XCTestCase

@end

@implementation GateTests

- (void)testCrossed {
  HCMGate gate = HCMGate(HCMGate::START_FINISH, 1, 37.452602, -122.207069, 32);
  HCMPoint a = HCMPoint(37.452414, -122.207193, false, 14.210000038146973, 32.09501647949219, 0, 0, 1);
  HCMPoint b = HCMPoint(37.452523, -122.207107, false, 14.239999771118164, 32.09501647949219, 0, 0, 2);
  b.lapDistance = 100.0;
  b.lapTime = 0.1;
  HCMPoint c = HCMPoint(37.45263, -122.207023, false, 14.15999984741211, 32.09501647949219, 0, 0, 3);
  HCMPoint cross = HCMPoint();
  
  XCTAssertFalse(gate.crossed(a, b, cross));
  XCTAssertFalse(gate.crossed(c, b, cross));
  XCTAssertTrue(gate.crossed(b, c, cross));
  XCTAssertTrue(cross.generated);
  XCTAssertEqual(cross.latitudeDegrees(), 37.452593);
  XCTAssertEqual(cross.longitudeDegrees(), -122.207052);
  XCTAssertEqualWithAccuracy(cross.speed, 14.18, 0.01);
  XCTAssertEqualWithAccuracy(cross.bearing, 31.93, 0.01);
  XCTAssertEqualWithAccuracy(cross.timestamp, 2.64915, 0.00001);
  XCTAssertEqualWithAccuracy(cross.lapDistance, b.lapDistance + b.distance(cross), 0.01);
  XCTAssertEqualWithAccuracy(cross.lapTime, 0.74915, 0.00001);
  XCTAssertEqualWithAccuracy(cross.splitTime, 0.64915, 0.00001);
}

@end
