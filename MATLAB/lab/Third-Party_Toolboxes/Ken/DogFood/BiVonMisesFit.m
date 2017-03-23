% [frac, mu, k, p] = BiVonMisesFit(th, nBoot)
%
% fits a "three parameter" family bimodal von mises distribution (Fisher p.99]
% it's a mixture distribution with probability frac to be VonM(mu,k) and (1-frac) to be VonM(mu+pi,k)
%
% th must be a vector
%
% if fourth output is specified, a parametric bootstrap test is used to compute
% the p value of the null hypothesis of unimodality. nBoot is #repetitions
% (default 200)

function [frac, mu, k, p] = BiVonMisesFit(th, nBoot)

if nargin<2; nBoot = 200; end
    

th = th(:);
n = length(th);

% (4.62) - (4.64)
C1 = mean(cos(th));
S1 = mean(sin(th));
C2 = mean(cos(2*th));
S2 = mean(sin(2*th));
R2 = sqrt(C2.^2 + S2.^2);

% (4.65) - (4.67)
mu2 = atan2(S2, C2);
mu = mu2/2;
% keyboard
[kmm dummy flag] = fzero(sprintf('besseli(2,x)/besseli(0,x) - %f', R2), 1);
if flag<0
    warning('Could not solve for k');
    frac = 0; mu=0; k=0; p=1;
    return
end
kmm = abs(kmm) ; % is case it found a negative branch
A1 = besseli(1,kmm)/besseli(0,kmm);
frac = (1 + (C1*cos(mu) + S1*sin(mu)) / A1)/2;

% sanity check
if frac>1; frac=1; end
if frac<0; frac=0; end

% (4.41)

if n<=15
    if kmm<2
        k = max(kmm-2/(n*kmm),0);
    else
        k = (n-1)^3*kmm/(n^3+n);
    end
else
    k = kmm;
end    

if nargout>=4
    
    % log likelihood under bimodal assumption
    pBimodal = frac*VonMisesPdf(th,mu,k) + (1-frac)*VonMisesPdf(th,mu+pi,k);
    l = sum(log(pBimodal));
    
    % fit unimodal Von Mises
    [ru ku] = VonMisesFit(th);
    
    % parametric bootstrap
    for b=1:nBoot
        % simulate data according to unimodal hypothesis
        thb = VonMisesRnd(ru,ku,n,1);
        % estimate bimodal fit to simulated unimodal data
        [fracb mub kb] = BiVonMisesFit(thb);
        
        % compute log likelihood 
        pBimodalb = fracb*VonMisesPdf(thb,mub,kb) + (1-fracb)*VonMisesPdf(thb,mub+pi,kb);
        lb(b) = sum(log(pBimodalb));
    end
    
    p = 1-Quantile(lb,l);
%     keyboard
end
        
        