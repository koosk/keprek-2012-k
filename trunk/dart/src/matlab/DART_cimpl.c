#include "DART_cimpl.h"

void buildTau(double *tau, const double *R, const int R_size)
{
	int i;
	for(i=0; i<R_size-1; ++i){
		tau[i] = (R[i]+R[i+1])/2.;
	}
}

void tresholdImage(double *x, const int n, const double *tau, const double *R, const int R_size, const bool *freePixels){
	int i,j;
	for(i=0; i<n; ++i){
		if(freePixels[i]){
			if(x[i]<tau[0]){
				x[i] = R[0];
			}else{
				for(j=0; j<R_size-2; ++j){
					if(x[i]>=tau[j] && x[i]<tau[j+1]){
						x[i] = R[j+1];
						break;
					}
				}
				if(x[i]>=tau[R_size-2]){
					x[i] = R[R_size-1];
				}
			}
		}
	}
}

void determineBoundaryPixels(bool *U, const double *s, const int maxDistinctPixels, const int dim)
{
	int i,j,distinct;
	double current;
	for(i=0; i<dim*dim; ++i){
		U[i] = false;
	}
	for(i=1; i<dim-1; ++i){
		for(j=1; j<dim-1; ++j){
			distinct = 0;
			current = s[i*dim+j];
			if(s[(i-1)*dim+j-1] != current){
				++distinct;
			}
			if(s[(i-1)*dim+j] != current){
				++distinct;
			}
			if(s[(i-1)*dim+j+1] != current){
				++distinct;
			}
			if(s[i*dim+j-1] != current){
				++distinct;
			}
			if(s[i*dim+j+1] != current){
				++distinct;
			}
			if(s[(i+1)*dim+j-1] != current){
				++distinct;
			}
			if(s[(i+1)*dim+j] != current){
				++distinct;
			}
			if(s[(i+1)*dim+j+1] != current){
				++distinct;
			}
			
			if(distinct>maxDistinctPixels){
				U[i*dim+j] = true;
			}
		}	
	}
	
	if(maxDistinctPixels<=2){
		distinct = 0;
		current = s[0];
		if(s[1] != current){
			++distinct;
		}
		if(s[dim] != current){
			++distinct;
		}
		if(s[dim+1] != current){
			++distinct;
		}
		if(distinct>maxDistinctPixels){
			U[0] = true;
		}
		
		distinct = 0;
		current = s[dim-1];
		if(s[dim-2] != current){
			++distinct;
		}
		if(s[2*dim-2] != current){
			++distinct;
		}
		if(s[2*dim-1] != current){
			++distinct;
		}
		if(distinct>maxDistinctPixels){
			U[dim-1] = true;
		}
		
		distinct = 0;
		current = s[dim*dim-dim];
		if(s[dim*dim-2*dim] != current){
			++distinct;
		}
		if(s[dim*dim-2*dim+1] != current){
			++distinct;
		}
		if(s[dim*dim-dim+1] != current){
			++distinct;
		}
		if(distinct>maxDistinctPixels){
			U[dim*dim-dim] = true;
		}
		
		distinct = 0;
		current = s[dim*dim-1];
		if(s[dim*dim-dim-2] != current){
			++distinct;
		}
		if(s[dim*dim-dim-1] != current){
			++distinct;
		}
		if(s[dim*dim-2] != current){
			++distinct;
		}
		if(distinct>maxDistinctPixels){
			U[dim*dim-1] = true;
		}
	}
	
	if(maxDistinctPixels<=5){
		for(i=1; i<dim-1; ++i){
			distinct = 0;
			current = s[i];
			if(s[i-1] != current){
				++distinct;
			}
			if(s[i+1] != current){
				++distinct;
			}
			if(s[i+dim-1] != current){
				++distinct;
			}
			if(s[i+dim] != current){
				++distinct;
			}
			if(s[i+dim+1] != current){
				++distinct;
			}
			if(distinct>maxDistinctPixels){
				U[i] = true;
			}
			
			distinct = 0;
			current = s[dim*dim-1-i];
			if(s[dim*dim-i] != current){
				++distinct;
			}
			if(s[dim*dim-2-i] != current){
				++distinct;
			}
			if(s[dim*dim-dim-i] != current){
				++distinct;
			}
			if(s[dim*dim-dim-i-1] != current){
				++distinct;
			}
			if(s[dim*dim-dim-i-2] != current){
				++distinct;
			}
			if(distinct>maxDistinctPixels){
				U[dim*dim-1-i] = true;
			}
			
			distinct = 0;
			current = s[i*dim];
			if(s[(i-1)*dim] != current){
				++distinct;
			}
			if(s[(i-1)*dim+1] != current){
				++distinct;
			}
			if(s[i*dim+1] != current){
				++distinct;
			}
			if(s[(i+1)*dim] != current){
				++distinct;
			}
			if(s[(i+1)*dim+1] != current){
				++distinct;
			}
			if(distinct>maxDistinctPixels){
				U[i*dim] = true;
			}
			
			distinct = 0;
			current = s[i*dim+dim-1];
			if(s[i*dim-2] != current){
				++distinct;
			}
			if(s[i*dim-1] != current){
				++distinct;
			}
			if(s[i*dim+dim-2] != current){
				++distinct;
			}
			if(s[i*dim+2*dim-2] != current){
				++distinct;
			}
			if(s[i*dim+2*dim-1] != current){
				++distinct;
			}
			if(distinct>maxDistinctPixels){
				U[i*dim+dim-1] = true;
			}
		}
	}
}

void smoothImage(double *x, const double *y, const int dim, const bool *U)
{
	int i,j,k;
	if(U[0]){
		x[0] = 0.7*y[0] + 0.1*(y[1]+y[dim]+y[dim+1]);
	}
	if(U[dim-1]){
		x[dim-1] = 0.7*y[dim-1] + 0.1*(y[dim-2]+y[2*dim-2]+y[2*dim-1]);
	}
	if(U[dim*dim-dim]){
		x[dim*dim-dim] = 0.7*y[dim*dim-dim] + 0.1*(y[dim*dim-2*dim]+y[dim*dim-2*dim+1]+y[dim*dim-dim+1]);
	}
	if(U[dim*dim-1]){
		x[dim*dim-1] = 0.7*y[dim*dim-1] + 0.1*(y[dim*dim-dim-2]+y[dim*dim-dim-1]+y[dim*dim-2]);
	}
	for(i=1; i<dim-1; ++i){
		if(U[i]){
			x[i] = 0.7*y[i] + 0.06*(y[i-1]+y[i+1]+y[i+dim-1]+y[i+dim]+y[i+dim+1]);
		}
		j = dim*dim-1-i;
		if(U[j]){
			x[j] = 0.7*y[j] + 0.06*(y[j-1]+y[j+1]+y[j-dim-1]+y[j-dim]+y[j-dim+1]);
		}
		j = i*dim;
		if(U[j]){
			x[j] = 0.7*y[j] + 0.06*(y[j-dim]+y[j-dim+1]+y[j+1]+y[j+dim]+y[j+dim+1]);
		}
		j = (i+1)*dim-1;
		if(U[j]){
			x[j] = 0.7*y[j] + 0.06*(y[j-dim-1]+y[j-dim]+y[j-1]+y[j+dim-1]+y[j+dim]);
		}
	}
	for(i=1; i<dim-1; ++i){
		for(j=1; j<dim-1; ++j){
			k = i*dim+j;
			if(U[k]){
				x[k] = 0.7*y[k] + 0.0375*(y[k-dim-1]+y[k-dim]+y[k-dim+1]+y[k-1]+y[k+1]+y[k+dim-1]+y[k+dim]+y[k+dim+1]);
			}
		}
	}
}

void DART(const double *p, const double *R, const int R_size, const double *W, const int m, const int n, const int k, 
	const double* beta, const double* gamma, double *x, double *x_dart)
{
	bool ALL_PIXELS[n];
	bool U[n];
	int i,adaptiveCounter;
	const int dim = (int)sqrt(n);
	bool isAdaptive = true;
	double *xt, *xt1, *s, *y;
	double *tau;
	int t = 0;
	double prevProjError = 1000000.;
	double projError;
	
	srand(time(NULL));
	
	if(x==NULL){
		x = x_dart;
		isAdaptive = false;
	}
	for(i=0; i<n; ++i){
		ALL_PIXELS[i] = true;
	}
	for(i=0; i<n; ++i){
		x[i] = 0.5;
	}
	xt = malloc(n*sizeof(double));
	xt1 = malloc(n*sizeof(double));
	s = malloc(n*sizeof(double));
	y = malloc(n*sizeof(double));
	memcpy(xt,x,n*sizeof(double));
	SART(W,m,n,p,k,xt,ALL_PIXELS,beta,gamma,1);
	tau = malloc((R_size-1)*sizeof(double));
	buildTau(tau,R,R_size);
	
	for(adaptiveCounter=0; adaptiveCounter<8; ++adaptiveCounter){
		projError = prevProjError;
		prevProjError += 1.;
		/*while(projError<prevProjError && t<500){*/
		while(t<30){
			memcpy(xt1,xt,n*sizeof(double));
			++t;
			memcpy(s,xt1,n*sizeof(double));
			if(1==t){
				tresholdImage(s,n,tau,R,R_size,ALL_PIXELS);
			}else{
				tresholdImage(s,n,tau,R,R_size,U);
			}
			
			determineBoundaryPixels(U,s,adaptiveCounter,dim);
			for(i=0; i<(int)n*FIX_PROBABILITY; ++i){
				U[rand()%n] = true;
			}
			
			memcpy(y,s,n*sizeof(double));
			SART(W,m,n,p,k,y,U,beta,gamma,10);
			/*memcpy(xt,y,n*sizeof(double));*/
			smoothImage(xt,y,dim,U);
			
			if(t%3==0 || t==1){
				/* TODO calc 2nd norm */
			}
		}
		if(adaptiveCounter==0){
			memcpy(x_dart,xt,n*sizeof(double));
			tresholdImage(x_dart,n,tau,R,R_size,U);
		}
		if(!isAdaptive){
			break;
		}
	}
	if(isAdaptive){
		memcpy(x,xt,n*sizeof(double));
		tresholdImage(x,n,tau,R,R_size,U);
	}
	
	printf("t=%d\n", t);
	printf("projErr=%f, prevProjErr=%f\n", projError, prevProjError);
	
	free(y);
	free(s);
	free(xt1);
	free(xt);
	free(tau);
}

void mexFunction( int nlhs, mxArray *plhs[], 
		  int nrhs, const mxArray*prhs[] )
     
{
	double *p = mxGetPr(prhs[0]);
	double *R = mxGetPr(prhs[1]);
	const int R_size = mxGetN(prhs[1]);
	double *W = mxGetPr(prhs[2]);
	int wm = mxGetM(prhs[2]);
	int wn = mxGetN(prhs[2]);
	int k = mxGetScalar(prhs[3]);
	double *beta = mxGetPr(prhs[4]);
	double *gamma = mxGetPr(prhs[5]);
	plhs[0] = mxCreateDoubleMatrix(wn, 1, mxREAL);
	double *x_dart = mxGetPr(plhs[0]);
	double *x_adart = NULL;
	if(nlhs==2){
		plhs[1] = mxCreateDoubleMatrix(wn, 1, mxREAL);
		x_adart = mxGetPr(plhs[1]);
	}
	
	DART(p,R,R_size,W,wm,wn,k,beta,gamma,x_adart,x_dart);
}
