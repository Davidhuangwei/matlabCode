function PlotTrigEEG(aveSeg,shift,varargin)

[stdSeg,badChans,plotColor,eegSamp,figNum,figText] = DefaultArgs(varargin,{0,0,[0 0 0],1250,gcf,''});
    
if ~exist('shift','var') | isempty(shift)
    shift = 2*max(max(max(abs(aveSeg+stdSeg))));
end

nShanks = size(aveSeg,2);
chansPerShank = size(aveSeg,1);
chanMat = MakeChanMat(nShanks,chansPerShank);

segLen = size(aveSeg,3);

for i=1:nShanks
    subplot(1,nShanks,i)
    hold on
    grid on
    for j=1:chansPerShank
        if isempty(find(chanMat(j,i) == badChans))
            plot(squeeze(aveSeg(j,i,:))-j*shift,'color',plotColor);
            if stdSeg~=0
                plot(squeeze(aveSeg(j,i,:)+stdSeg(j,i,:))-j*shift,'--','color',mean([plotColor;[1 1 1]],1).^(1/2));
                plot(squeeze(aveSeg(j,i,:)-stdSeg(j,i,:))-j*shift,'--','color',mean([plotColor;[1 1 1]],1).^(1/2));
            end
        end
    end
    set(gca,'ylim',[-(chansPerShank+1)*shift 0],'xlim',[0 segLen],'ytick',[],...
        'xtick',[0,(segLen+1)/2,segLen],'xticklabel',[-segLen/2/eegSamp*1000 0 segLen/2/eegSamp*1000]);
    if i==1
        xLimits = get(gca,'xlim');
        yLimits = get(gca,'ylim');
        text(xLimits(1)-1.1*(xLimits(2)-xLimits(1)), yLimits(1)+(yLimits(2)-yLimits(1))/2,figText)
    end

end

