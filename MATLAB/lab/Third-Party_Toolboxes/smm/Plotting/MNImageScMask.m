function [colorLimits, axesHandles] = MNImageScMask(subPlotsCell,mask,colorLimits,sameScaleBool,maskHSV)
% function MNImageSc2(subPlotsCell,colorLimits)
% subPlotsCell is an m x n cell array whose arrangement determines the (x,y)
%   coordinates of the subplots in the figure (n=vertical,m=horizontal);
% colorLimits is used to set 'clim' of all subplots.
% sameScaleBool determines sets whether all subplots use a common (min/max) 
%   scale if colorLimits isempty
% maskHSV set the HSV of the masked data

if ~exist('mask', 'var') | isempty(mask)
    mask = [];
end
if ~exist('maskHSV', 'var') | isempty(maskHSV)
    maskHSV = [];
end

[m, n] = size(subPlotsCell);

if ~exist('colorLimits', 'var') | isempty(colorLimits)
    if ~exist('sameScaleBool', 'var') | isempty(sameScaleBool) | sameScaleBool==0;
        colorLimits = [];
    else
        colorLimits = [];
        for i=1:m
            for j=1:n
                imageData = subPlotsCell{i,j};
                colorLimits = [min([min(min(imageData(mask))) colorLimits]) max([max(max(imageData(mask))) colorLimits])];
            end
        end
    end
end

axesHandles = cell(m, n);

for i=1:m
    for j=1:n
        axesHandles{i,j} = subplot(m,n,(i-1)*n+j);
        ImageScMask(subPlotsCell{i,j},mask,colorLimits,maskHSV);
    end
end
