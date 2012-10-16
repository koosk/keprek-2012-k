#include "SART_cimpl.h"

void randomPermutation(int *sigma, const int d)
{
	int i;
	int rnd;
	int tmp;
	for(i=0; i<d; ++i){
		sigma[i] = i;
	}
	for(i=0; i<d/2; ++i){
		rnd = rand()%d;
		if(rnd!=i){
			tmp = sigma[i];
			sigma[i] = sigma[rnd];
			sigma[rnd] = tmp;
		}
	}
}

void SART(const double *W, const int m, const int n, const double *p, const int k, double *x, const bool *freePixels,
	const double *beta, const double *gamma, const int numIters)
{
	const int d = m/k;
	int i,j,l;
	int *sigma;
	double *xnew, *xtmp;
	const double *xOrig = x;
	int s;
	double *r;
	double summa;
	int iterCounter;
	if(!randStarted){
		srand(time(NULL));
		randStarted = true;
	}

	sigma = calloc(d, sizeof(int));
	randomPermutation(sigma, d);
	
	xnew = calloc(n, sizeof(double));
	memcpy(xnew, x, n*sizeof(double));
	
	r = malloc(m*sizeof(double));
	
	
	memcpy(r,p,m*sizeof(double));
	/* r inicializalasa */
	for(i=0; i<m; ++i){
		for(j=0; j<n; ++j){
			r[i] -= W[j*m+i]*x[j];
		}
	}
	xtmp = x;
	x = xnew;
	xnew = xtmp;
	
	for(iterCounter=0; iterCounter<numIters; ++iterCounter){
		for(s=0; s<d; ++s){
			/* szukseges r ertekek frissitese az iteraciokon belul */
			if(iterCounter!=0 || s!=0){
				for(j=0; j<n; ++j){
					if(!freePixels[j]){
						continue;
					}
					for(i=0; i<m; ++i){
						r[i] += W[j*m+i]*x[j];
						r[i] -= W[j*m+i]*xnew[j];
					}
				}
			}
			xtmp = x;
			x = xnew;
			xnew = xtmp;
	
			for(j=0; j<n; ++j){
				if(!freePixels[j]){
					continue;
				}
				summa = 0.;
				for(i=0; i<k; ++i){
					if(0.0==beta[ i*d+sigma[s] ]){
						continue;
					}
					summa += W[ j*m+(sigma[s]*k+i) ] * r[sigma[s]*k+i] / beta[ i*d+sigma[s] ];
				}
				xnew[j] = x[j] + (LAMBDA/gamma[ j*d+sigma[s] ]) * summa;
			}
		}
	}
	if(x!=xOrig){
		xtmp = x;
		x = xnew;
		xnew = xtmp;
		memcpy(x,xnew,n*sizeof(double));
	}
	free(r);
	free(xnew);
	free(sigma);
}

