function PlotAnatCurves(varargin)
%function PlotAnatCurves(anatOverlayName,multiplier,offset,curvesColor,lineWidth)
% loads a cells array of vectors from file and plots in the current figure window
% [multiplier,offset,curvesColor,lineWidth] = DefaultArgs(varargin,{size(LoadVar('ChanInfo/ChanMat.eeg.mat')),...
%     load('ChanInfo/Offset.eeg.txt'),[0.55, 0.55, 0.55],2});
anatOverlayName ='ChanInfo/AnatCurves.mat';
if ~FileExists(anatOverlayName)
    return
end
if exist('ChanInfo/ChanMat.eeg.mat','file')
    load('ChanInfo/ChanMat.eeg.mat');
    chanMatSize = size(chanMat);
else
    chanMatSize = [16,6];
end
if exist('ChanInfo/Offset.eeg.txt','file')
    offset = load('ChanInfo/Offset.eeg.txt')+0.5;
else
    offset = [0.5 0.5];
end
       
[multiplier,offset,curvesColor,lineWidth] = DefaultArgs(varargin,{chanMatSize,...
    offset,[0.55, 0.55, 0.55],2});
% if ~exist('curvesColor','var') | isempty(curvesColor)
%     curvesColor = [0.55, 0.55, 0.55];
% end
% if ~exist('lineWidth','var') | isempty(lineWidth)
%     lineWidth = 2;
% end
% if ~exist('multiplier','var') | isempty(multiplier)
%     multiplier = [1 1];
% end
% if ~exist('offset','var') | isempty(offset)
%     offset = [0 0] ;
% end
% 
% 

% if ~exist(anatOverlayName,'file')
%     fprintf('No Anat Overlay File found: %s\n',anatOverlayName);
% else
    load(anatOverlayName);
    
    holdStatus = get(gca,'NextPlot');
    set(gca,'NextPlot','add');

    for k=1:size(anatCurves,1)
        plot(anatCurves{k,1}.*multiplier(2)+offset(2),anatCurves{k,2}.*multiplier(1)+offset(1),'color',curvesColor,'linewidth',lineWidth);
    end
    
    set(gca,'NextPlot',holdStatus)
% end