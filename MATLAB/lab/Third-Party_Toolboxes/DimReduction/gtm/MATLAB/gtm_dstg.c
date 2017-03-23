#include <stdlib.h>
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
* nlhs - 0
*
* lhsArr - NULL
*
* nrhs - 2 or 3.
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
* 
* Global Variables:	gtmGlobalDIST -	Matrix containing the calculated 
*			distances; dimension K-by-N; DIST(k,n) contains the
*			squared distance between T(n,:) and Y(k,:).
*			This matrix is assumed to be pre-allocated; if this
*			is not the case, performance deteriorates
*			dramatically
*			
*			gtmGlobalMinDist, gtmGlobalMaxDist - vectors 
*			containing the minimum and maximum of each 
*			column in DIST, respectively; 1-by-N; 
*			required iff m > 0.
*
*
* Version:	The GTM Toolbox v1.0 beta
*
* Copyright:	The GTM Toolbox is distributed under the GNU General Public 
*		Licence (version 2 or later); please refer to the file 
*		licence.txt, included with the GTM Toolbox, for details.
*
*		(C) Copyright Markus Svensen, 1996
*
********************************************************************/


void mexFunction(int nlhs, Matrix *lhsArr[],
		 int nrhs, Matrix *rhsArr[]) {

  int n, N, d, D, k, K, m, M, mode, tD, yD;
  double minDist, maxDist, dist;
  double *T;
  double *Y;
  Matrix *gtmGlobalDIST_Matrix;
  double *gtmGlobalDIST;
  Matrix *gtmGlobalMinDistMatrix;
  double *gtmGlobalMinDist;
  Matrix *gtmGlobalMaxDistMatrix;
  double *gtmGlobalMaxDist;

  /* Error checking */
  if (nlhs!=0  || nrhs<2 || nrhs>3) 
    mexErrMsgTxt("gtm_dstg -- wrong number of arguments.\nSynopsis: gtm_dstg(T,Y, m)\n");


  /* Get input argument parameters */
  N = mxGetM(rhsArr[0]);
  tD = mxGetN(rhsArr[0]);
  T = mxGetPr(rhsArr[0]);
  K = mxGetM(rhsArr[1]);
  yD = mxGetN(rhsArr[1]);
  Y = mxGetPr(rhsArr[1]);

  /* More error checking */
  if (tD != yD)
    mexErrMsgTxt("gtm_dstg -- dimensions of input matrices does not match.\n");
  else
    D = tD;

  if (nrhs == 3)
    mode = (int) mxGetScalar(rhsArr[2]);
  else
    mode = 0;

  if (mode < 0)
    mexErrMsgTxt("gtm_dstg -- unknown mode of calculation.\n");

  /* Get return matrix (matrices) from the global environment */
  gtmGlobalDIST_Matrix = mexGetGlobal("gtmGlobalDIST");
  if (gtmGlobalDIST_Matrix == NULL)
    mexErrMsgTxt("gtm_dstg -- necessary global variables MUST be pre-allocated with the correct size.\n");

  if (mode > 0) {
    gtmGlobalMinDistMatrix = mexGetGlobal("gtmGlobalMinDist");
    gtmGlobalMaxDistMatrix = mexGetGlobal("gtmGlobalMaxDist");
    if (gtmGlobalMinDistMatrix==NULL || gtmGlobalMaxDistMatrix==NULL)
      mexErrMsgTxt("gtm_dstg -- necessary global variables MUST be pre-allocated with the correct size.\n");
  }

  /* Check that the pre-allocated matrices have got the right size. */
  /* If not, the only solution is to exit with an error message, since */
  /* it is not allowed to re-size MATLAB-owned global variables. */
  if (K!=mxGetM(gtmGlobalDIST_Matrix) || N!=mxGetN(gtmGlobalDIST_Matrix) ||
      (mode>0 && (N!=mxGetN(gtmGlobalMinDistMatrix) || N!=mxGetN(gtmGlobalMaxDistMatrix))))
    mexErrMsgTxt("gtm_dstg -- necessary global variables MUST be pre-allocated with the correct size.\n");
  /* If the sizes are OK, grab the double* for the data of the matrices. */
  else {
    gtmGlobalDIST = mxGetPr(gtmGlobalDIST_Matrix);
    if (mode > 0) {
      gtmGlobalMinDist = mxGetPr(gtmGlobalMinDistMatrix);
      gtmGlobalMaxDist = mxGetPr(gtmGlobalMaxDistMatrix);
    }
  }  

  /* Computational routine - due to the fact that MATLAB store matrices */
  /* columnwise rather than rowwise, the following loop-structure looks */
  /* a bit messy. The compiler is trusted to do the optimisation. */
  for (n = 0; n < N; n++) {
    minDist = MAXDOUBLE;
    maxDist = 0;
    for (k = 0; k < K; k++) {
      *(gtmGlobalDIST + n*K + k) = 0.0;
      for (d = 0; d < D; d++) {
	dist = *(T + d*N + n) - *(Y + d*K + k);
	*(gtmGlobalDIST + n*K + k) += dist * dist;
      }
      if (mode > 0) {
	minDist = (minDist < *(gtmGlobalDIST + n*K + k))
	  ? minDist : *(gtmGlobalDIST + n*K + k);
	maxDist = (maxDist >= *(gtmGlobalDIST + n*K + k))
	  ? maxDist : *(gtmGlobalDIST + n*K + k);
      }
    }
    if (mode > 0) {
      *(gtmGlobalMinDist + n) = minDist;
      *(gtmGlobalMaxDist + n) = maxDist;
    }
  }
}
      
      

