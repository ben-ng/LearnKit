//
//  _LNKKNNClassifierAC.m
//  LearnKit
//
//  Copyright (c) 2014 Matt Rajca. All rights reserved.
//

#import "_LNKKNNClassifierAC.h"

#import "LNKMatrix.h"

typedef struct {
	LNKFloat distance;
	LNKSize index;
} _LNKDistanceBucket;

@implementation _LNKKNNClassifierAC

- (void)train {
	// k-NN does not involve training.
}

- (LNKClass *)_predictMostFrequentClassWithClosestExamples:(_LNKDistanceBucket *)closestExamples k:(LNKSize)k {
	NSParameterAssert(closestExamples);
	
	const LNKFloat *outputVector = self.matrix.outputVector;
	
	// Vote for the item with the most-frequent class.
	NSCountedSet *frequencies = [[NSCountedSet alloc] initWithCapacity:k];
	
	for (LNKSize kOffset = 0; kOffset < k; kOffset++) {
		const _LNKDistanceBucket example = closestExamples[kOffset];
		const LNKFloat outputValue = outputVector[example.index];
		
		LNKClass *class = [[LNKClass classWithUnsignedInteger:outputValue] retain];
		
		[frequencies addObject:class];
		[class release];
	}
	
	LNKClass *bestClass = nil;
	NSUInteger bestFrequency = 0;
	
	for (LNKClass *class in frequencies) {
		const NSUInteger classFrequency = [frequencies countForObject:class];
		
		if (classFrequency > bestFrequency) {
			bestFrequency = classFrequency;
			bestClass = [class retain];
		}
	}
	
	[frequencies release];
	
	return [bestClass autorelease];
}

- (NSNumber *)_predictAverageOutputWithClosestExamples:(_LNKDistanceBucket *)closestExamples k:(LNKSize)k {
	NSParameterAssert(closestExamples);
	
	const LNKFloat *outputVector = self.matrix.outputVector;
	
	LNKFloat sum = 0;
	
	for (LNKSize kOffset = 0; kOffset < k; kOffset++) {
		const _LNKDistanceBucket example = closestExamples[kOffset];
		sum += outputVector[example.index];
	}
	
	return [NSNumber numberWithLNKFloat:sum / k];
}

- (id)predictValueForFeatureVector:(const LNKFloat *)featureVector length:(LNKSize)length {
	if (!featureVector) {
		@throw [NSException exceptionWithName:NSGenericException reason:@"The feature vector must not be NULL" userInfo:nil];
	}
	
	LNKMatrix *matrix = self.matrix;
	
	if (length != matrix.columnCount) {
		@throw [NSException exceptionWithName:NSGenericException reason:@"The length of the feature vector is incompatible with the matrix" userInfo:nil];
	}
	
	const LNKSize exampleCount = matrix.exampleCount;
	const LNKSize k = self.k;
	const LNKKNNDistanceFunction distanceFunction = self.distanceFunction;
	
	_LNKDistanceBucket *closestExamples = calloc(sizeof(_LNKDistanceBucket), k);
	
	// Find the k closest examples.
	for (LNKSize example = 0; example < exampleCount; example++) {
		const LNKFloat *exampleRow = [matrix exampleAtIndex:example];
		const LNKFloat distance = distanceFunction(exampleRow, featureVector, length);
		
		if (example < k) {
			closestExamples[example].distance = distance;
			closestExamples[example].index = example;
		}
		else {
			for (LNKSize kOffset = 0; kOffset < k; kOffset++) {
				if (distance < closestExamples[kOffset].distance) {
					closestExamples[kOffset].distance = distance;
					closestExamples[kOffset].index = example;
					break;
				}
			}
		}
	}
	
	id predictedValue = nil;
	
	switch (self.outputFunction) {
		case LNKKNNOutputFunctionMostFrequent:
			predictedValue = [self _predictMostFrequentClassWithClosestExamples:closestExamples k:k];
			break;
		case LNKKNNOutputFunctionAverage:
			predictedValue = [self _predictAverageOutputWithClosestExamples:closestExamples k:k];
			break;
	}
	
	free(closestExamples);
	
	return predictedValue;
}

@end
