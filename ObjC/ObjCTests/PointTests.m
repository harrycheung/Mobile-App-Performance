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
  HCMPoint *a =[[HCMPoint alloc] initWithLatitude:5 longitude:5];
  HCMPoint *b =[[HCMPoint alloc] initWithLatitude:10 longitude:10];
  HCMPoint *c = [b subtractWithPoint:a];
  
  XCTAssertEqual([c latitudeDegrees], 5.0);
  XCTAssertEqual([c longitudeDegrees], 5.0);
}

- (void)testBearingTo {
  HCMPoint *a =[[HCMPoint alloc] initWithLatitude:5 longitude:5];
  HCMPoint *b =[[HCMPoint alloc] initWithLatitude:5 longitude:10];
  
  XCTAssertEqual([a bearingToPoint:b], 89.781973);
  XCTAssertEqual([a bearingToPoint:b inRadians: true], 1.566991);
}

- (void)testDestination {
  HCMPoint *a = [[HCMPoint alloc] initWithLatitude:37.452602 longitude:-122.207069];
  HCMPoint *d = [a destinationWithBearing:308 distance:50];
  
  XCTAssertEqual([d latitudeDegrees], 37.452879);
  XCTAssertEqual([d longitudeDegrees], -122.207515);
}

- (void)testDistanceTo {
  HCMPoint *a =[[HCMPoint alloc] initWithLatitude:50.06639 longitude: -5.71472];
  HCMPoint *b =[[HCMPoint alloc] initWithLatitude:58.64389 longitude: -3.07000];
  
  XCTAssertEqualWithAccuracy([a distanceToPoint:b], 968853.52, 0.001);
}

- (void)testIntersectSimple {
  HCMPoint *a =[[HCMPoint alloc] initWithLatitude:5 longitude:5];
  HCMPoint *b =[[HCMPoint alloc] initWithLatitude:15 longitude:15];
  HCMPoint *c =[[HCMPoint alloc] initWithLatitude:5 longitude:15];
  HCMPoint *d =[[HCMPoint alloc] initWithLatitude:15 longitude:5];
  
  HCMPoint *i = [HCMPoint intersectSimpleWithPoint:a
                                         withPoint:b
                                         withPoint:c
                                         withPoint:d];
  
  XCTAssertEqual([i latitudeDegrees], 10);
  XCTAssertEqual([i longitudeDegrees], 10);
}

@end
