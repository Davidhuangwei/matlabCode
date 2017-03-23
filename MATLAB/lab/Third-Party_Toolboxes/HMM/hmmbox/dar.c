/*
 * MATLAB Compiler: 2.0
 * Date: Sun Dec 17 13:07:34 2000
 * Arguments: "-x" "dar.m" 
 */
#include "dar.h"
#include "gauss.h"
#include "waitbar.h"

/*
 * The function "Mdar" is the implementation version of the "dar" M-function
 * from file "c:\matlabr11\toolbox\hmmbox\dar.m" (lines 1-117). It contains the
 * actual compiled code for that M-function. It is a static function and must
 * only be called from one of the interface functions, appearing below.
 */
/*
 * function [A,ev,error,gain,sigma_obs,sigma_wu,pvol,state_noise,sigma_wu_q0] = dar(Z,p,V,ALPHA);
 */
static mxArray * Mdar(mxArray * * ev,
                      mxArray * * error,
                      mxArray * * gain,
                      mxArray * * sigma_obs,
                      mxArray * * sigma_wu,
                      mxArray * * pvol,
                      mxArray * * state_noise,
                      mxArray * * sigma_wu_q0,
                      int nargout_,
                      mxArray * Z,
                      mxArray * p,
                      mxArray * V,
                      mxArray * ALPHA) {
    mxArray * A = mclGetUninitializedArray();
    mxArray * C = mclGetUninitializedArray();
    mxArray * D = mclGetUninitializedArray();
    mxArray * F = mclGetUninitializedArray();
    mxArray * K = mclGetUninitializedArray();
    mxArray * N = mclGetUninitializedArray();
    mxArray * Q = mclGetUninitializedArray();
    mxArray * Qqzero = mclGetUninitializedArray();
    mxArray * R = mclGetUninitializedArray();
    mxArray * SEG = mclGetUninitializedArray();
    mxArray * SHIFT = mclGetUninitializedArray();
    mxArray * W = mclGetUninitializedArray();
    mxArray * a = mclGetUninitializedArray();
    mxArray * ans = mclInitializeAns();
    mxArray * e = mclGetUninitializedArray();
    mxArray * h = mclGetUninitializedArray();
    mclForLoopIterator iterator_0;
    mxArray * n = mclGetUninitializedArray();
    mxArray * nargin_ = mclGetUninitializedArray();
    mxArray * new_q = mclGetUninitializedArray();
    mxArray * q = mclGetUninitializedArray();
    mxArray * s = mclGetUninitializedArray();
    mxArray * t = mclGetUninitializedArray();
    mxArray * y = mclGetUninitializedArray();
    mxArray * y_pred = mclGetUninitializedArray();
    mlfAssign(&nargin_, mlfNargin(0, Z, p, V, ALPHA, NULL));
    mclValidateInputs("dar", 4, &Z, &p, &V, &ALPHA);
    mclCopyArray(&Z);
    mclCopyArray(&V);
    mclCopyArray(&ALPHA);
    /*
     * 
     * % function [A,ev,error,gain,sigma_obs,sigma_wu,pvol,state_noise,sigma_wu_q0] = dar(Z,p,V,ALPHA);
     * %
     * %  Dynamic autoregressive model (a type of Kalman filter)
     * %  Its different to RLS in that we have non-zero state noise (W!=0)
     * %  The state noise is set so as to maximise the evidence of the data
     * %  using Jazwinski's algorithm
     * %  The observation noise is fixed at V
     * %
     * %  Z           univariate time series 
     * %  p           order of model
     * %  V           observation noise (default=1.0)
     * %  ALPHA       smoothing coefficient for estimating state noise (default 0.9)
     * %
     * %  A	       estimated model parameters at each time step
     * %  ev          evidence (likelihood) of each data point
     * %  error       prediction error
     * %  gain        kalman gain
     * %  sigma_obs   estimated prediction variance due to noise
     * %  sigma_wu    estimated prediction variance due to weight uncertainty
     * %  pvol        average prior variance of state variables
     * %  state_noise estimated state noise
     * %  sigma_wu_q0 est prediction var due to weight uncert with q=0
     * 
     * if nargin < 2, error('dar needs at least two arguments'); end
     */
    if (mlfTobool(mlfLt(nargin_, mlfScalar(2.0)))) {
        mclAssignAns(
          &ans,
          mlfIndexRef(
            *error, "(?)", mxCreateString("dar needs at least two arguments")));
    }
    /*
     * if nargin < 3 | isempty(V), V=1; end
     */
    {
        mxArray * a_ = mclInitialize(mlfLt(nargin_, mlfScalar(3.0)));
        if (mlfTobool(a_) || mlfTobool(mlfOr(a_, mlfIsempty(V)))) {
            mxDestroyArray(a_);
            mlfAssign(&V, mlfScalar(1.0));
        } else {
            mxDestroyArray(a_);
        }
    }
    /*
     * if nargin < 4 | isempty(ALPHA), ALPHA=0.9; end
     */
    {
        mxArray * a_ = mclInitialize(mlfLt(nargin_, mlfScalar(4.0)));
        if (mlfTobool(a_) || mlfTobool(mlfOr(a_, mlfIsempty(ALPHA)))) {
            mxDestroyArray(a_);
            mlfAssign(&ALPHA, mlfScalar(0.9));
        } else {
            mxDestroyArray(a_);
        }
    }
    /*
     * 
     * Z=Z(:);
     */
    mlfAssign(&Z, mlfIndexRef(Z, "(?)", mlfCreateColonIndex()));
    /*
     * 
     * SEG = p;
     */
    mlfAssign(&SEG, p);
    /*
     * SHIFT = 1;				
     */
    mlfAssign(&SHIFT, mlfScalar(1.0));
    /*
     * 
     * q=0;            % Global state noise parameter
     */
    mlfAssign(&q, mlfScalar(0.0));
    /*
     * W = q*eye(p);   % Initial state noise covariance matrix
     */
    mlfAssign(&W, mlfMtimes(q, mlfEye(p, NULL)));
    /*
     * 
     * y_pred = zeros(size(Z));		
     */
    mlfAssign(&y_pred, mlfZeros(mlfSize(mclValueVarargout(), Z, NULL), NULL));
    /*
     * error  = zeros(size(Z));		
     */
    mlfAssign(error, mlfZeros(mlfSize(mclValueVarargout(), Z, NULL), NULL));
    /*
     * sigma_obs  = V*ones(size(Z));		
     */
    mlfAssign(
      sigma_obs,
      mlfMtimes(V, mlfOnes(mlfSize(mclValueVarargout(), Z, NULL), NULL)));
    /*
     * sigma_wu  = zeros(size(Z));		
     */
    mlfAssign(sigma_wu, mlfZeros(mlfSize(mclValueVarargout(), Z, NULL), NULL));
    /*
     * sigma_wu_q0  = zeros(size(Z));		
     */
    mlfAssign(
      sigma_wu_q0, mlfZeros(mlfSize(mclValueVarargout(), Z, NULL), NULL));
    /*
     * pvol  = zeros(size(Z));		
     */
    mlfAssign(pvol, mlfZeros(mlfSize(mclValueVarargout(), Z, NULL), NULL));
    /*
     * A      = zeros(length(Z),p);		
     */
    mlfAssign(&A, mlfZeros(mlfLength(Z), p, NULL));
    /*
     * N = round(size(Z,1)/SHIFT - SEG/SHIFT);
     */
    mlfAssign(
      &N,
      mlfRound(
        mlfMinus(
          mlfMrdivide(mlfSize(mclValueVarargout(), Z, mlfScalar(1.0)), SHIFT),
          mlfMrdivide(SEG, SHIFT))));
    /*
     * 
     * 
     * % Do linear regression to get initial parameters
     * F = -1*Z(1:SEG);
     */
    mlfAssign(
      &F,
      mlfMtimes(
        mlfScalar(-1.0),
        mlfIndexRef(Z, "(?)", mlfColon(mlfScalar(1.0), SEG, NULL))));
    /*
     * a = pinv(F')*Z(SEG+1);				
     */
    mlfAssign(
      &a,
      mlfMtimes(
        mlfPinv(mlfCtranspose(F), NULL),
        mlfIndexRef(Z, "(?)", mlfPlus(SEG, mlfScalar(1.0)))));
    /*
     * 
     * 
     * % initial covariance for a(0)
     * % (estimated noise is V) 
     * % standard result from linear regression
     * C = V*F*F';
     */
    mlfAssign(&C, mlfMtimes(mlfMtimes(V, F), mlfCtranspose(F)));
    /*
     * %C=eye(p);
     * 
     * h=waitbar(0,'Dynamic autoregressive model');
     */
    mlfAssign(
      &h,
      mlfNWaitbar(
        1, mlfScalar(0.0), mxCreateString("Dynamic autoregressive model")));
    /*
     * 
     * % Set s to start collecting samples of observation noise estimates
     * s=1;
     */
    mlfAssign(&s, mlfScalar(1.0));
    /*
     * for t = 1:N
     */
    for (mclForStart(&iterator_0, mlfScalar(1.0), N, NULL);
         mclForNext(&iterator_0, &t);
         ) {
        /*
         * n = (t-1)*SHIFT + SEG +1;			% one-step predictor
         */
        mlfAssign(
          &n,
          mlfPlus(
            mlfPlus(mlfMtimes(mlfMinus(t, mlfScalar(1.0)), SHIFT), SEG),
            mlfScalar(1.0)));
        /*
         * 
         * D= Z(1+(t-1)*SHIFT:(t-1)*SHIFT + SEG+1,:);
         */
        mlfAssign(
          &D,
          mlfIndexRef(
            Z,
            "(?,?)",
            mlfColon(
              mlfPlus(
                mlfScalar(1.0), mlfMtimes(mlfMinus(t, mlfScalar(1.0)), SHIFT)),
              mlfPlus(
                mlfPlus(mlfMtimes(mlfMinus(t, mlfScalar(1.0)), SHIFT), SEG),
                mlfScalar(1.0)),
              NULL),
            mlfCreateColonIndex()));
        /*
         * 
         * F = -1*D(1:SEG,:);	                        % p-past samples
         */
        mlfAssign(
          &F,
          mlfMtimes(
            mlfScalar(-1.0),
            mlfIndexRef(
              D,
              "(?,?)",
              mlfColon(mlfScalar(1.0), SEG, NULL),
              mlfCreateColonIndex())));
        /*
         * % negative sign
         * % for compatibility with
         * % AR routines
         * 
         * 
         * y = D(SEG+1,:);				% one step predictor
         */
        mlfAssign(
          &y,
          mlfIndexRef(
            D, "(?,?)", mlfPlus(SEG, mlfScalar(1.0)), mlfCreateColonIndex()));
        /*
         * 
         * % Because W=0 and G=I the prior covariance simply
         * % equals the posterior covariance from the last step
         * R = C + W;					% Prior covariance
         */
        mlfAssign(&R, mlfPlus(C, W));
        /*
         * y_pred(n,:) = a'*F;				% make one-step forecast
         */
        mlfIndexAssign(
          &y_pred,
          "(?,?)",
          n,
          mlfCreateColonIndex(),
          mlfMtimes(mlfCtranspose(a), F));
        /*
         * Q = F'*R*F + V;				% covariance of posterior P(Y_t|D_t-1)
         */
        mlfAssign(&Q, mlfPlus(mlfMtimes(mlfMtimes(mlfCtranspose(F), R), F), V));
        /*
         * Qqzero = F'*C*F + V;				% cov of post given q=0
         */
        mlfAssign(
          &Qqzero, mlfPlus(mlfMtimes(mlfMtimes(mlfCtranspose(F), C), F), V));
        /*
         * ev(n,:)=gauss(y_pred(n,:),Q,y);               % evidence (likelihood) 
         */
        mlfIndexAssign(
          ev,
          "(?,?)",
          n,
          mlfCreateColonIndex(),
          mlfGauss(
            mlfIndexRef(y_pred, "(?,?)", n, mlfCreateColonIndex()), Q, y));
        /*
         * % of new data point
         * K = R*F/Q;					% Kalman gain factor
         */
        mlfAssign(&K, mlfMrdivide(mlfMtimes(R, F), Q));
        /*
         * a = a + K*(y-y_pred(n,:))';			% posterior mean of P(a|D_t)
         */
        mlfAssign(
          &a,
          mlfPlus(
            a,
            mlfMtimes(
              K,
              mlfCtranspose(
                mlfMinus(
                  y,
                  mlfIndexRef(y_pred, "(?,?)", n, mlfCreateColonIndex()))))));
        /*
         * 
         * % Get new posterior cov of P(a|D_t)  
         * C = R-K*F'*R;					
         */
        mlfAssign(
          &C, mlfMinus(R, mlfMtimes(mlfMtimes(K, mlfCtranspose(F)), R)));
        /*
         * 
         * e = (y_pred(n,:)-y)'*(y_pred(n,:)-y);		% prediction error 
         */
        mlfAssign(
          &e,
          mlfMtimes(
            mlfCtranspose(
              mlfMinus(
                mlfIndexRef(y_pred, "(?,?)", n, mlfCreateColonIndex()), y)),
            mlfMinus(
              mlfIndexRef(y_pred, "(?,?)", n, mlfCreateColonIndex()), y)));
        /*
         * 
         * if t>1
         */
        if (mlfTobool(mlfGt(t, mlfScalar(1.0)))) {
            /*
             * % dont make any calculations based on initial R values
             * sigma_wu (n) = F'*R*F;                      % pred error due to 
             */
            mlfIndexAssign(
              sigma_wu, "(?)", n, mlfMtimes(mlfMtimes(mlfCtranspose(F), R), F));
            /*
             * % weight uncertainty
             * sigma_wu_q0 (n) = F'*(R-W)*F;               % pred error due to 
             */
            mlfIndexAssign(
              sigma_wu_q0,
              "(?)",
              n,
              mlfMtimes(mlfMtimes(mlfCtranspose(F), mlfMinus(R, W)), F));
            /*
             * % weight uncertainty
             * pvol(n)=(1/p)*trace(R);
             */
            mlfIndexAssign(
              pvol,
              "(?)",
              n,
              mlfMtimes(mlfMrdivide(mlfScalar(1.0), p), mlfTrace(R)));
        /*
         * end
         */
        }
        /*
         * 
         * % Update state noise using smoothed version of Jazwinski's formula
         * new_q=(e-Qqzero)/(F'*F);						
         */
        mlfAssign(
          &new_q,
          mlfMrdivide(mlfMinus(e, Qqzero), mlfMtimes(mlfCtranspose(F), F)));
        /*
         * new_q=new_q*(new_q>0);
         */
        mlfAssign(&new_q, mlfMtimes(new_q, mlfGt(new_q, mlfScalar(0.0))));
        /*
         * q = ALPHA*q + (1-ALPHA)*new_q;;
         */
        mlfAssign(
          &q,
          mlfPlus(
            mlfMtimes(ALPHA, q),
            mlfMtimes(mlfMinus(mlfScalar(1.0), ALPHA), new_q)));
        /*
         * W=q*eye(p);
         */
        mlfAssign(&W, mlfMtimes(q, mlfEye(p, NULL)));
        /*
         * 
         * A(n,:) = a';  
         */
        mlfIndexAssign(&A, "(?,?)", n, mlfCreateColonIndex(), mlfCtranspose(a));
        /*
         * gain(n,:)=K';
         */
        mlfIndexAssign(
          gain, "(?,?)", n, mlfCreateColonIndex(), mlfCtranspose(K));
        /*
         * error(n)=e;
         */
        mlfIndexAssign(error, "(?)", n, e);
        /*
         * state_noise(n)=q;
         */
        mlfIndexAssign(state_noise, "(?)", n, q);
        /*
         * waitbar(t/N);
         */
        mclAssignAns(&ans, mlfNWaitbar(0, mlfMrdivide(t, N), NULL));
    /*
     * end;
     */
    }
    /*
     * 
     * close(h);
     */
    mclAssignAns(&ans, mlfNClose(0, h, NULL));
    /*
     * 
     * % Reverse order of coefficients for compatibility with AR routines
     * A=A(:,p:-1:1);
     */
    mlfAssign(
      &A,
      mlfIndexRef(
        A,
        "(?,?)",
        mlfCreateColonIndex(),
        mlfColon(p, mlfScalar(-1.0), mlfScalar(1.0))));
    mclValidateOutputs(
      "dar",
      9,
      nargout_,
      &A,
      ev,
      error,
      gain,
      sigma_obs,
      sigma_wu,
      pvol,
      state_noise,
      sigma_wu_q0);
    mxDestroyArray(ALPHA);
    mxDestroyArray(C);
    mxDestroyArray(D);
    mxDestroyArray(F);
    mxDestroyArray(K);
    mxDestroyArray(N);
    mxDestroyArray(Q);
    mxDestroyArray(Qqzero);
    mxDestroyArray(R);
    mxDestroyArray(SEG);
    mxDestroyArray(SHIFT);
    mxDestroyArray(V);
    mxDestroyArray(W);
    mxDestroyArray(Z);
    mxDestroyArray(a);
    mxDestroyArray(ans);
    mxDestroyArray(e);
    mxDestroyArray(h);
    mxDestroyArray(n);
    mxDestroyArray(nargin_);
    mxDestroyArray(new_q);
    mxDestroyArray(q);
    mxDestroyArray(s);
    mxDestroyArray(t);
    mxDestroyArray(y);
    mxDestroyArray(y_pred);
    return A;
}

/*
 * The function "mlfDar" contains the normal interface for the "dar" M-function
 * from file "c:\matlabr11\toolbox\hmmbox\dar.m" (lines 1-117). This function
 * processes any input arguments and passes them to the implementation version
 * of the function, appearing above.
 */
mxArray * mlfDar(mxArray * * ev,
                 mxArray * * error,
                 mxArray * * gain,
                 mxArray * * sigma_obs,
                 mxArray * * sigma_wu,
                 mxArray * * pvol,
                 mxArray * * state_noise,
                 mxArray * * sigma_wu_q0,
                 mxArray * Z,
                 mxArray * p,
                 mxArray * V,
                 mxArray * ALPHA) {
    int nargout = 1;
    mxArray * A = mclGetUninitializedArray();
    mxArray * ev__ = mclGetUninitializedArray();
    mxArray * error__ = mclGetUninitializedArray();
    mxArray * gain__ = mclGetUninitializedArray();
    mxArray * sigma_obs__ = mclGetUninitializedArray();
    mxArray * sigma_wu__ = mclGetUninitializedArray();
    mxArray * pvol__ = mclGetUninitializedArray();
    mxArray * state_noise__ = mclGetUninitializedArray();
    mxArray * sigma_wu_q0__ = mclGetUninitializedArray();
    mlfEnterNewContext(
      8,
      4,
      ev,
      error,
      gain,
      sigma_obs,
      sigma_wu,
      pvol,
      state_noise,
      sigma_wu_q0,
      Z,
      p,
      V,
      ALPHA);
    if (ev != NULL) {
        ++nargout;
    }
    if (error != NULL) {
        ++nargout;
    }
    if (gain != NULL) {
        ++nargout;
    }
    if (sigma_obs != NULL) {
        ++nargout;
    }
    if (sigma_wu != NULL) {
        ++nargout;
    }
    if (pvol != NULL) {
        ++nargout;
    }
    if (state_noise != NULL) {
        ++nargout;
    }
    if (sigma_wu_q0 != NULL) {
        ++nargout;
    }
    A
      = Mdar(
          &ev__,
          &error__,
          &gain__,
          &sigma_obs__,
          &sigma_wu__,
          &pvol__,
          &state_noise__,
          &sigma_wu_q0__,
          nargout,
          Z,
          p,
          V,
          ALPHA);
    mlfRestorePreviousContext(
      8,
      4,
      ev,
      error,
      gain,
      sigma_obs,
      sigma_wu,
      pvol,
      state_noise,
      sigma_wu_q0,
      Z,
      p,
      V,
      ALPHA);
    if (ev != NULL) {
        mclCopyOutputArg(ev, ev__);
    } else {
        mxDestroyArray(ev__);
    }
    if (error != NULL) {
        mclCopyOutputArg(error, error__);
    } else {
        mxDestroyArray(error__);
    }
    if (gain != NULL) {
        mclCopyOutputArg(gain, gain__);
    } else {
        mxDestroyArray(gain__);
    }
    if (sigma_obs != NULL) {
        mclCopyOutputArg(sigma_obs, sigma_obs__);
    } else {
        mxDestroyArray(sigma_obs__);
    }
    if (sigma_wu != NULL) {
        mclCopyOutputArg(sigma_wu, sigma_wu__);
    } else {
        mxDestroyArray(sigma_wu__);
    }
    if (pvol != NULL) {
        mclCopyOutputArg(pvol, pvol__);
    } else {
        mxDestroyArray(pvol__);
    }
    if (state_noise != NULL) {
        mclCopyOutputArg(state_noise, state_noise__);
    } else {
        mxDestroyArray(state_noise__);
    }
    if (sigma_wu_q0 != NULL) {
        mclCopyOutputArg(sigma_wu_q0, sigma_wu_q0__);
    } else {
        mxDestroyArray(sigma_wu_q0__);
    }
    return mlfReturnValue(A);
}

/*
 * The function "mlxDar" contains the feval interface for the "dar" M-function
 * from file "c:\matlabr11\toolbox\hmmbox\dar.m" (lines 1-117). The feval
 * function calls the implementation version of dar through this function. This
 * function processes any input arguments and passes them to the implementation
 * version of the function, appearing above.
 */
void mlxDar(int nlhs, mxArray * plhs[], int nrhs, mxArray * prhs[]) {
    mxArray * mprhs[4];
    mxArray * mplhs[9];
    int i;
    if (nlhs > 9) {
        mlfError(
          mxCreateString(
            "Run-time Error: File: dar Line: 1 Column: 0 The function \"dar\""
            " was called with more than the declared number of outputs (9)"));
    }
    if (nrhs > 4) {
        mlfError(
          mxCreateString(
            "Run-time Error: File: dar Line: 1 Column: 0 The function \"dar\""
            " was called with more than the declared number of inputs (4)"));
    }
    for (i = 0; i < 9; ++i) {
        mplhs[i] = NULL;
    }
    for (i = 0; i < 4 && i < nrhs; ++i) {
        mprhs[i] = prhs[i];
    }
    for (; i < 4; ++i) {
        mprhs[i] = NULL;
    }
    mlfEnterNewContext(0, 4, mprhs[0], mprhs[1], mprhs[2], mprhs[3]);
    mplhs[0]
      = Mdar(
          &mplhs[1],
          &mplhs[2],
          &mplhs[3],
          &mplhs[4],
          &mplhs[5],
          &mplhs[6],
          &mplhs[7],
          &mplhs[8],
          nlhs,
          mprhs[0],
          mprhs[1],
          mprhs[2],
          mprhs[3]);
    mlfRestorePreviousContext(0, 4, mprhs[0], mprhs[1], mprhs[2], mprhs[3]);
    plhs[0] = mplhs[0];
    for (i = 1; i < 9 && i < nlhs; ++i) {
        plhs[i] = mplhs[i];
    }
    for (; i < 9; ++i) {
        mxDestroyArray(mplhs[i]);
    }
}
