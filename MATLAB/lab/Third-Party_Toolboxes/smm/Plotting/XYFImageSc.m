function axesHandles = XYFImageSc(subPlotsCell,colorLimits,sameScaleBool,figureHandles)
% function axesHandles = XYFImageSc(subPlotsCell,colorLimits,sameScaleBool,figureHandles)
% subPlotsCell is an x by y cell array whose arrangement determines the (x,y)
%   coordinates of the subplots in the figure;
% colorLimits is used to set 'clim' of all subplots.
% sameScaleBool determines whether all subplots use a common (min/max) 
%   scale if colorLimits isempty

if ~exist('nanHSV', 'var') | isempty(nanHSV)
    nanHSV = [];
end

[x, y, f] = size(subPlotsCell);

if ~exist('colorLimits', 'var') | isempty(colorLimits)
    if ~exist('sameScaleBool', 'var') | isempty(sameScaleBool) | sameScaleBool==0;
        colorLimits = [];
    else
        colorLimits = [min(min(min([subPlotsCell{:}]))) max(max(max([subPlotsCell{:}])))];
    end 
end

for k=1:f
    if ~exist('figureHandles','var') | isempty(figureHandles)
        figure;
    else
        figure(figureHandles(f));
    end
    

    for i=1:x
        for j=1:y
            if ~isempty(subPlotsCell{i,j,k})
                axesHandles(i,j) = subplot(x,y,(i-1)*y+j);
                imagesc(subPlotsCell{i,j,k},colorLimits);
                colorbar
            end
        end
    end
end
