//
//  PhysicsTests.m
//  CPPIOS
//
//  Copyright (c) 2015 Harry Cheung. All rights reserved.
//

#import <XCTest/XCTest.h>
#include "HCMPhysics.h"

@interface PhysicsTests : XCTestCase

@end

@implementation PhysicsTests

-(void)testDistance {
  XCTAssertEqual(HCMPhysics::distance(0, 0, 0), 0.0);
  XCTAssertEqual(HCMPhysics::distance(1, 1, 1), 1.5);
  XCTAssertEqual(HCMPhysics::distance(2, 2, 2), 8.0);
  XCTAssertEqual(HCMPhysics::distance(3, 0, 3), 9.0);
}

-(void)testTime {
  XCTAssertEqual(HCMPhysics::time(1.5, 1, 1), 1.0);
  XCTAssertEqual(HCMPhysics::time(8.0, 2, 2), 2.0);
  XCTAssertEqual(HCMPhysics::time(9.0, 3, 0), 3.0);
}

@end
