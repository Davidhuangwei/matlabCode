function [ Freq,R ] = EstimateCyclicFrequencies(y)

% [ Freq,R ] = EstimateCyclicFrequencies(y)
%
% This function return a criteria which has pic at the cyclic frequencies.
%
%
% Author : Pierre JALLON
% More information : http://www-syscom.univ-mlv.fr/~jallon/toolbox.php
%
% Date of creation : 04/23/2005
% Date of last modification : 04/27/20005


addpath(sprintf('%s/CyclicFrequenciesEstimation/',pwd));


if (size(y,1)>size(y,2))
    y = y.';    
end

[ Freq,R ] = ComputeRalpha(y,10);
[ Freq,R ] = Blanchit(Freq,R);

rmpath(sprintf('%s/CyclicFrequenciesEstimation/',pwd));

I = floor(0.50*length(R)):length(R);

plot(Freq(I),R(I));