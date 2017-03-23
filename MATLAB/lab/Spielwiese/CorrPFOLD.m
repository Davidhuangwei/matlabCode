function Tccg=CorrPF(FileBase,PlaceCell,whl,spike,varargin)
[celltype,ALL,REPFIG,PLOT,overwrite] = DefaultArgs(varargin,{[],1,0,0,0});

%% Auto- and  Cross-Correlogramm during trial
%% 

if ~FileExists([FileBase '.xcorrel']) | overwrite
  
  if ~isempty(celltype)
    % IN = celltype==1;
    % PC = celltype==2;
    % UN = celltype==3;
    type = {'Interneuron', 'Pyramidal Cell', 'Unknown'}; 
  else
    celltype = ones(length(unique(spike.ind)),1);
    type = {'NaN' 'NaN' 'NaN'};
  end
  
  
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
    
  save([FileBase '.trial.spect'],'Tccg');

else

  load([FileBase '.trial.spect'],'-MAT');

end
  
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


return;



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

