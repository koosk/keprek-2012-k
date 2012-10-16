#ifndef DART_CIMPL_H
#define DART_CIMPL_H

#include "mex.h"
#include <stdlib.h>
#include <math.h>
#include <time.h>
#include "SART_cimpl.h"

const double FIX_PROBABILITY=0.15;

void DART(const double *p, const double *R, const int R_size, const double *W, const int m, const int n, const int k, 
	const double* beta, const double* gamma, double *x, double *x_adart);
	
#endif
