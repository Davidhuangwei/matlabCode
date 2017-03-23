function Fccg=CorrPFTr(FileBase,PlaceCell,whl,trial,spike,tune,varargin)
[Plotting,overwrite] = DefaultArgs(varargin,{1,0});

%% Auto- and  Cross-Correlogramm during trial
%% 

if ~FileExists([FileBase '.xcorrel']) | overwrite
  
  RateFactor = 20000/whl.rate;
  Ind = PlaceCell.ind;
  neurons = unique(Ind(:,1));
  Trials = PlaceCell.trials;
    
  %% take all good spikes:
  aindx = ismember(spike.ind,unique(Ind(:,1))) & spike.good & WithinRanges(round(spike.t/RateFactor),trial.itv);
  
  gspiket = spike.t(aindx);
  gspikeind = spike.ind(aindx);
  [ccg, t] = CCG(gspiket,gspikeind,100,200,20000);
  Fccg.ccgt = t;
  Fccg.ccg = ccg;
  
  %% sort trials according to speed
  Fccg.smccg = zeros(size(ccg,1),size(ccg,2),length(trial.itv));
  for tr=1:length(trial.itv)
    indx = find(ismember(spike.ind,unique(Ind(:,1))) & spike.good & WithinRanges(round(spike.t/RateFactor),trial.itv(tr,:)));
    [Tccg, t] = CCG(spike.t(indx),spike.ind(indx),50,200,20000);
    cells = unique(spike.ind(indx));
    for n=1:length(cells)
      Fccg.smccg(:,find(neurons==cells(n)),tr) = smooth(Tccg(:,n,n),20,'lowess');
    end
  end
  
  dires = [{find(trial.dir==2)},{find(trial.dir==3)}];
  for dire = 1:length(dires)
    for neu = 1:length(unique(Ind(:,1)))
      indx2 = tune.pftrspeed{neu,dire};
      %keyboard
      dd=dires{dire};
      Fccg.mccgF(:,neu,dire) = smooth(mean(Fccg.smccg(:,neu,dd(indx2(1:round(length(indx2)/2),2))),3),10,'lowess');
      Fccg.mccgS(:,neu,dire) = smooth(mean(Fccg.smccg(:,neu,dd(indx2(round(length(indx2)/2):end,2))),3),10,'lowess');
    end
  end

  %%% ccg of all spikes of fast/slow trials
  %for dire = 1:length(dires)
  %  goodtrials = 
  %  indx3 = find(ismember(spike.ind,unique(Ind(:,1))) & spike.good & WithinRanges(round(spike.t/RateFactor),trial.itv(tr,:)));
    
  
  save([FileBase '.xcorrel'],'Fccg');
else
  Fccg=load([FileBase '.xcorrel'],'-MAT');
end


if Plotting
  figure
  PlotCcg(Fccg.ccg, Fccg.ccgt);
  
  dires = [{find(trial.dir==2)},{find(trial.dir==3)}];
  for dire = 1:length(dires)
    figure
    for neu = 1:length(unique(PlaceCell.ind(:,1)))
      subplotfit(neu,length(unique(PlaceCell.ind(:,1))));
      indx = tune.pftrspeed{neu,dire};
      dd=dires{dire};
      imagesc(Fccg.ccgt,[1:length(indx)],unity(squeeze(Fccg.smccg(:,neu,dd(indx(:,2)))))');
    end
  end
  for dire = 1:length(dires)
    figure
    for neu = 1:length(unique(PlaceCell.ind(:,1)))
      subplotfit(neu,length(unique(PlaceCell.ind(:,1))));
      %PlotTraces([MeanCcgF MeanCcgS])
      %plot(t,(1-MeanCcgF/max(MeanCcgF))*length(indx),'g','LineWidth',2);
      %hold on;
      %plot(t,(1-MeanCcgS/max(MeanCcgS))*length(indx),'r','LineWidth',2);
      plot(Fccg.ccgt,unity(Fccg.mccgF(:,neu,dire)),'b','LineWidth',2);
      hold on;
      plot(Fccg.ccgt,unity(Fccg.mccgS(:,neu,dire)),'r','LineWidth',2);
      hold off;
      axis tight
      grid on
    end
  end
 
  
end

return;

%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%
  
  
  %% take ALL cells!! 
  for neu=1:length(PlaceCell)
    
    %% trials for cell 'neu'
    newtrials = PlaceCell(neu).trials;
    
    %% calculate speed and rate for each trial|neuron
    for n=1:length(newtrials)
      spindx = find(WithinRanges(spike.t/512,newtrials(n,:)) & spike.ind==PlaceCell(neu).ind(1));
      numspikes(n) = length(spindx);
      
      %% firing rate
      if numspikes<3
	trialspeed(n) =0;
      else
	%%% trial speed
	%if ~TrSpeed     %% over all speed
	%trialspeed(n) = mean(whl.speed([newtrials(n,1):newtrials(n,2)],1));
	%elseif TrSpeed  %% only speeds of spike time (no spike: NaN)
	trialspeed(n) = mean(whl.speed(round(spike.t(spindx)/512),1));
	%end
      end
    end
    %% find fast/med/slow trials
    prctrial = prctile(trialspeed(numspikes>3),[33 67])
    slowtr = trialspeed<prctrial(1) & numspikes>3;
    medtr = trialspeed>=prctrial(1)&trialspeed<prctrial(2)  & numspikes>3;
    fasttr = trialspeed>=prctrial(2)  & numspikes>3;

    %keyboard
    
    %% CCG for all cells    
    allSpikesS = find(WithinRanges(spike.t/512,newtrials(slowtr,:)));
    [ccgS, t] = CCG(spike.t(allSpikesS),spike.ind(allSpikesS),20*10,100,20000);
    allSpikesM = find(WithinRanges(spike.t/512,newtrials(medtr,:)));
    [ccgM, t] = CCG(spike.t(allSpikesM),spike.ind(allSpikesM),20*10,100,20000);
    allSpikesF = find(WithinRanges(spike.t/512,newtrials(fasttr,:)));
    [ccgF, t] = CCG(spike.t(allSpikesF),spike.ind(allSpikesF),20*10,100,20000);
    
    Tccg(neu).t = t;
    Tccg(neu).slow = ccgS;
    Tccg(neu).med = ccgM;
    Tccg(neu).fast = ccgF;
    
  end
    
  %save([FileBase '.trial.spect'],'Tccg');


  load([FileBase '.trial.spect'],'-MAT');

  
%% find all cells with enough spikes in firing field 'neu'
%clls = unique(spike.ind(allSpikesS)); 
%mycll = find(clls==PlaceCell(neu).ind(1));%%
%
%if PLOT
%  figure(neu)
%  %% correlation
%  for n=1:length(clls)
%    subplotfit(n,length(clls))
%    if mycll<=n
%      bar(t,sq(ccg(:,mycll,n)));
%    else
%      bar(t,sq(ccg(:,n,mycll)));
%    end
%    title(['(' num2str(clls(n)) ') ' type{celltype(clls(n))}])
%    axis tight
%  end
%  %set(gcf,'Position',[5  9  1272  937])
%  %copyax('on')
% 
% if ALL%
%    figure(neu+100)
%    neutot = length(unique(spike.ind(allSpikes)));
%    for n=1:neutot
%      subplotfit(n,neutot)
%      bar(t,sq(ccg(:,n,n)));
%      title(['(' num2str(clls(n)) ') ' type{celltype(clls(n))}]);
%      axis tight
%    end
%  end
%end

figure
%% correlation
for n=1:length(clls)
  subplotfit(n,length(clls))
  if mycll<=n
    bar(t,sq(ccg(:,mycll,n)));
  else
    bar(t,sq(ccg(:,n,mycll)));
  end
  title(['(' num2str(clls(n)) ') ' type{celltype(clls(n))}])
  axis tight
end
set(gcf,'Position',[5  9  1272  937])
%copyax('on')

%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%

RateFactor = 20000/whl.rate;
Ind = PlaceCell.ind;
neurons = unique(Ind(:,1));
Trials = PlaceCell.trials;

%% take all good spikes:
aindx = ismember(spike.ind,unique(Ind(:,1))) & spike.good & WithinRanges(round(spike.t/RateFactor),trial.itv);

gspiket = spike.t(aindx);
gspikeind = spike.ind(aindx);
[ccg, t] = CCG(gspiket,gspikeind,30,50,20000);

for n=1:length(neurons)
  %figure
  for nn=1:length(neurons)
    subplotfit(nn,length(neurons))
    bar(t,ccg(:,n,nn))
    xlim([-50 50]);
    title([num2str(n) ' || ' num2str(nn)]);
  end
  waitforbuttonpress
end


for n=1:length(neurons)
  clf
  for dire=[2 3]
    subplot(1,2,dire-1)
    indx = aindx & spike.ind==neurons(n) & spike.dir==dire;
    plot(spike.lpos(indx),spike.ph(indx),'.')
    hold on
    plot(spike.lpos(indx),spike.ph(indx)+2*pi,'.')
    plot(spike.lpos(indx),spike.ph(indx)+4*pi,'.')
    title([num2str(n) ': ' num2str(neurons(n)) ' | ' num2str(dire)]);
  end
  waitforbuttonpress
end
