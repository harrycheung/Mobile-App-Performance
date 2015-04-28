//
//  PointTests.m
//  ObjC
//
//  Created by harry on 2/28/15.
//  Copyright (c) 2015 Harry Cheung. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "HCMPoint.h"

@interface PointTests : XCTestCase

@end

@implementation PointTests

- (void)testSubtraction {
  HCMPoint a = HCMPoint(5, 5);
  HCMPoint b = HCMPoint(10, 10);
  HCMPoint c = b.subtract(a);
  
  XCTAssertEqual(c.latitudeDegrees(), 5.0);
  XCTAssertEqual(c.longitudeDegrees(), 5.0);
}

- (void)testBearingTo {
  HCMPoint a = HCMPoint(5, 5);
  HCMPoint b = HCMPoint(5, 10);
  
  XCTAssertEqual(a.bearingTo(b), 89.781973);
  XCTAssertEqual(a.bearingTo(b, true), 1.566991);
}

- (void)testDestination {
  HCMPoint a = HCMPoint(37.452602, -122.207069);
  HCMPoint d = a.destination(308, 50);
  
  XCTAssertEqual(d.latitudeDegrees(), 37.452879);
  XCTAssertEqual(d.longitudeDegrees(), -122.207515);
}

- (void)testDistanceTo {
  HCMPoint a = HCMPoint(50.06639,  -5.71472);
  HCMPoint b = HCMPoint(58.64389,  -3.07000);
  
  XCTAssertEqualWithAccuracy(a.distance(b), 968853.52, 0.001);
}

- (void)testIntersectSimple {
  HCMPoint a = HCMPoint(5, 5);
  HCMPoint b = HCMPoint(15, 15);
  HCMPoint c = HCMPoint(5, 15);
  HCMPoint d = HCMPoint(15, 5);
  HCMPoint intersection = HCMPoint();
  
  XCTAssertTrue(HCMPoint::intersectSimple(a, b, c, d, intersection));
  XCTAssertEqual(intersection.latitudeDegrees(), 10);
  XCTAssertEqual(intersection.longitudeDegrees(), 10);
}

@end
