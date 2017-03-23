function [J] = ComputeCritere(r,FreqCycl)
%
% [J] = ComputeCritere(r,FreqCycl)
%
% This function compute the Shalvi-Weinstein cost function
% value for signal r.
%
% Author : Pierre JALLON
% Date of creation : 04/23/2005
% Date of last modification : 04/23/20005
%

Den = mean(abs(r).^2).^2;
if (length(FreqCycl)>0)
    for (iC=1:length(FreqCycl));
        Exp(iC,:) = exp(-2*i*pi*FreqCycl(iC)*(1:length(r)));
    end
    CCyclicCorrelationCoeff = 6*sum(abs(1/length(r)*r.^2*(Exp.')).^2);
else
    CCyclicCorrelationCoeff = 0;
end

J = (mean(abs(r).^4)-CCyclicCorrelationCoeff)/Den - 3;

