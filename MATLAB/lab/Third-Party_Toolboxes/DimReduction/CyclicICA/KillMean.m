function [ yc ] = KillMean(y)

% [ yc ] = KillMean(y)
%
% This function delete the temporal mean of the observations
%
% Author : Pierre JALLON
% More information : http://www-syscom.univ-mlv.fr/~jallon/toolbox.php
%
% Date of creation : 05/09/2005

if (size(y,1)>size(y,2))
    y = y.';    
end

LMean = 20;

for (iy=1:size(y,1))
    yi = y(iy,:);
    for (t = LMean+1:length(yi)-LMean);
        yci(t-LMean) = yi(t)-mean(yi(t-LMean:t+LMean)); 
    end
    yc(iy,:) = yci;
end
