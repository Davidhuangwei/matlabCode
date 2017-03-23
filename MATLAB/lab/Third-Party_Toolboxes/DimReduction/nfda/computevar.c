/*
 * Copyright (C) 2002 Harri Valpola and Antti Honkela.
 * 
 * This package comes with ABSOLUTELY NO WARRANTY; for details
 * see License.txt in the program package.  This is free software,
 * and you are welcome to redistribute it under certain conditions;
 * see License.txt for details.
 *
 */

#include <string.h>
#include "matrix.h"
#include "mex.h"


void computevar(double *nvar, double *ac, double *var, int d1, int d2)
{
  int i, d;

  /*
   * d1 = size(nvar, 1); d = d1 * size(nvar, 2);
   */
  d = d1 * d2;

  /*
   * var = nvar;
   */
  memcpy(var, nvar, d*sizeof(double));

  /*
   * for i=2:d, var(:,i) = var(:,i) + ac(:,i).^2 .* var(:,i-1); end
   */
  for (i = d1; i < d; i++)
    var[i] += ac[i] * ac[i] * var[i-d1];

  return;
}



/* Input Arguments */

#define NVAR_IN    prhs[0]
#define AC_IN    prhs[1]

/* Output Arguments */

#define VAR_OUT  plhs[0]

void mexFunction( int nlhs, mxArray *plhs[], 
                  int nrhs, const mxArray *prhs[] )
     
{
  int d1, d2;
  double *nvar, *ac, *var;
    
  /* Check for proper number of arguments */
  if (nrhs != 2) { 
    mexErrMsgTxt("Two input arguments required.");
  } else if (nlhs > 1) {
    mexErrMsgTxt("Too many output arguments."); 
  } 

  d1 = mxGetM(NVAR_IN);
  d2 = mxGetN(NVAR_IN);

  nvar = mxGetPr(NVAR_IN);
  ac = mxGetPr(AC_IN);

  /* Create a matrix for the return argument */ 
  VAR_OUT = mxCreateDoubleMatrix(d1, d2, mxREAL);
  var = mxGetPr(VAR_OUT);

  computevar(nvar, ac, var, d1, d2);

  return;
}
