/*
 * Copyright (C) 2002 Harri Valpola and Antti Honkela.
 * 
 * This package comes with ABSOLUTELY NO WARRANTY; for details
 * see License.txt in the program package.  This is free software,
 * and you are welcome to redistribute it under certain conditions;
 * see License.txt for details.
 *
 */

#include "matrix.h"
#include "mex.h"


void computevard(double *dcp_dsv, double *dcp_dsvn, double *ac,
		 double *mv, double *newac, int d1, int d2)
{
  int i, j, d;

  d = d1 * d2;

  /*
   * for i=1:size(mv,1), newac(i,2:end)=mv(i,i,:); end
   */
  for (i = 0; i < d1; i++)
    for (j = 1; j < d2; j++)
      newac[i+j*d1] = mv[i + i*d1 + (j-1)*d1*d1];

  /*
   * for i=d:-1:2
   *   newac(:,i) .*= dcp_dsvn(:,i) ./ (dcp_dsvn(:,i) + dcp_dsv(:,i));
   *   dcp_dsvn(:,i) += dcp_dsv(:,i);
   *   dcp_dsv(:,i-1) += newac(:,i).^2 .* dcp_dsv(:,i);
   * end
   */
  for (i = d-1; i>= d1; i--) {
    newac[i] *= dcp_dsvn[i] / (dcp_dsvn[i] + dcp_dsv[i]);
    dcp_dsvn[i] += dcp_dsv[i];
    dcp_dsv[i-d1] += newac[i] * newac[i] * dcp_dsv[i];
  }
  /*
   * dcp_dsvn(:,1) += dcp_dsv(:,1);
   */
  for (i = 0; i < d1; i++)
    dcp_dsvn[i] += dcp_dsv[i];

  return;
}



/*
 * function [dcp_dsvn, newac] = computevard(dcp_dsv, dcp_dsvn, ac, mv)
 */

/* Input Arguments */

#define DCP_DSV_IN    prhs[0]
#define DCP_DSVN_IN    prhs[1]
#define AC_IN    prhs[2]
#define MV_IN    prhs[3]

/* Output Arguments */

#define DCP_DSVN_OUT  plhs[0]
#define NEWAC_OUT  plhs[1]

void mexFunction( int nlhs, mxArray *plhs[], 
                  int nrhs, const mxArray *prhs[] )
     
{
  int d1, d2;
  double *dcp_dsv, *dcp_dsvn, *ac, *mv, *newac;
  mxArray *dcp_dsv_copy;
    
  /* Check for proper number of arguments */
  if (nrhs != 4) { 
    mexErrMsgTxt("Four input arguments required.");
  } else if (nlhs > 2) {
    mexErrMsgTxt("Too many output arguments."); 
  } 

  d1 = mxGetM(AC_IN);
  d2 = mxGetN(AC_IN);

  dcp_dsv_copy = mxDuplicateArray(DCP_DSV_IN);
  DCP_DSVN_OUT = mxDuplicateArray(DCP_DSVN_IN);

  dcp_dsv = mxGetPr(dcp_dsv_copy);
  dcp_dsvn = mxGetPr(DCP_DSVN_OUT);
  ac = mxGetPr(AC_IN);
  mv = mxGetPr(MV_IN);

  /* Create a matrix for the return argument */ 
  NEWAC_OUT = mxCreateDoubleMatrix(d1, d2, mxREAL);
  newac = mxGetPr(NEWAC_OUT);

  computevard(dcp_dsv, dcp_dsvn, ac, mv, newac, d1, d2);

  mxDestroyArray(dcp_dsv_copy);

  return;
}
