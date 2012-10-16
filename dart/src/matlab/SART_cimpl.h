#ifndef SART_CIMPL_H
#define SART_CIMPL_H

#include "mex.h"
#include <stdlib.h>
#include <time.h>
#include <string.h>

static const double LAMBDA = 0.99;
static bool randStarted = false;

void SART(const double *W, const int m, const int n, const double *p, const int k, double *x, const bool *freePixels,
	const double *beta, const double *gamma, const int numIters);
	
#endif
