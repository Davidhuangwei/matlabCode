function Speed=RateVsSpeedOLD(FileBase,whl,trial,spike,PlaceCell,varargin)
[SpikeThr,TrSpeed,overwrite] = DefaultArgs(varargin,{3,0,1});

%% Calculate speed foreach trial of each place field.
%% 2 methods: (1) take average speed from whl.speed
%%            (2) take 
%%
%% spikethr: threshold for min number of spikes in trial
%% TrSpeed:  0: average speed over whole trial
%%           1: average speed over all spikes of trial
%%
%%  Rate(neu).slope:  slope of lin regression (rate,speed) 
%%  Rate(neu).b:      constant offset
%%  Rate(neu).stat:   stats: 
%%
%% -caroline.

RateFactor = 20000/whl.rate;

%if ~FileExists([FileBase '.rate']) | overwrite
  
  CatPlaceCell = CatStruct(PlaceCell);
  
  count = 0;
  for neu=1:length(CatPlaceCell.indall)
    if CatPlaceCell.indall(5,neu) ~= 1
      continue
    end
    
    dire = CatPlaceCell.indall(4,neu);
    for dd = 1:size(PlaceCell(neu).lfield,1)
      
      count = count+1;
      Speed(count).ind = [neu dire dd];
      
      trials = trial.itv(find(trial.dir==dire),:);
      for tr=1:length(trials)
	
	%keyboard
	indx1 = WithinRanges(spike.lpos/RateFactor,PlaceCell(neu).lfield(dd,:)) & WithinRanges(round(spike.t/RateFactor),trials(tr,:));
	indx2 = spike.ind==CatPlaceCell.indall(1,neu) & spike.good;
	goodspikes = find(indx1 & indx2);
	
	Speed(count).spikes(tr) = length(goodspikes);
	
	%% ave Speed of each trial in PF from whl.speed
	whlidx = WithinRanges(whl.lin,PlaceCell(neu).lfield(dd,:)) & WithinRanges(find(whl.ctr(:,1)),trials(tr,:));
	Time = length(find(whlidx))/whl.rate;
	Speed(count).whl(tr) = mean(whl.speed(find(whlidx),1));
	Speed(count).lwhl(tr) = abs(diff(PlaceCell(neu).lfield(dd,:)))/Time;
	
	%% av. Speed of each spike time in trial 
	if length(goodspikes)>2
	  Speed(count).speed(tr) = mean(whl.speed(round(spike.t(goodspike)/20000*whl.rate),1));
	else
	  Speed(count).speed(tr) = NaN;
	end
	
	%% av. Rate during trial
	%% time spend in place field:
	if length(goodspikes)>2
	  Speed(count).rate(tr) = length(goodspikes)/Time;
	else
	  Speed(count).rate(tr) = 0;
	end
	
      end
    end
  end
%end
%Speed = load(

%Speed = 1;

return;


  %figure(100)
  %col = colormap;
  %pcol(1) = 1;
  %pcol(2:length(CatPlaceCell.ind)-1) = [1:length(CatPlaceCell.ind)-2]*round(64/length(CatPlaceCell.ind));
  %pcol(find(pcol>64)) = 64;
  %pcol(length(CatPlaceCell.ind)) = 64;
  
  %cellclu = spike.clu(CatPlaceCell.indall(1,neu),:); 
  
  %WithinRanges(spike.lpos,PlaceCell(neu).lfield(dd,:)) & WithinRanges(round(spike.t/20000*whl.rate),trials(tr,:))
  %spindx = find(WithinRanges(spike.lpos/RateFactor,newtrials(n,:)) & spike.ind==PlaceCell(neu).indall(1) & spike.good);
  %numspikes(n) = length(spindx);
  
  %% firing rate
  %if length(spindx)>SpikeThr
  %  rate(n) = 1/mean(diff(spike.t(spindx)/20000));
  %else
  %  rate(n) = 0;
  %end
  
  %% trial speed
  %trialspeed(n,1) = mean(whl.speed([newtrials(n,1):newtrials(n,2)],1));
  %if ~isempty(spindx)
  %  trialspeed(n) = mean(whl.speed(round(spike.t(spindx)/RateFactor),1));
  %else
  %  trialspeed(n) = 0;
  %end
  