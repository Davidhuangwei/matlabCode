function Speed = RateVsSpeed(FileBase,whl,trial,spike,PlaceCell,varargin)
[SpikeThr,overwrite] = DefaultArgs(varargin,{3,0});

RateFactor = 20000/whl.rate;

if ~FileExists([FileBase '.ratespeed']) | overwrite
  
  CatPlaceCell = CatStruct(PlaceCell);
  
  count = 0;
  for neu=1:length(CatPlaceCell.indall)
    if CatPlaceCell.indall(5,neu) ~= 1
      continue
    end
    
    fprintf([num2str(neu) '... ']);
    
    dire = CatPlaceCell.indall(4,neu);
    for dd = 1:size(PlaceCell(neu).lfield,1)
      
      count = count+1;
      Speed(count).ind = [neu dire dd];
      
      trials = trial.itv(find(trial.dir==dire),:);
      
      indx1 = (spike.ind==CatPlaceCell.indall(1,neu) & spike.good & WithinRanges(spike.lpos,PlaceCell(neu).lfield(dd,:)));
       
      for tr=1:length(trials)
	
	%keyboard

	goodspikes = find(indx1 & WithinRanges(round(spike.t/RateFactor),trials(tr,:)));
	
	if length(goodspikes)<SpikeThr
	  continue;
	else
	  
	  %% Spike Count
	  Speed(count).spikes(tr) = length(goodspikes);
	  
	  %% ave Speed of each trial in PF from whl.speed
	  whlidx = WithinRanges(whl.lin,PlaceCell(neu).lfield(dd,:)) & WithinRanges(find(whl.ctr(:,1)),trials(tr,:));
	  Time = length(find(whlidx))/whl.rate;
	  
	  Speed(count).whl(tr) = mean(whl.speed(find(whlidx),1));
	  Speed(count).lwhl(tr) = abs(diff(PlaceCell(neu).lfield(dd,:)))/Time;
	  
	  %% av. Speed of each spike time in trial 
	  Speed(count).speed(tr) = mean(whl.speed(round(spike.t(goodspikes)/20000*whl.rate),1));
	  
	  %% av. Rate during trial
	  Speed(count).rate(tr) = length(goodspikes)/Time;
	  
	  %% TUNING CURVES:
	  %Speed(count).
	  	  
	end
      end
    end
  end
  save([FileBase '.ratespeed'],'Speed')
else
  Speed = load([FileBase '.ratespeed'],'-MAT');
end


return;
