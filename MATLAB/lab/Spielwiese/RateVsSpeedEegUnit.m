function RateVsSpeedEegUnit(CatAll,varargin)
[RepFig,whl.rate,Group,nCell,FIG] = DefaultArgs(varargin,{0,1250,1,[],0});

RateFactor = 20000/whl.rate;
RateEeg = 1250/whl.rate;

%CatAll = ALL(1);

Spect = CatAll.spectTr;
freq = CatAll.spectTr.f(:,1);

AllCount = CatAll.rate.count;

if ~isempty(nCell)
  Loop=nCell;
else
  Loop = [1:size(CatAll.placecell.ind,1)];
end
for neu=Loop

  neu

  indx = find(AllCount(:,1)==neu);
  Count = CatAll.rate.count(indx,:);
  Rate = CatAll.rate.rate(indx,:);
  Speed = CatAll.rate.speed(indx,:);
  
  [SortSpeed iSortIndx] = sort(Speed(:,1));
  SortIndx = iSortIndx(find(Count(iSortIndx,3)>4));
  
  [SortCount CountIndx] = sort(Count(:,3));
  [SortRate RateIndx] = sort(Rate(:,1));
    
  %keyboard
  
  myf = find(freq>3 & freq<15);
  figure(111)
  subplot(221)
  imagesc(freq(myf),[],Spect.yCell(indx,myf))
  title('original')
  subplot(222)
  imagesc(freq(myf),[],Spect.yCell(indx(iSortIndx),myf))
  title('speed')
  subplot(223)
  imagesc(freq(myf),[],Spect.yCell(indx(CountIndx),myf))
  title('count')
  subplot(224)
  imagesc(freq(myf),[],Spect.yCell(indx(RateIndx),myf))
  title('rate')

  figure(222)
  subplot(221)
  plot([1:length(indx)],[1:length(indx)],'.');
  title('original')
  subplot(222)
  plot([1:length(indx)],iSortIndx,'.');
  title('speed')
  subplot(223)
  plot([1:length(indx)],CountIndx,'.');
  title('count')
  subplot(224)
  plot([1:length(indx)],RateIndx,'.');
  title('rate')

  
  myf = find(freq>7 & freq<12);

  if length(SortIndx)<Group
    continue
  end
    
  for tr=1:size(SortIndx,1)-Group
    meanSpEeg(tr,:) = mean(Spect.yEeg(indx(SortIndx(tr:tr+Group)),myf));
    meanSpCell(tr,:) = mean(Spect.yCell(indx(SortIndx(tr:tr+Group)),myf));
    [xcorrSp(tr,:) lag] = xcorr(meanSpCell(tr,:)',meanSpEeg(tr,:)','unbiased');
    meanSpeed(tr) = mean(SortSpeed(tr:tr+Group));
  end

  
  [MaxXC MaxInd] = max(xcorrSp'); 
  if FIG==1
    
    %figure(28364);clf;
    imagesc(lag*diff(freq(1:2)),[],unity(xcorrSp')')
    %imagesc(lag*diff(freq(1:2)),[],xcorrSp)
    xlabel('\Delta freqency [Hz]','FontSize',16)
    ylabel('speed-sorted trials','FontSize',16)
    set(gca,'YDir','normal','TickDir','out','FontSize',16)
    hold on
    plot(lag(MaxInd)*diff(freq(1:2)),[1:size(xcorrSp,1)],...
	 'o','markersize',5,'markerfacecolor',[0 0 0],'markeredgecolor',[0 0 0])
    Lines(0,[],'k','--',2)
    box off;
	
  elseif FIG==2
    
    figure(3);clf
    DFreq = lag(MaxInd)*diff(freq(1:2));
    [Slope1 Stats] = robustfit(meanSpeed',DFreq');
    %[Slope2 Stats] = robustfit(DFreq',meanSpeed');
    [Slope3 Stats] = robustfit(meanSpeed',DFreq','welsch',2);
    [rho, pval] = corr([DFreq' meanSpeed']);
    
    [1/Slope1(2) 1/Slope3(2) diff(CatAll.placecell.lfield(neu,:))]
    
    plot(DFreq,meanSpeed,'o','markersize',5,'markerfacecolor',[0 0 0],'markeredgecolor',[0 0 0])
    hold on
    plot([-2 4],[-2 4]/rho(1,2)+10,'--','Color',[0 0 0],'LineWidth',2);
    %plot(DFreq,(DFreq-Slope1(1))/Slope1(2),'r')
    %plot(DFreq,(DFreq-Slope3(1))/Slope3(2),'g')
    xlim([min(DFreq) max(DFreq)])
    ylim([min(meanSpeed) max(meanSpeed)])
    title(['rho=' num2str(1/rho(1,2)) '  pval=' num2str(pval(1,2))]);
    xlabel('\Delta freqency [Hz]','FontSize',16)
    ylabel('speed [cm/s]','FontSize',16)
    set(gca,'YDir','normal','TickDir','out','FontSize',16)
    box off
    
  else
    
    figure(23645);clf
    subplot(121)
    imagesc(freq(myf),[],Spect.yEeg(indx(SortIndx),myf))
    xlabel('Freq [Hz]','FontSize',12)
    ylabel('Trials','FontSize',12)
    title('Eeg','FontSize',12)
    set(gca,'YDir','normal','TickDir','out','FontSize',12)
    box off;
    subplot(122)
    imagesc(freq(myf),[],Spect.yCell(indx(SortIndx),myf))
    xlabel('Freq [Hz]','FontSize',12)
    title('Unit','FontSize',12)
    set(gca,'YDir','normal','TickDir','out','FontSize',12)
    box off; grid on;
    %title(num2str(neu));
    
    figure(28374);clf
    subplot(121)
    imagesc(freq(myf),[],meanSpEeg)
    xlabel('Freq [Hz]','FontSize',12)
    ylabel('Trials','FontSize',12)
    title('Eeg','FontSize',12)
    set(gca,'YDir','normal','TickDir','out','FontSize',12)
    box off; grid on;
    subplot(122)
    %imagesc(freq(myf),[],meanSpCell)
    imagesc(freq(myf),[],meanSpCell)
    xlabel('Freq [Hz]','FontSize',12)
    title('Unit','FontSize',12)
    set(gca,'YDir','normal','TickDir','out','FontSize',12)
    box off; grid on;
    if RepFig
      reportfig(gcf,'AllSpect2',[],['Neuron ' num2str(neu)],75);
      %reportfig(gcf,'Test',[],['Neuron ' num2str(neu)],75);
    end
    
    %keyboard
    
  end
    
    %if RepFig
    %  reportfig(gcf,'AllSpect2',[],['Neuron ' num2str(neu)],75);
    %  %reportfig(gcf,'Test',[],['Neuron ' num2str(neu)],75);
    %else
      waitforbuttonpress
    %end
    
    clear meanSpEeg  meanSpCell xcorrSp meanSpeed

end
return

%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%

