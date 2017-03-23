function PlotShankAnatCurves(anatOverlayName,shankValue,xLimits,multiplier,offset,curvesColor,lineWidth)
%function PlotAnatCurves(anatOverlayName,multiplier,offset,curvesColor,lineWidth)
% loads a cells array of vectors from file and plots in the current figure window
% multiplier: default = [1 1] 
% offset: defalut = [0 0]
% curvesColor default = [0.55, 0.55, 0.55]
% lineWidth default = 2

if ~exist('curvesColor','var') | isempty(curvesColor)
    curvesColor = [0.55, 0.55, 0.55];
end
if ~exist('lineWidth','var') | isempty(lineWidth)
    lineWidth = 2;
end
if ~exist('multiplier','var') | isempty(multiplier)
    multiplier = [1 1];
end
if ~exist('offset','var') | isempty(offset)
    offset = [0 0] ;
end



if ~exist(anatOverlayName,'file')
    fprintf('No Anat Overlay File found: %s\n',anatOverlayName);
else
    load(anatOverlayName);
    holdStatus = get(gca,'NextPlot');
    set(gca,'NextPlot','add');
    for k=1:size(anatCurves,1)
        curvesX = anatCurves{k,1};
        curvesY = anatCurves{k,2};
        index = find(abs(curvesX-(shankValue./multiplier(2)-offset(2))) < 0.01);
        indexes = [];
        if ~isempty(index) & length(index) > 1
             diffIndex = find(abs(diff(curvesY(index))) > 0.01);
             diffIndex = [0 (diffIndex) length(index)];
             for j=1:length(diffIndex)-1
                 indexes = cat(1,indexes,round(median(index(diffIndex(j)+1:diffIndex(j+1)))));
             end
        end
        %    index = index(~cat(2,abs(diff(curvesY(index))) < 0.1,1))
        %end
        %curvesY(indexes).*multiplier(1)
        if ~isempty(indexes)
            for l=1:length(indexes)
                %anatCurves{k,2}(indexes(l)).*multiplier(1)-offset(1)
                plot(xLimits,[anatCurves{k,2}(indexes(l)).*multiplier(1)-offset(1) anatCurves{k,2}(indexes(l)).*multiplier(1)-offset(1)],...
                    'color',curvesColor,'linewidth',lineWidth)
            end
        end
        %plot(anatCurves{k,1}.*multiplier(2)-offset(2),anatCurves{k,2}.*multiplier(1)-offset(1),'color',curvesColor,'linewidth',lineWidth);
    end
    
    set(gca,'NextPlot',holdStatus)
end