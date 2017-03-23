function PlotTrigCSD(csdData,eegData,varargin)

[eegBadChans,figNum,eegSamp,colorLimit,figText] = DefaultArgs(varargin,{[],gcf,1250,max(max(max(abs(csdData)))),''});

normVal = 2*max(max(max(eegData)));
chanPerShank = size(eegData,1);
shift = (chanPerShank-size(csdData,1))/2;
nShanks = size(eegData,2);
chanMat = MakeChanMat(nShanks,chanPerShank);
segLen = size(csdData,3);

figure(figNum)
for j=0:1:nShanks-1
    subplot(1,nShanks,j+1)
    pcolor(flipud(squeeze(csdData(:,j+1,:))))
    shading interp
    hold on

    for i=1:chanPerShank
       if ~isempty(find(chanMat(i,j+1) == eegBadChans))
           plot(squeeze(eegData(i,j+1,:))./normVal+chanPerShank-i+1-shift,'color',[0.5 0.5 0.5])
       else
           plot(squeeze(eegData(i,j+1,:))./normVal+chanPerShank-i+1-shift,'k')
       end
    end

    set(gca,'xtick',[0:segLen/4:segLen])
    set(gca,'xticklabel',[0:segLen/4:segLen]/eegSamp*1000-segLen/2/eegSamp*1000)
    set(gca,'FontSize',12)
    set(gca,'clim',[-colorLimit colorLimit]);
    if j==0
        xLimits = get(gca,'xlim');
        yLimits = get(gca,'ylim');
        text(xLimits(1)-1.6*(xLimits(2)-xLimits(1)), yLimits(1)+(yLimits(2)-yLimits(1))/2,figText)
    end
    colorbar

    hold off
end
