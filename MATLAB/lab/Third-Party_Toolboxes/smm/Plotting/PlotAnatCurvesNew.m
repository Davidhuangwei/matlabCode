function PlotAnatCurves(anatOverlayName,multiplier,offset,curvesColor,lineWidth)
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
        plot(anatCurves{k,1}.*multiplier(2)+offset(2),anatCurves{k,2}.*multiplier(1)+offset(1),'color',curvesColor,'linewidth',lineWidth);
    end
    
    set(gca,'NextPlot',holdStatus)
end