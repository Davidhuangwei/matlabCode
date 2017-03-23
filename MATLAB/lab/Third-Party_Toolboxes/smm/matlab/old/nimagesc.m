function [colorLimits, figureNum] = nimagesc(subPlotsCell,sameScaleBool,colorLimits,figureNum,anatOverlayName)
% function nimagesc(subPlotsCell,colorLimits)
% ImagesCell is an n x m cell array whose arrangement determines the (x,y)
%   coordinates of the subplots in the figure (n=vertical,m=horizontal);
% Each cell of subPlotsCell should contain a 1x2 cell array with an AxB
%   matrix that will be passed to imagesc and a string to title the subplot
% sameScaleBool determines sets whether all subplots use the same scale
% colorLimits is used to set 'clim'. If empty plots will be
%   autoscaled
% FigureNum optionally determines the number of the figure
% anatOverlayName: name of AnatCurvScaled.mat file

if ~exist('anatOverlayName', 'var') | isempty(anatOverlayName)
    anatOverlayName = 0;
end

if ~exist('sameScaleBool', 'var') | isempty(sameScaleBool)
    sameScaleBool = 0;
else
    if ~exist('colorLimits', 'var') | isempty(colorLimits)
        colorLimits = NaN*zeros(1,2);
        autoScaleBool = 1;
    else
        autoScaleBool = 0;
    end
end

subPlotsCell = subPlotsCell';

[n m] = size(subPlotsCell);

if ~exist('figureNum', 'var') | isempty(figureNum)
    figure;
    figureNum = gcf;
    fprintf('%s',figureNum)
else
    figure(figureNum);
    fprintf('%s',figureNum)    
end

load('ColorMapSean3.mat')
colormap(ColorMapSean3);
for i=1:n
    for j=1:m
        subplot(m,n,(j-1)*n+i);
        subPlotN = subPlotsCell{i,j};
        imagesc(subPlotN{1});
        if anatOverlayName
            if ~exist(anatOverlayName,'file')
                fprintf('No Anat Overlay File found: %s\n',anatOverlayName);
            else
                load(anatOverlayName);
                hold on
                for k=1:size(anatCurves,1)
                    plot(anatCurves{k,1},anatCurves{k,2},'color',[0.65,0.65,0.65],'linewidth',2);
                end
            end
        end

        title(subPlotN{2});
        if sameScaleBool
            if ~autoScaleBool
                set(gca,'clim',[colorLimits]);
                colorbar;
            else
                colorLimits(1) = min([min(min(subPlotN{1})) colorLimits(1)]);
                colorLimits(2) = max([max(max(subPlotN{1})) colorLimits(2)]);
            end
        else
            colorbar;
        end
    end
end

if sameScaleBool
    if autoScaleBool
        for i=1:n
            for j=1:m
                subplot(m,n,(j-1)*n+i);
                set(gca,'clim',[colorLimits]);
                colorbar;
            end
        end
    end
else
    colorLimits = [];
end
