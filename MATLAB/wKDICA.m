function [icasig, A, W, J]=wKDICA(x,ncomp,isn,factoranred,minm,varargin)
% [icasig, A, W]=wKDICA(x,ncomp,isn,varargin)
% ICA Model -  x=As, where s have independent components, A is called mixing matrix;
% KDICA :    prewhitened version of semiparametric profile MLE methods for ICA models
%            with fast kernel density estimation;
%              Returns an unmixing matrix W such that s=W*x 's components are as close
%                 as possible to mutually independence;
%	       It first whitens the data and then minimizes
%                 the given contrast function over orthogonal matrices.
% x          : observed mixtures, dim * samplesize;
% ncomp      : number of components.
% isn        : whether using natural greaadient. default: true.
% W0         : unmixing matric initialization
%
% Version 1.0, CopyRight: Aiyou Chen
% Jan. 2004 in UC Village at Albany, CA
%
% Acknowledgement:
% Some optimization subroutines such as Gold_Search(), Bracket_IN() were written
%   by Francis Bach for "Kernel Independent Component Analysis" (JMLR02)
%
% Contact: aychen@research.bell-labs.com
%
% I add demention reduction step, but I didn't whithen it... because they
% claim their whiten methods later should be better. YY
verbose=0;
if (nargin<3 || isempty(isn)); isn=true;end
if (nargin<4 || isempty(factoranred));factoranred=1;end

% data dimension
[m,N]=size(x);
if isempty(ncomp)
    ncomp=m;
end
% first centers and scales data
if (verbose), fprintf('\nStart KDICA \nwhiten ...\n'); end
mx=mean(x,2);
xc=x-repmat(mx,1,N);  % centers data
%% dimention reduction
if factoranred && (m>6)
    % reduce dimention using factor analysis
    mm=m-1;
    if (nargin<5 || isempty(minm))
    if m<10
        m=1;
    else
    m=4;
    end
    else
        m=minm;
    end
    [lambda,psi,T,stats]=factoran(xc',m);
    bic=-2*stats.loglike+m*log(N);
    obic=bic+10^-4;
    while (bic<obic)&&(m<mm)
        m=m+1;
        obic=bic;
        [~,~,~,stats]=factoran(xc',m);
        bic=-2*stats.loglike+m*log(N);
    end
    m=m-1;
    [lambda,psi,T,stats,xc]=factoran(xc',m);
    xc=xc';
    %
    %  if (verbose), fprintf('unmixing ...\ndone\n\n'); end
    
    % initial uses JADE
    if (length(varargin)<=1),
        if 1,
            A0=jade(xc);
        else
            A0=randn(m);
        end
        [U,S,V]=svd(A0);
        W0=V*U';
    end
    
    % optional values
    if (rem(length(varargin),2)==1)
        error('Optional parameters should always go by pairs');
    else
        for i=1:2:(length(varargin)-1)
            switch varargin{i}
                case 'W0'
                    W0= varargin{i+1};
                    W0=W0*u(:,temp_c);
                    [U,S,V]=svd(W0*sqcovmat);
                    W0=U*V';
            end
        end
    end
    
    [J,W]=localopt(xc,W0,isn);
    
    icasig=W*xc;
    fprintf('...%d cmps',m)
    A=lambda/W;
    W=W*pinv(lambda);
else
firstred=1;
if firstred 
    
    % reduce dimention.
    [u,v,~]=svd(cov(xc'));
    if length(ncomp)<2
        if ncomp>1
            temp_c=1:ncomp;
        else
            temp_c=1:find(diag(v)'*triu(ones(m))/trace(v)>ncomp,1,'first');
        end
    else
        temp_c=ncomp;
    end
    xc=(u(:,temp_c)/sqrt(v(temp_c,temp_c)))'*xc;
%     covmat=(xc*xc')/N;
%     
%     sqcovmat=sqrtm(covmat);
%     invsqcovmat=eye(size(sqcovmat))/(sqcovmat);
%     xc=invsqcovmat*xc;           % scales data
    %
    %  if (verbose), fprintf('unmixing ...\ndone\n\n'); end
    
    % initial uses JADE
    if (length(varargin)<=1),
        if 1,
            A0=jade(xc);
        else
            A0=randn(m);
        end
        [U,S,V]=svd(A0);
        W0=V*U';
    end
    
    % optional values
    if (rem(length(varargin),2)==1)
        error('Optional parameters should always go by pairs');
    else
        for i=1:2:(length(varargin)-1)
            switch varargin{i}
                case 'W0'
                    W0= varargin{i+1};
                    [U,S,V]=svd(W0);
                    W0=U*V(1:size(U,1),1:size(U,2))';
            end
        end
    end
%     try
    [J,W]=localopt(xc,W0,isn);
%     catch
%         mm
%     end
    
    icasig=W*xc;
    fprintf('...%d cmps',size(W,1))
    A=(u(:,temp_c)*sqrt(v(temp_c,temp_c))/W);%(W*invsqcovmat));
    W=W*(u(:,temp_c)/sqrt(v(temp_c,temp_c)))';
else
    covmat=(xc*xc')/N;
    
    sqcovmat=sqrtm(covmat);
    invsqcovmat=eye(size(sqcovmat))/(sqcovmat);
    xc=invsqcovmat*xc;           % scales data
    
    % reduce dimention.
    [u,v,~]=svd(cov(xc'));
    if length(ncomp)<2
        if ncomp>1
            temp_c=1:ncomp;
        else
            temp_c=1:find(diag(v)'*triu(ones(m))/trace(v)>ncomp,1,'first');
        end
    else
        temp_c=ncomp;
    end
    xc=u(:,temp_c)'*xc;
    %  if (verbose), fprintf('unmixing ...\ndone\n\n'); end
    
    % initial uses JADE
    if (length(varargin)<=1),
        if 1,
            A0=jade(xc);
        else
            A0=randn(m);
        end
        [U,S,V]=svd(A0);
        W0=V*U';
    end
    
    % optional values
    if (rem(length(varargin),2)==1)
        error('Optional parameters should always go by pairs');
    else
        for i=1:2:(length(varargin)-1)
            switch varargin{i}
                case 'W0'
                    W0= varargin{i+1};
                    W0=W0*u(:,temp_c);
                    [U,S,V]=svd(W0*sqcovmat);
                    W0=U*V';
            end
        end
    end
    
    [J,W]=localopt(xc,W0,isn);
    
    icasig=W*xc;
    fprintf('...%d cmps',size(W,1))
    A=invsqcovmat\(u(:,temp_c)/(W));
    W=W*u(:,temp_c)'*invsqcovmat;
end
end
icasig=bsxfun(@plus,icasig,W*mx);
% normalize each row of W
%for i=1:m
%     W(i,:)=W(i,:)/norm(W(i,:));
%end
return;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function grad=gradcklica(X,W,isn);
% calculate gradient of the negative log profile likelihood function

grad=W;
for i=1:size(grad,1),
    grad(i,:)=gradordkde(X,W(i,:)*X)';
end
grad=grad-inv(W');
if isn
    grad=grad*(W'*W);
end
return;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function z=cklica(s);

% Negative log profile likelihood function using Laplacian Kernel Density Estimates

z=0; m=size(s,1);
for i=1:m,
    z=z-ordkde(sort(s(i,:)));
end
return;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [Jopt,Wopt] = localopt(x,W,isn)
% LOCAL-OPT  -  Conjugate gradient method for finding a minima in the
%               Stiefel manifold of orthogonal matrices Wopt such
%               that Wopt*x are the independent sources.
% x          - data (whitened mixtures);
% W          - orthogonal matric, starting point of the search;
% tolW    :    precision in amari distance in est. demixing matrix;
% tolJ    :    precision in objective function;
% maxit   :    maximum number of iterations;
% verbose :    1 if verbose required.

% initializations

m=size(W,1);
N=size(x,2);
tolW=1e-2;
tolJ=0.01; % linear form in 1/(N*m)
maxit=10*m;

verbose=0;
tmin=1;
iter = 0;
errW = tolW*2;
errJ = tolJ*2;
fret = cklica(W*x);
totalneval=1;
transgradJ=0;
k=0;

% starting minimization
while (((errW > tolW)|(errJ > tolJ)) & (iter < maxit)  )
    Jold=fret;
    iter=iter+1;
    if (verbose), fprintf('iter %d, J=%.5e',iter,fret); end
    
    % calculate derivative
    gradJ=gradcklica(x,W,isn);
    iterneval=1;
    normgradJ=sqrt(.5*trace(gradJ'*gradJ));
    
    dirSearch=gradJ-W*gradJ'*W;
    normdirSearch=sqrt(.5*trace(dirSearch'*dirSearch));
    
    % bracketing the minimum along the geodesic and performs golden search
    [ ax, bx, cx,fax,fbx,fcx,neval] = bracket_min(W,dirSearch,x,0,tmin,Jold);
    iterneval=iterneval+neval;
    goldTol=max(abs([tolW/normdirSearch, mean([ ax, bx, cx])/10]));
    [tmin, Jmin,neval] = golden_search(W,dirSearch,x,ax, bx, cx,goldTol,20);
    iterneval=iterneval+neval;
    oldtransgradJ=transgradJ;
    Wnew=stiefel_geod(W',dirSearch',tmin);
    oldnormgradJ=sqrt(.5*trace(gradJ'*gradJ));
    
    errW=amari(W,Wnew);
    errJ=Jold/Jmin-1;
    totalneval=totalneval+iterneval;
    if (verbose)
        fprintf(', dJ= %.1e',errJ);
        fprintf(',errW=%.1e,dW= %.3f, neval=%d\n',errW,tmin*normdirSearch,iterneval);
    end
    
    if (errJ>0)
        W=Wnew;
        fret=Jmin;
    else
        errJ=0; errW=0;
    end
    
end

Jopt= fret;
Wopt=W;

fprintf('iteration times=%d, contrast function evaluation times=%d\n',iter,totalneval);
return;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [Wt,Ht]=stiefel_geod(W,H,t)

% STIEFEL_GEOD - parameterizes a geodesic along a Stiefel manifold

% W  - origin of the geodesic
% H  - tangent vector
% Ht - tangent vector at "arrival"
% Alan Edelman, Tomas Arias, Steven Smith (1999)

if nargin <3, t=1; end
A=W'*H; A=(A-A')/2;
MN=expm(t*A);
Wt=W*MN;
if nargout > 1, Ht=H*MN; end
Wt=Wt';
return;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [xmin,fmin,neval] = golden_search(W,dirT,x,ax,bx,cx,tol,maxiter)

% GOLDEN_SEARCH - Minimize contrast function along a geodesic of the Stiefel
%                 manifold using golden section search.
% W              - initial value
% x              - mixed components
% dirT           - direction of the geodesic
% ax,bx,cx       - three abcissas such that the minimum is bracketed between ax and cx,
%                  as given by bracket_mini.m
% tol            - relative accuracy of the search
% maxit          - maximum number of iterations
% neval          - outputs the number of evaluation of the contrast function

neval=0;
% golden ratios
C = (3-sqrt(5))/2;
R = 1-C;

x0 = ax;
x3 = cx;

% gets the smaller segment
if (abs(cx-bx) > abs(bx-ax)),
    x1 = bx;
    x2 = bx + C*(cx-bx);
else
    x2 = bx;
    x1 = bx - C*(bx-ax);
end

Wtemp=stiefel_geod(W',dirT',x1);
f1=cklica(Wtemp*x);
Wtemp=stiefel_geod(W',dirT',x2);
f2=cklica(Wtemp*x);

neval=neval+2;
k = 1;

% starts iterations
while ((abs(x3-x0) > tol) & (k<maxiter)),
    if f2 < f1,
        x0 = x1;
        x1 = x2;
        x2 = R*x1 + C*x3;
        f1 = f2;
        Wtemp=stiefel_geod(W',dirT',x2);
        f2=cklica(Wtemp*x);
        neval=neval+1;
    else
        x3 = x2;
        x2 = x1;
        x1 = R*x2 + C*x0;
        f2 = f1;
        Wtemp=stiefel_geod(W',dirT',x1);
        f1=cklica(Wtemp*x);
        neval=neval+1;
    end
    k = k+1;
end

% best of the two possible
if f1 < f2,
    xmin = x1;
    fmin = f1;
else
    xmin = x2;
    fmin = f2;
end

return;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [ ax, bx, cx,fax,fbx,fcx,neval] = bracket_min(W,dirT,x,ax, bx,fax)

% BRACKET_MIN - Brackets a minimum by searching in both directions along a geodesic in
%               the Stiefel manifold
% W              - initial value
% x              - mixed components
% dirT           - direction of the geodesic
% ax,bx          - Initial guesses
% tol            - relative accuracy of the search
% maxit          - maximum number of iterations
% neval          - outputs the number of evaluation of the contrast function

neval=0;
GOLD=1.618034;
TINY=1e-10;
GLIMIT=100;
Wtemp=stiefel_geod(W',dirT',bx);
fbx=cklica(Wtemp*x);

neval=neval+1;

if (fbx > fax)
    temp=ax;
    ax=bx;
    bx=temp;
    temp=fax;
    fax=fbx;
    fbx=temp;
end

cx=(bx)+GOLD*(bx-ax);
Wtemp=stiefel_geod(W',dirT',cx);
fcx=cklica(Wtemp*x);

neval=neval+1;

while (fbx > fcx)
    
    r=(bx-ax)*(fbx-fcx);
    q=(bx-cx)*(fbx-fax);
    u=(bx)-((bx-cx)*q-(bx-ax)*r)/(2.0*max([abs(q-r),TINY])*sign(q-r));
    ulim=(bx)+GLIMIT*(cx-bx);
    if ((bx-u)*(u-cx) > 0.0)
        Wtemp=stiefel_geod(W',dirT',u);
        fux=cklica(Wtemp*x);
        
        neval=neval+1;
        
        if (fux < fcx)
            ax=(bx);
            bx=u;
            fax=(fbx);
            fbx=fux;
            return;
        else
            if (fux > fbx)
                cx=u;
                fcx=fux;
                return;
            end
        end
        
        u=(cx)+GOLD*(cx-bx);
        Wtemp=stiefel_geod(W',dirT',u);
        fux=cklica(Wtemp*x);
        neval=neval+1;
        
    else
        if ((cx-u)*(u-ulim) > 0.0)
            Wtemp=stiefel_geod(W',dirT',u);
            fux=cklica(Wtemp*x);
            neval=neval+1;
            
            if (fux < fcx)
                bx=cx;
                cx=u;
                u=cx+GOLD*(cx-bx);
                
                fbx=fcx;
                fcx=fux;
                Wtemp=stiefel_geod(W',dirT',u);
                fux=cklica(Wtemp*x);
                neval=neval+1;
            end
        else
            if ((u-ulim)*(ulim-cx) >= 0.0)
                
                u=ulim;
                Wtemp=stiefel_geod(W',dirT',u);
                fux=cklica(Wtemp*x);
                neval=neval+1;
                
            else
                u=(cx)+GOLD*(cx-bx);
                Wtemp=stiefel_geod(W',dirT',u);
                fux=cklica(Wtemp*x);
                neval=neval+1;
                
            end
        end
    end
    
    ax=bx;
    bx=cx;
    cx=u;
    
    fax=fbx;
    fbx=fcx;
    fcx=fux;
    
end
return;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Reference:
%   Fast Kernel Density Independent Component Analysis,
%      Volume 3889 of Lecture Notes in Computer Sciences, Springer, 2006;
%      6th International Conference on ICA & BSS, 2006, Charleston, SC, USA.
%
%   Chapter 4 of Efficient Independent Component Analysis (2004), Ph.D Thesis,
%      by Aiyou Chen, Advisor: Peter J. Bickel, Department of Statistics, UC Berkeley


% Revision history
% Aug 27, 2006:
%  1. update gradient calculation (replace previous finite difference approximation)
%  2. remove multiple restartings (most time Cardoso's JADE initials well)
%  3. test ordkde.c (matlab 6.5 can do cumsum iteration as well,but c is 1/3 faster)


%% here is jade...
function [A,S]=jade(X,m)
% Source separation of complex signals with JADE.
% Jade performs `Source Separation' in the following sense:
%   X is an n x T data matrix assumed modelled as X = A S + N where
%
% o A is an unknown n x m matrix with full rank.
% o S is a m x T data matrix (source signals) with the properties
%    	a) for each t, the components of S(:,t) are statistically
%    	   independent
% 	b) for each p, the S(p,:) is the realization of a zero-mean
% 	   `source signal'.
% 	c) At most one of these processes has a vanishing 4th-order
% 	   cumulant.
% o  N is a n x T matrix. It is a realization of a spatially white
%    Gaussian noise, i.e. Cov(X) = sigma*eye(n) with unknown variance
%    sigma.  This is probably better than no modeling at all...
%
% Jade performs source separation via a
% Joint Approximate Diagonalization of Eigen-matrices.
%
% THIS VERSION ASSUMES ZERO-MEAN SIGNALS
%
% Input :
%   * X: Each column of X is a sample from the n sensors
%   * m: m is an optional argument for the number of sources.
%     If ommited, JADE assumes as many sources as sensors.
%
% Output :
%    * A is an n x m estimate of the mixing matrix
%    * S is an m x T naive (ie pinv(A)*X)  estimate of the source signals
%
%
% Version 1.5.  Copyright: JF Cardoso.
%
% See notes, references and revision history at the bottom of this file



[n,T]	= size(X);

%%  source detection not implemented yet !
if nargin==1, m=n ; end;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% A few parameters that could be adjusted
nem	= m;		% number of eigen-matrices to be diagonalized
seuil	= 1/sqrt(T)/100;% a statistical threshold for stopping joint diag


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% whitening
%
if m<n, %assumes white noise
    [U,D] 	= eig((X*X')/T);
    [puiss,k]=sort(diag(D));
    ibl 	= sqrt(puiss(n-m+1:n)-mean(puiss(1:n-m)));
    bl 	= ones(m,1) ./ ibl ;
    W	= diag(bl)*U(1:n,k(n-m+1:n))';
    IW 	= U(1:n,k(n-m+1:n))*diag(ibl);
else    %assumes no noise
    IW 	= sqrtm((X*X')/T);
    W	= inv(IW);
end;
Y	= W*X;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Cumulant estimation


R	= (Y*Y' )/T ;
C	= (Y*Y.')/T ;

Yl	= zeros(1,T);
Ykl	= zeros(1,T);
Yjkl	= zeros(1,T);

Q	= zeros(m*m*m*m,1) ;
index	= 1;

for lx = 1:m ; Yl 	= Y(lx,:);
    for kx = 1:m ; Ykl 	= Yl.*conj(Y(kx,:));
        for jx = 1:m ; Yjkl	= Ykl.*conj(Y(jx,:));
            for ix = 1:m ;
                Q(index) = ...
                    (Yjkl * Y(ix,:).')/T -  R(ix,jx)*R(lx,kx) -  R(ix,kx)*R(lx,jx) -  C(ix,lx)*conj(C(jx,kx))  ;
                index	= index + 1 ;
            end ;
        end ;
    end ;
end

%% If you prefer to use more memory and less CPU, you may prefer this
%% code (due to J. Galy of ENSICA) for the estimation the cumulants
%ones_m = ones(m,1) ;
%T1 	= kron(ones_m,Y);
%T2 	= kron(Y,ones_m);
%TT 	= (T1.* conj(T2)) ;
%TS 	= (T1 * T2.')/T ;
%R 	= (Y*Y')/T  ;
%Q	= (TT*TT')/T - kron(R,ones(m)).*kron(ones(m),conj(R)) - R(:)*R(:)' - TS.*TS' ;



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%computation and reshaping of the significant eigen matrices

[U,D]	= eig(reshape(Q,m*m,m*m));
[la,K]	= sort(abs(diag(D)));

%% reshaping the most (there are `nem' of them) significant eigenmatrice
M	= zeros(m,nem*m);	% array to hold the significant eigen-matrices
Z	= zeros(m)	; % buffer
h	= m*m;
for u=1:m:nem*m,
    Z(:) 		= U(:,K(h));
    M(:,u:u+m-1)	= la(h)*Z;
    h		= h-1;
end;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% joint approximate diagonalization of the eigen-matrices


%% Better declare the variables used in the loop :
B 	= [ 1 0 0 ; 0 1 1 ; 0 -i i ] ;
Bt	= B' ;
Ip	= zeros(1,nem) ;
Iq	= zeros(1,nem) ;
g	= zeros(3,nem) ;
G	= zeros(2,2) ;
vcp	= zeros(3,3);
D	= zeros(3,3);
la	= zeros(3,1);
K	= zeros(3,3);
angles	= zeros(3,1);
pair	= zeros(1,2);
c	= 0 ;
s	= 0 ;


%init;
encore	= 1;
V	= eye(m);

% Main loop
while encore, encore=0;
    for p=1:m-1,
        for q=p+1:m,
            
            Ip = p:m:nem*m ;
            Iq = q:m:nem*m ;
            
            % Computing the Givens angles
            g	= [ M(p,Ip)-M(q,Iq)  ; M(p,Iq) ; M(q,Ip) ] ;
            [vcp,D] = eig(real(B*(g*g')*Bt));
            [la, K]	= sort(diag(D));
            angles	= vcp(:,K(3));
            if angles(1)<0 , angles= -angles ; end ;
            c	= sqrt(0.5+angles(1)/2);
            s	= 0.5*(angles(2)-j*angles(3))/c;
            
            if abs(s)>seuil, %%% updates matrices M and V by a Givens rotation
                encore 		= 1 ;
                pair 		= [p;q] ;
                G 		= [ c -conj(s) ; s c ] ;
                V(:,pair) 	= V(:,pair)*G ;
                M(pair,:)	= G' * M(pair,:) ;
                M(:,[Ip Iq]) 	= [ c*M(:,Ip)+s*M(:,Iq) -conj(s)*M(:,Ip)+c*M(:,Iq) ] ;
            end%% if
        end%% q loop
    end%% p loop
end%% while

%%%estimation of the mixing matrix and signal separation
A	= IW*V;
S	= V'*Y ;

return ;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Note 1: This version does *not* assume circularly distributed
% signals as 1.1 did.  The difference only entails more computations
% in estimating the cumulants
%
%
% Note 2: This code tries to minimize the work load by jointly
% diagonalizing only the m most significant eigenmatrices of the
% cumulant tensor.  When the model holds, this avoids the
% diagonalization of m^2 matrices.  However, when the model does not
% hold, there is in general more than m significant eigen-matrices.
% In this case, this code still `works' but is no longer equivalent to
% the minimization of a well defined contrast function: this would
% require the diagonalization of *all* the eigen-matrices.  We note
% (see the companion paper) that diagonalizing **all** the
% eigen-matrices is strictly equivalent to diagonalize all the
% `parallel cumulants slices'.  In other words, when the model does
% not hold, it could be a good idea to diagonalize all the parallel
% cumulant slices.  The joint diagonalization will require about m
% times more operations, but on the other hand, computation of the
% eigen-matrices is avoided.  Such an approach makes sense when
% dealing with a relatively small number of sources (say smaller than
% 10).
%
%
% Revision history
%-----------------
%
% Version 1.5 (Nov. 2, 97) :
% o Added the option kindly provided by Jerome Galy
%   (galy@dirac.ensica.fr) to compute the sample cumulant tensor.
%   This option uses more memory but is faster (a similar piece of
%   code was also passed to me by Sandip Bose).
% o Suppressed the useles variable `oui'.
% o Changed (angles=sign(angles(1))*angles) to (if angles(1)<0 ,
%   angles= -angles ; end ;) as suggested by Iain Collings
%   <i.collings@ee.mu.OZ.AU>.  This is safer (with probability 0 in
%   the case of sample statistics)
% o Cosmetic rewriting of the doc.  Fixed some typos and added new
%   ones.
%
% Version 1.4 (Oct. 9, 97) : Changed the code for estimating
% cumulants. The new version loops thru the sensor indices rather than
% looping thru the time index.  This is much faster for large sample
% sizes.  Also did some clean up.  One can now change the number of
% eigen-matrices to be jointly diagonalized by just changing the
% variable `nem'.  It is still hard coded below to be equal to the
% number of sources.  This is more economical and OK when the model
% holds but not appropriate when the model does not hold (in which
% case, the algorithm is no longer asymptotically equivalent to
% minimizing a contrast function, unless nem is the square of the
% number of sources.)
%
% Version 1.3 (Oct. 6, 97) : Added various Matalb tricks to speed up
% things a bit.  This is not very rewarding though, because the main
% computational burden still is in estimating the 4th-order moments.
%
% Version 1.2 (Mar., Apr., Sept. 97) : Corrected some mistakes **in
% the comments !!**, Added note 2 `When the model does not hold' and
% the EUSIPCO reference.
%
% Version 1.1 (Feb. 94): Creation
%
%-------------------------------------------------------------------
%
% Contact JF Cardoso for any comment bug report,and UPDATED VERSIONS.
% email : cardoso@sig.enst.fr
% or check the WEB page http://sig.enst.fr/~cardoso/stuff.html
%
% Reference:
%  @article{CS_iee_94,
%   author = "Jean-Fran\c{c}ois Cardoso and Antoine Souloumiac",
%   journal = "IEE Proceedings-F",
%   title = "Blind beamforming for non {G}aussian signals",
%   number = "6",
%   volume = "140",
%   month = dec,
%   pages = {362-370},
%   year = "1993"}
%
%
%  Some analytical insights into the asymptotic performance of JADE are in
% @inproceedings{PerfEusipco94,
%  HTML 	= "ftp://sig.enst.fr/pub/jfc/Papers/eusipco94_perf.ps.gz",
%  author       = "Jean-Fran\c{c}ois Cardoso",
%  address      = {Edinburgh},
%  booktitle    = "{Proc. EUSIPCO}",
%  month 	= sep,
%  pages 	= "776--779",
%  title 	= "On the performance of orthogonal source separation algorithms",
%  year 	= 1994}
%_________________________________________________________________________
% jade.m ends here
end