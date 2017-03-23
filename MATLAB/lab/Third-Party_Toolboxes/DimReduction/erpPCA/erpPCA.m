% erpPCA - Unrestricted, unstandardized covariance-based PCA with Varimax rota-
%          tion (cf. Kayser J, Tenke CE, Clin Neurophysiol, 2003, 114:2307-25)
%
% Usage: [LU, LR, FSr, VT] = erpPCA( X )
%
% Generic PCA-Varimax implementation emulating the PCA agorithms used by 
% BMDP-4M (Dixon, 1992) and SPSS 10.0 FACTOR (http://www.spss.com/tech/
% stat/Algorithms/11.5/factor.pdf). It expects a data matrix (X) of ERP 
% waveforms, with ERPs (cases) as rows and sample points (variables) as 
% columns. The routine returns the unrotated (LU) and Varimax-rotated (LR) 
% factor loadings as a variables-by-factors matrix, the rotated factor 
% scores (FSr) as a cases-by-factors matrix, and Eigenvalues and explained 
% variance as a variables-by-variance matrix (VT), with four columns 
% consisting of Eigenvalues and percentage of explained variance before 
% and after rotation.
%
% erpPCA employs Varimax4M (max. 100 iterations, 0.0001 convergence criterion,
% Kaiser's normalization; MatLab code by $jk available on request), which 
% emulates algorithms described by Harman (1967, pp. 304-308) as implemented 
% in BMDP-4M (Dixon, 1992, pp. 602-603).
%
% Copyright (C) 2003 by J�rgen Kayser (Email: kayserj@pi.cpmc.columbia.edu)
% GNU General Public License (http://www.gnu.org/licenses/gpl.txt)
% Updated: $Date: 2003/07/08 14:00:00 $ $Author: jk $
%
function [LU,LR,FSr,VT] = erpPCA(X)
[cases, vars] = size(X);             % get dimensions of input data matrix     1
D = cov(X);                          % compute covariance matrix               2
[EM, EV] = eig(D);                   % determine Eigenvectors and Eigenvalues  3
UL = EM * sqrt(EV);                  % determine unrotated factor loadings     4
[u, ux] = sort(diag(EV)');           % sort initial Eigenvalues, keep indices  5
u = fliplr(u); ux = fliplr(ux);      % set descending order                    6
LU = UL(:,ux);                       % sort unrotated factor loadings          7
rk = rank(corrcoef(X),1e-4);         % estimate the number of singular values  8
LU = LU(:,1:rk);                     % ... and remove all linearly dependent   9
u = u(1:rk); ux = ux(1:rk);          % ... components and their indices       10
s = ones(1,rk);                      % current sign of loading vectors        11
s(abs(max(LU)) < abs(min(LU))) = -1; % determine direction of loading vectors 12
LU = LU .* repmat(s,size(LU,1),1);   % redirect loading vectors if necessary  13
RL = Varimax4M(LU,100,1e-2,1);       % Varimax-rotate factor loadings         14
EVr = sum(RL .* RL);                 % compute rotated Eigenvalues            15
[r, rx] = sort(EVr);                 % sort rotated Eigenvalues, keep indices 16
r = fliplr(r); rx = fliplr(rx);      % set descending order                   17
LR = RL(:,rx);                       % sort rotated factor loadings           18
s = ones(1,size(LR,2));              % current sign of loading vectors        19
s(abs(max(LR)) < abs(min(LR))) = -1; % determine direction of loading vectors 20
LR = LR .* repmat(s,vars,1);         % redirect loading vectors if necessary  21
tv = trace(EV);                      % compute total variance                 22
VT = [u' 100*u'/tv ...               % table explained variance for unrotated 23
      r' 100*r'/tv ];                % ... and Varimax-rotated components     24
FSCFr = LR * inv(LR' * LR);          % compute rotated FS coefficients        25
FSCFr = FSCFr .* ...                 % rescale rotated FS coefficients by     26
   repmat(sqrt(diag(D)),1,rk);       % ... the corresponding SDs              27
mu = mean(X); sigma = std(X);        % compute Mean and SD for each variable  28
Xc = X - repmat(mu,cases,1);         % remove grand mean                      29
FSr = zeros(cases,vars);             % claim memory to speed computations     30
for n = 1:cases; for m = 1:rk;       % compute rotated factor scores from     31
 FSr(n,m) = sum( (Xc(n,:) ./ ...     % ... the normalized raw data and        32
       sigma) .* FSCFr(:,m)' );      % ... the corresponding rescaled         33
end; end;                            % ... factor score coefficients          34