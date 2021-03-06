//
//  AccelerateTests.m
//  LearnKit Tests
//
//  Copyright (c) 2014 Matt Rajca. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <XCTest/XCTest.h>

#import "LNKAccelerate.h"

@interface AccelerateTests : XCTestCase

@end

@implementation AccelerateTests

#define DACCURACY 0.0001

- (void)testSigmoid {
	LNKFloat sample[3] = { 0, -10000000, 10000000 };
	LNK_vsigmoid(sample, 3);
	
	XCTAssertEqualWithAccuracy(sample[0], 0.5, DACCURACY, @"Invalid sigmoid application");
	XCTAssertEqualWithAccuracy(sample[1], 0, DACCURACY, @"Invalid sigmoid application");
	XCTAssertEqualWithAccuracy(sample[2], 1, DACCURACY, @"Invalid sigmoid application");
}

- (void)testSigmoidGradient {
	LNKFloat sample[2] = { 0, 10000000 };
	LNK_vsigmoid(sample, 2);
	LNK_vsigmoidgrad(sample, sample, 2);
	
	XCTAssertEqualWithAccuracy(sample[0], 0.25, DACCURACY, @"Invalid sigmoid application");
	XCTAssertEqualWithAccuracy(sample[1], 0, DACCURACY, @"Invalid sigmoid application");
}

@end
