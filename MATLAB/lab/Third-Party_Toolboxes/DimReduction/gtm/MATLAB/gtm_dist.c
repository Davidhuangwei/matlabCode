#include <values.h>
#include "mex.h"


/********************************************************************
* void mexFunction(int nlhs, Matrix *lhsArr[],
* 		   int nrhs, Matrix *rhsArr[])
*
* This mex-file function calculates distances between all data 
* points in the two data sets T and Y and returns them via the 
* global variable matrix gtmGlobalDIST.
*
* nlhs - 1 or 3
*
* nrhs - 2 or 3.
*
* lhsArr[0] = DIST -	Matrix containing the calculated 
*			distances; dimension K-by-N; DIST(k,n) contains the
*			squared distance between T(n,:) and Y(k,:).
*			
* lhsArr[1] = minDist,
*   lhsArr[2] = maxDist	- vectors containing the minimum and maximum of 
*			each column in DIST, respectively; 1-by-N; 
*			required iff m > 0.
*
* rhsArr[0] = T,
*   rhsArr[1] = Y -  these data set matrices in which each row is a 
*                    data point; dimensions N-by-D and K-by-D 
*                    respectively.
*
* rhsArr[2] = m -       mode of calculation; it can be set to 0, 1 or 2 
*			corresponding to increasingly elaborate 
*			measure taken to reduce the amount of
*			numerical errors; mode = 0 will be fast but 
*			less accurate, mode = 2 will be slow but 
*			more accurate; the default mode is m = 0
*
* Version:	The GTM Toolbox v1.0 beta
*
* Copyright:	The GTM Toolbox is distributed under the GNU General Public 
*		Licence (version 2 or later); please refer to the file 
*		licence.txt, included with the GTM Toolbox, for details.
*
*		(C) Copyright Markus Svensen, 1996
*
*******************************************************************/


void mexFunction(int nlhs, Matrix *lhsArr[],
		 int nrhs, Matrix *rhsArr[]) {

  int n, N, d, D, k, K, yD, tD, mode;
  double *T;
  double *Y;
  double *DIST;
  double *minDist;
  double *maxDist;
  double dist, minD, maxD;

  /* Error checking */
  if ((nlhs!=0 && nlhs!=1 && nlhs!=3)  || (nrhs<2) || (nrhs>3)) 
    mexErrMsgTxt("gtm_dist -- wrong number of arguments!\nSynopsis: [DIST, minDist, maxDist] = gtm_dist(T, Y, m)\n");


  /* Get input argument parameters */
  N = mxGetM(rhsArr[0]);
  tD = mxGetN(rhsArr[0]);
  T = mxGetPr(rhsArr[0]);
  K = mxGetM(rhsArr[1]);
  yD = mxGetN(rhsArr[1]);
  Y = mxGetPr(rhsArr[1]);
  if (nrhs == 3)
    mode = (int) mxGetScalar(rhsArr[2]);
  else
    mode = 0;

  /* Error checking */
  if (tD != yD)
    mexErrMsgTxt("gtm_dist -- dimensions of input matrices does not match.\n");
  else
    D = tD;
  if (mode < 0)
    mexErrMsgTxt("gtm_dist -- invalid calculation mode (m).\n");

  /* Create return value matrix (matrices)*/ 
  lhsArr[0] = mxCreateFull(K, N, REAL);
  DIST = mxGetPr(lhsArr[0]);

  if (mode > 0)
    if (nlhs==3) {
      lhsArr[1] = mxCreateFull(1, N, REAL);
      minDist = mxGetPr(lhsArr[1]);
      lhsArr[2] = mxCreateFull(1, N, REAL);
      maxDist = mxGetPr(lhsArr[2]);
    } else
      mexErrMsgTxt("gtm_dist -- Calculations in mode > 0 requires 3 output arguments.\n");

  /* Computational routine - due to the fact that MATLAB store matrices */
  /* columnwise rather than rowwise, the following loop-structure looks */
  /* a bit messy. The compiler is trusted to do the optimisation. */
  for (n = 0; n < N; n++) {
    minD = MAXDOUBLE;
    maxD = 0;
    for (k = 0; k < K; k++) {
      *(DIST + n*K + k) = 0.0;
      for (d = 0; d < D; d++) {
	dist = *(T + d*N + n) - *(Y + d*K + k);
	*(DIST + n*K + k) += dist * dist;
      }
      if (mode > 0) {
	minD = (minD < *(DIST + n*K + k))
	  ? minD : *(DIST + n*K + k);
	maxD = (maxD >= *(DIST + n*K + k))
	  ? maxD : *(DIST + n*K + k);
      }
    }
    if (mode > 0) {
      *(minDist + n) = minD;
      *(maxDist + n) = maxD;
    }
  }
}
