//
//  PhysicsTests.m
//  ObjC
//
//  Created by harry on 2/27/15.
//  Copyright (c) 2015 Harry Cheung. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "HCMPhysics.h"

@interface PhysicsTests : XCTestCase

@end

@implementation PhysicsTests

-(void)testDistance {
  XCTAssertEqual([HCMPhysics distanceFromVelocity:0 acceleration:0 time:0], 0.0);
  XCTAssertEqual([HCMPhysics distanceFromVelocity:1 acceleration:1 time:1], 1.5);
  XCTAssertEqual([HCMPhysics distanceFromVelocity:2 acceleration:2 time:2], 8.0);
  XCTAssertEqual([HCMPhysics distanceFromVelocity:3 acceleration:0 time:3], 9.0);
}

-(void)testTime {
  XCTAssertEqual([HCMPhysics timeFromDistance:1.5 velocity:1 acceleration:1], 1.0);
  XCTAssertEqual([HCMPhysics timeFromDistance:8.0 velocity:2 acceleration:2], 2.0);
  XCTAssertEqual([HCMPhysics timeFromDistance:9.0 velocity:3 acceleration:0], 3.0);
}

@end
