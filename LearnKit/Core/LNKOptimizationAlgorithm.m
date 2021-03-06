//
//  LNKOptimizationAlgorithm.m
//  LearnKit
//
//  Copyright (c) 2014 Matt Rajca. All rights reserved.
//

#import "LNKOptimizationAlgorithm.h"

@implementation LNKOptimizationAlgorithmNormalEquations
@end

@implementation LNKOptimizationAlgorithmRegularizable

- (instancetype)init {
	NSAssertNotReachable(@"LNKOptimizationAlgorithmRegularizable is an abstract class. Please use one of its subclasses.", nil);
	return nil;
}

- (instancetype)_init {
	return [super init];
}

@end

@implementation LNKOptimizationAlgorithmGradientDescent

+ (instancetype)algorithmWithAlpha:(LNKFloat)alpha stochastic:(BOOL)stochastic iterationCount:(LNKSize)iterationCount {
	NSParameterAssert(iterationCount != NSNotFound);
	return [[[self alloc] _initWithAlpha:alpha stochastic:stochastic iterationCount:iterationCount convergenceThreshold:0] autorelease];
}

+ (instancetype)algorithmWithAlpha:(LNKFloat)alpha stochastic:(BOOL)stochastic convergenceThreshold:(LNKFloat)convergenceThreshold {
	NSParameterAssert(convergenceThreshold > 0);
	return [[self alloc] _initWithAlpha:alpha stochastic:stochastic iterationCount:NSNotFound convergenceThreshold:convergenceThreshold];
}

- (instancetype)init {
	@throw [NSException exceptionWithName:NSGenericException reason:@"The designated initializer should be used" userInfo:nil];
}

- (instancetype)_initWithAlpha:(LNKFloat)alpha stochastic:(BOOL)stochastic iterationCount:(LNKSize)iterationCount convergenceThreshold:(LNKFloat)convergenceThreshold {
	NSParameterAssert(alpha > 0);
	
	self = [super _init];
	if (self) {
		_alpha = alpha;
		_iterationCount = iterationCount;
		_convergenceThreshold = convergenceThreshold;
		_stochastic = stochastic;
	}
	return self;
}

@end

@implementation LNKOptimizationAlgorithmLBFGS

- (instancetype)init {
	return [super _init];
}

@end

@implementation LNKOptimizationAlgorithmCG

- (instancetype)init {
	self = [super _init];
	if (self) {
		_iterationCount = 100;
	}
	return self;
}

@end
