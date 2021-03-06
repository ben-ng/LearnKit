//
//  LNKAccelerate.m
//  LearnKit
//
//  Copyright (c) 2014 Matt Rajca. All rights reserved.
//

#import "LNKAccelerate.h"

void LNK_minvert(LNKFloat *matrix, LNKSize n) {
	assert(matrix);
	assert(n);
	
	__CLPK_integer *pivot = malloc(n * n * sizeof(__CLPK_integer));
	__CLPK_integer error = 0;
	__CLPK_integer np = (__CLPK_integer)n;
	LNKFloat *workspace = LNKFloatAlloc(n);
	
#if USE_DOUBLE_PRECISION
	dgetrf_(&np, &np, matrix, &np, pivot, &error);
	dgetri_(&np, matrix, &np, pivot, workspace, &np, &error);
#else
	sgetrf_(&np, &np, matrix, &np, pivot, &error);
	sgetri_(&np, matrix, &np, pivot, workspace, &np, &error);
#endif
	
	free(workspace);
	free(pivot);
}

void LNK_vsigmoid(LNKFloat *vector, LNKSize n) {
	assert(vector);
	assert(n);
	
	const int np = (int)n;
	const LNKFloat one = 1;
	
	// 1 / (1 + e^(-vector))
	LNK_vneg(vector, UNIT_STRIDE, vector, UNIT_STRIDE, n);
	LNK_vexp(vector, vector, &np);
	LNK_vsadd(vector, UNIT_STRIDE, &one, vector, UNIT_STRIDE, n);
	LNK_svdiv(&one, vector, UNIT_STRIDE, vector, UNIT_STRIDE, n);
}

void LNK_vsigmoidgrad(const LNKFloat *vector, LNKFloat *outVector, LNKSize n) {
	assert(vector);
	assert(outVector);
	assert(n);
	
	// sigmoid(vector) (1 - sigmoid(vector))
	LNKFloat *vectorSquared = LNKFloatAlloc(n);
	LNK_vsq(vector, UNIT_STRIDE, vectorSquared, UNIT_STRIDE, n);
	
	LNK_vsub(vectorSquared, UNIT_STRIDE, vector, UNIT_STRIDE, outVector, UNIT_STRIDE, n);
	free(vectorSquared);
}
