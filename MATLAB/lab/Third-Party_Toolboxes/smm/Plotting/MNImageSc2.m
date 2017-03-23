function [colorLimits, axesHandles] = MNImageSc(subPlotsCell,colorLimits,sameScaleBool,nanHSV)
% function MNImageSc2(subPlotsCell,colorLimits)
% subPlotsCell is an m x n cell array whose arrangement determines the (x,y)
%   coordinates of the subplots in the figure (n=vertical,m=horizontal);
% colorLimits is used to set 'clim' of all subplots.
% sameScaleBool determines sets whether all subplots use a common (min/max) 
%   scale if colorLimits isempty

if ~exist('nanHSV', 'var') | isempty(nanHSV)
    nanHSV = [];
end

[m, n] = size(subPlotsCell);

if ~exist('colorLimits', 'var') | isempty(colorLimits)
    if ~exist('sameScaleBool', 'var') | isempty(sameScaleBool) | sameScaleBool==0;
        colorLimits = [];
    else
        colorLimits = [min(min([subPlotsCell{:}])) max(max([subPlotsCell{:}]))];
    end 
end

axesHandles = cell(m, n);

for i=1:m
    for j=1:n
        axesHandles{i,j} = subplot(m,n,(i-1)*n+j);
        ImageRmNaN(subPlotsCell{i,j},colorLimits,nanHSV);
    end
end
