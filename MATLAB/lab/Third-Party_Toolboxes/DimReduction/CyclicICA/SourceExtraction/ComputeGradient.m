function [grad] = ComputeGradient(g,y,FreqCycl)
%
% [grad] = ComputeGradient(g,y)
%
% This function compute the gradient of the 
% Shalvi Weinstein cost function at point g.
%
% Author : Pierre JALLON
% Date of creation : 04/23/2005
% Date of last modification : 04/23/20005
%

r = ComputeSignal(g,y);

% Number of observations :
L = size(g,1);

% Filter length : 
N = size(g,2);

J = ComputeCritere(r,FreqCycl);
Den = mean(abs(r).^2).^2;

% Computing the gradient :
for (iN = 1:N)
    for (iL = 1:L)
        
        rbis = r(iL:length(r));
        Longueurrbis = length(rbis);
        ybis = y(iN,1:Longueurrbis);
        derivee_variance = rbis.*conj(ybis);     
        asymetrique_derivee_variance = conj(rbis).*conj(ybis);     
        
        dDen = 2*(mean(abs(r).^2))*mean(derivee_variance);
        
        % Cyclic correlation coefficient free terms:
        dNum =  2*mean(abs(rbis).^2.*derivee_variance) - 2*mean(r.^2)*mean(asymetrique_derivee_variance);
        
        % Derivative of Cyclic correlation coefficient:
        if (length(FreqCycl)>0)
            for (iC=1:length(FreqCycl));
                Exp(iC,:) = exp(-2*i*pi*FreqCycl(iC)*(1:length(r)));
            end
            ConjExp = conj(Exp);
            CCyclicCorrelationCoeff = 1/length(r)*abs(r).^2*(Exp.');
            ConjCCyclicCorrelationCoeff = 1/length(r)*abs(r).^2*(ConjExp.');

            dCCyclicCorrelationCoeff = 1/length(derivee_variance)*derivee_variance*(Exp(:,iL:length(r)).');
            dConjCCyclicCorrelationCoeff = 1/length(derivee_variance)*derivee_variance*(ConjExp(:,iL:length(r)).');
            
            dC = 4*sum(CCyclicCorrelationCoeff.*dConjCCyclicCorrelationCoeff+ConjCCyclicCorrelationCoeff.*dCCyclicCorrelationCoeff);
            
            NCCyclicCorrelationCoeff = 1/length(r)*(r.^2)*(Exp.');
            ConjNCCyclicCorrelationCoeff = 1/length(r)*(r.^2)*(ConjExp.');

            dNCCyclicCorrelationCoeff = 1/length(asymetrique_derivee_variance)*asymetrique_derivee_variance*(Exp(:,iL:length(r)).');
            dConjNCCyclicCorrelationCoeff = 1/length(asymetrique_derivee_variance)*asymetrique_derivee_variance*(ConjExp(:,iL:length(r)).');
            
            dNC = 2*sum(NCCyclicCorrelationCoeff.*dConjNCCyclicCorrelationCoeff+ConjNCCyclicCorrelationCoeff.*dNCCyclicCorrelationCoeff);
        else
            dC = 0;
            dNC = 0;
        end
        dNum = dNum - dC - dNC;        
        grad(iL,iN) = 2*J*1/Den*( dNum - (J+2)*dDen );
    end
end

