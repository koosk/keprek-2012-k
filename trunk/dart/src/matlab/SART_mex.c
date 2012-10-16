#include "SART_cimpl.h"

void mexFunction( int nlhs, mxArray *plhs[], 
		  int nrhs, const mxArray*prhs[] )
     
{
	double *W = mxGetPr(prhs[0]);
	double *p = mxGetPr(prhs[1]);
	int wm = mxGetM(prhs[0]);
	int wn = mxGetN(prhs[0]);
	int k = mxGetScalar(prhs[2]);
	plhs[0] = mxDuplicateArray(prhs[3]);/* lemasolom a tombot, mert az input parameter const */
	double *x = mxGetPr(plhs[0]);
	bool *freePixels = mxGetLogicals(prhs[4]);
	double *beta = mxGetPr(prhs[5]);
	double *gamma = mxGetPr(prhs[6]);
	int numIters = mxGetScalar(prhs[7]);
	SART(W,wm,wn,p,k,x,freePixels,beta,gamma, numIters);
}
