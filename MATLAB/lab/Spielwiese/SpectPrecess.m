function SpectPr=SpectPrecess(FileBase,PlaceCell,ARate,Spect,Tune,varargin)
[ThetaThresh,whl.rate,overwrite,plotting,RepFig,Group,Robust] = DefaultArgs(varargin,{5,39.0625,0,0,0,0,0});


if ~FileExists([FileBase '.spectprecess']) | overwrite

  RateFactor = 20000/whl.rate;
  RateEeg = 1250/whl.rate;
  
  AllCount = ARate.count;
  freq = Spect.f(:,1);
  Kstat = (Spect.statCellT(:,1)-Spect.statCellR(:,1))./Spect.statCellR(:,2);
  Kstat(find(isnan(Kstat))) = 0; 
  
  SpectPr.eeg = [];
  SpectPr.cell = [];
  SpectPr.xcorr = [];
  SpectPr.ind = [];
  SpectPr.slope = [];
  SpectPr.maxlag = [];
  SpectPr.tunewidth =[];
  SpectPr.rate = [];
  
  neurons = unique(PlaceCell.ind(:,1)); 
  for neu=1:size(PlaceCell.ind,1);
    
    %keyboard;
    
    indx = find(AllCount(:,1)==neu & Kstat>ThetaThresh);
    Count = ARate.count(indx,:);
    Rate = ARate.rate(indx,:);
    Speed = ARate.speed(indx,:);
    
    TuneWidth = diff(PlaceCell.lfield(neu,:));
    
    [iSortSpeed iSortIndx] = sort(Speed(:,1),'descend');
    %SortIndx = iSortIndx(find(Count(iSortIndx,3)>4));
    %SortSpeed = iSortSpeed(find(Count(iSortIndx,3)>4));
    SortIndx = iSortIndx(find(Rate(iSortIndx,1)>5));
    SortSpeed = iSortSpeed(find(Rate(iSortIndx,1)>5));
    
    if length(SortIndx)<=6
      continue
    end
    
    myf = find(freq>5 & freq<14);
    %myf = find(freq>7 & freq<12);
    
    if 0
      %Group = floor(size(SortIndx,1)/3);
      if (size(SortIndx,1)-Group)<4 %| size(SortIndx,1)<15
	continue
      end
      c=0;
      for tr=1:size(SortIndx,1)-Group
	%if Kstat(indx(SortIndx(tr)))<ThetaThresh
	%	continue;
	% end
	c=c+1;
	SpEeg(c,:) = mean(Spect.yEeg(indx(SortIndx(tr:tr+Group)),myf),1);
	SpCell(c,:) = mean(Spect.yCell(indx(SortIndx(tr:tr+Group)),myf),1);
	[xcorrSp(c,:) lag] = xcorr(SpCell(c,:)',SpEeg(c,:)','unbiased');
	%[xcorrSp(c,:) lag] = xcorr(SpCell(c,:)',SpEeg(c,:)');
	MeanSpeed = mean(SortSpeed(tr:tr+Group));
	sSpeed(c,:) = [neu tr PlaceCell.ind(neu,5) MeanSpeed];
      end
    else
      %interv(1,:) = [1 round(length(SortIndx)/2)];
      %interv(2,:) = [round(length(SortIndx)/2)+1 length(SortIndx)];
      interv(1,:) = [1 round(length(SortIndx)/3)];
      interv(2,:) = [round(length(SortIndx)/3)+1 round(2*length(SortIndx)/3)];
      interv(3,:) = [round(2*length(SortIndx)/3)+1 length(SortIndx)];
      for c=1:3
	SpEeg(c,:) = mean(Spect.yEeg(indx(SortIndx(interv(c,1):interv(c,2))),myf),1);
	SpCell(c,:) = mean(Spect.yCell(indx(SortIndx(interv(c,1):interv(c,2))),myf),1);
	[xcorrSp(c,:) lag] = xcorr(SpCell(c,:)',SpEeg(c,:)','unbiased');
	%[xcorrSp(c,:) lag] = xcorr(SpCell(c,:)',SpEeg(c,:)');
	MeanSpeed = mean(SortSpeed(interv(c,1):interv(c,2)));
	MeanRate(c,1) = mean(Rate(SortIndx(interv(c,1):interv(c,2)),1));
	sSpeed(c,:) = [neu c PlaceCell.ind(neu,5) MeanSpeed];
      end
    end
      
    
    %% Slope Speed vs. 
    [MaxXC MaxInd] = max(xcorrSp'); 
    DFreq = lag(MaxInd)*diff(freq(1:2));
    if Robust
      [Slope Stats] = robustfit(sSpeed(:,4),DFreq');
    else 
      Slope(2,1) = (DFreq(c)-DFreq(1))/(sSpeed(c,4)-sSpeed(1,4));
      Slope(1,1) = DFreq(c) - sSpeed(c,4)/Slope(2);
      Stats.p = [(DFreq(c)-DFreq(1)) (sSpeed(c,4)-sSpeed(1,4))]';
    end
    
    SpectPr.eeg = [SpectPr.eeg; SpEeg];
    SpectPr.cell = [SpectPr.cell; SpCell];
    SpectPr.xcorr = [SpectPr.xcorr; xcorrSp];
    SpectPr.xlag = lag*diff(freq(1:2));
    SpectPr.maxlag = [SpectPr.maxlag; lag(MaxInd)'*diff(freq(1:2))];
    SpectPr.ind = [SpectPr.ind; sSpeed];
    SpectPr.slope = [SpectPr.slope; [Slope' Stats.p']];
    SpectPr.f = freq(myf);
    SpectPr.tunewidth = [SpectPr.tunewidth; [TuneWidth neu PlaceCell.ind(neu,[1 5])]];
    SpectPr.rate = [SpectPr.rate; MeanRate];
    
    %keyboard
    
    clear SpEeg  SpCell xcorrSp sSpeed
  end
  
  save([FileBase '.spectprecess'],'SpectPr');
else
  load([FileBase '.spectprecess'],'-MAT');
end

if plotting
  
  neu = unique(SpectPr.ind(:,1));
  for n=1:length(neu)
    neu(n)
    indx = find(SpectPr.ind(:,1)==neu(n));
    
    figure(23645);clf
    subplot(121)
    %imagesc(freq(myf),[],unity(SpEeg')')
    imagesc(SpectPr.f,[],SpectPr.eeg(indx,:))
    xlabel('Freq [Hz]','FontSize',12)
    ylabel('Trials','FontSize',12)
    title('Eeg','FontSize',12)
    set(gca,'YDir','normal','TickDir','out','FontSize',12)
    box off; grid on;
    subplot(122)
    %imagesc(freq(myf),[],unity(SpCell')')
    imagesc(SpectPr.f,[],SpectPr.cell(indx,:))
    xlabel('Freq [Hz]','FontSize',12)
    title('Unit','FontSize',12)
    set(gca,'YDir','normal','TickDir','out','FontSize',12)
    box off; grid on;
    %title(num2str(neu));
    
    figure(28364);clf;
    imagesc(SpectPr.xlag,[],unity(SpectPr.xcorr(indx,:)')')
    %imagesc(lag*diff(freq(1:2)),[],xcorrSp)
    xlabel('\Delta Freq [Hz]','FontSize',16)
    ylabel('Trials','FontSize',16)
    title('Unit-Eeg','FontSize',16)
    set(gca,'YDir','reverse','TickDir','out','FontSize',16)
    box off; grid on;
    hold on
    plot(SpectPr.maxlag(indx,:),[1:size(SpectPr.xcorr(indx,:),1)],'k.','MarkerSize',20)
    grid on
      
    %keyboard
    
    figure(723468);clf
    subplot(121)
    plot(SpectPr.maxlag(indx,1),SpectPr.ind(indx,4),'.')
    %hold on
    %plot(SpectPr.maxlag(indx,:),(SpectPr.maxlag(indx,:)-SpectPr.slope(n,1))/SpectPr.slope(n,2),'r')
    xlim([-5 5]);grid on
    %xlim([min(SpectPr.maxlag(indx,:)) max(SpectPr.maxlag(indx,:))])
    %ylim([min(SpectPr.ind(indx,3)) max(SpectPr.ind(indx,3))])
    %legend(['y=' num2str(1/SpectPr.slope(n,2)) 'x+' num2str(SpectPr.slope(n,1)./SpectPr.slope(n,2))]);
    subplot(122)
    plot(SpectPr.rate(indx,1),SpectPr.ind(indx,4),'.')
    grid on;
    
    if PlaceCell.ind(n,5)==1
      title('PlaceCell');
    elseif PlaceCell.ind(n,5)==2
      title('Interneuron');
    end
    
    
    figure(34264)
    subplot(121)
    plot(SpectPr.f,SpectPr.eeg(indx,:))
    subplot(122)
    plot(SpectPr.f,SpectPr.cell(indx,:))
    
    %%% 
    if RepFig
      reportfig(gcf,'AllSpect2',[],['Neuron ' num2str(neu)],75);
      %reportfig(gcf,'Test',[],['Neuron ' num2str(neu)],75);
    else
      waitforbuttonpress
      %pause(1)
    end
    
  end
end

return

%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%

if plotting
  figure(23645);clf
  subplot(121)
  %imagesc(freq(myf),[],unity(SpEeg')')
  imagesc(freq(myf),[],SpEeg)
  xlabel('Freq [Hz]','FontSize',12)
  ylabel('Trials','FontSize',12)
  title('Eeg','FontSize',12)
  set(gca,'YDir','normal','TickDir','out','FontSize',12)
  box off; grid on;
  subplot(122)
  %imagesc(freq(myf),[],unity(SpCell')')
  imagesc(freq(myf),[],SpCell)
  xlabel('Freq [Hz]','FontSize',12)
  title('Unit','FontSize',12)
  set(gca,'YDir','normal','TickDir','out','FontSize',12)
  box off; grid on;
  %title(num2str(neu));
  
  figure(28364);clf;
  imagesc(lag*diff(freq(1:2)),[],unity(xcorrSp')')
  %imagesc(lag*diff(freq(1:2)),[],xcorrSp)
  xlabel('\Delta Freq [Hz]','FontSize',16)
  ylabel('Trials','FontSize',16)
  title('Unit-Eeg','FontSize',16)
  set(gca,'YDir','normal','TickDir','out','FontSize',16)
  box off; grid on;
  hold on
  plot(lag(MaxInd)*diff(freq(1:2)),[1:size(xcorrSp,1)],'k.','MarkerSize',20)
  grid on
  
  %keyboard
  
  figure(723468);clf
  plot(DFreq,sSpeed(:,4),'.')
  hold on
  plot(DFreq,(DFreq-Slope(1))/Slope(2),'r')
  xlim([min(DFreq) max(DFreq)])
  ylim([min(sSpeed(:,4)) max(sSpeed(:,4))])
  legend(['y=' num2str(1/Slope(2)) 'x+' num2str(Slope(1)/Slope(2))]);
  
  neu
  if RepFig
    reportfig(gcf,'AllSpect2',[],['Neuron ' num2str(neu)],75);
    %reportfig(gcf,'Test',[],['Neuron ' num2str(neu)],75);
  else
    waitforbuttonpress
  end
end
