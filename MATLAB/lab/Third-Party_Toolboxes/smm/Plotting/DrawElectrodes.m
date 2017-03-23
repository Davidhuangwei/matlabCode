% function DrawElectrodes(chanMat,varargin)
% [color lineWidth siteSize shankWidth tipSize] = DefaultArgs(varargin,{[0 0 0],2,4,0.34,0.22});
function DrawElectrodes(chanMat,varargin)
[color lineWidth siteSize shankWidth tipSize] = DefaultArgs(varargin,{[0 0 0],2,4,0.34,0.22});
holdStatus = get(gca,'NextPlot');
set(gca,'NextPlot','add');
offSet = 0.5;
for j=1:size(chanMat,2)
    plot([j-shankWidth/2 j-tipSize/2], [0+offSet size(chanMat,1)],'-','color',color,'linewidth',lineWidth)
    plot([j+shankWidth/2 j+tipSize/2], [0+offSet size(chanMat,1)],'-','color',color,'linewidth',lineWidth)
    plot([j-tipSize/2 j+0], [size(chanMat,1) size(chanMat,1)+offSet],'-','color',color,'linewidth',lineWidth)
    plot([j+tipSize/2 j-0], [size(chanMat,1) size(chanMat,1)+offSet],'-','color',color,'linewidth',lineWidth)
    plot(repmat(j,size(chanMat,1),1),1:size(chanMat,1),'s','color',color,'markersize',siteSize)
end
set(gca,'NextPlot',holdStatus)
return   

