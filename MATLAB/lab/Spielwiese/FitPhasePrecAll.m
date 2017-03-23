function SlopeAll=FitPhasePrecAll(FileBase,PlaceCell,spike,whl,trial,varargin)
[overwrite,Manual,Plotting] = DefaultArgs(varargin,{0,1,0});
%function SlopeAll=FitPhasePrecAll(FileBase,PlaceCell,spike,whl,trial,varargin)
%[overwrite,Manual] = DefaultArgs(varargin,{0,1});
%
% fits phase precession of spikes from all trials using robustfit


fprintf('  linear fit of phase precession...\n');

RateFactor = 20000/whl.rate;

if ~FileExists([FileBase '.slope']) | overwrite
  
  figure;
  for neu=1:size(PlaceCell.ind,1)
    if PlaceCell.ind(neu,5) ~=1
      continue;
    end
    
    neuron = PlaceCell.ind(neu,1);
    dire = PlaceCell.ind(neu,4);
    
    goodtrials = PlaceCell.trials(find(PlaceCell.trials(:,1)==neu),2:3);
    indx = find(spike.ind==neuron & spike.good & spike.dir==dire & WithinRanges(round(spike.t/RateFactor),goodtrials));
    indx2 = find(spike.ind==neuron & spike.good & spike.dir==dire);
    
    %clf
    %subplot(211)
    %plot(spike.lpos(indx2),spike.ph(indx2),'.');
    %hold on;
    %plot(spike.lpos(indx2),spike.ph(indx2)-2*pi,'.');
    %plot(spike.lpos(indx2),spike.ph(indx2)+2*pi,'.');
    
    PlaceCell.ind(neu,:)
    [slope b] = FitPhasePrec(spike.lpos(indx),spike.ph(indx),spike.lpos(indx2),spike.ph(indx2),Manual);
    
    SlopeAll(neu,1:4) = [slope b];
    if trial.OneMeanTrial & dire == 3
      SlopeAll(neu,5) = -slope(1);
    else
      SlopeAll(neu,5) = slope(1);
    end
    
  end
  save([FileBase '.slope'],'SlopeAll')
else
  load([FileBase '.slope'],'-MAT');
end

if Plotting
  figure
  count = 0;
  for neu=1:size(PlaceCell.ind,1)
    if PlaceCell.ind(neu,5) ~=1
      continue;
    end

    neuron = PlaceCell.ind(neu,1);
    dire = PlaceCell.ind(neu,4);
    
    goodtrials = PlaceCell.trials(find(PlaceCell.trials(:,1)==neu),2:3);
    indx = find(spike.ind==neuron & spike.good & spike.dir==dire & WithinRanges(round(spike.t/RateFactor),goodtrials));
    indx2 = find(spike.ind==neuron & spike.good & spike.dir==dire);

    count=count+1;
    subplotfit(count,size(find(PlaceCell.ind(:,5)==1),1))
    
    plot(spike.lpos(indx,1),spike.ph(indx,1)*180/pi,...
	 'o','markersize',5,'markeredgecolor','none','markerfacecolor',[0.2 0.2 0.7]);
    hold on
    plot(spike.lpos(indx,1),spike.ph(indx,1)*180/pi+360,...
	 'o','markersize',5,'markeredgecolor','none','markerfacecolor',[0.2 0.2 0.7]);
    plot(spike.lpos(indx,1),spike.ph(indx,1)*180/pi+720,...
	 'o','markersize',5,'markeredgecolor','none','markerfacecolor',[0.2 0.2 0.7]);
    plot(spike.lpos(indx,1),180/pi*(SlopeAll(neu,1)*spike.lpos(indx,1)+SlopeAll(neu,3))+360,'--r');
    title([num2str(neuron) ' | ' num2str(dire)]);
    
  end

  ForAllSubplots('axis tight');
  
  figure
  hist(180/pi*SlopeAll(find(PlaceCell.ind(:,5)==1),5));
  
end

return;
