function trial = GetMeanTrial(FileBase,trial,whl,varargin)
[overwrite] = DefaultArgs(varargin,{0});
%%
%% get mean occupancy in maze for
%%    ALL trials if OneMeanTrial = 1
%%    EACH DIRECTION if OneMeanTrial = 0
%% 

%% in case field OneMeanTrial exists
if isfield(trial,'OneMeanTrial') 
  if isempty(trial.OneMeanTrial)
    makemean=1;
  else
    makemean=0;
  end
end
  
%% get mean trial
if ~isfield(trial,'OneMeanTrial') | ~isfield(trial,'mean') | makemean | overwrite
  
  %% get OneMeanTrial boolian
  trial.OneMeanTrial = input('One mean trace [1] or many [0]? '); 
  
  %% initialize subfield 'mean'
  trial = setfield(trial,'mean',[]);
  
  if ~trial.OneMeanTrial 
 
    for n=unique(trial.dir)'
      if n>1
	[trial.mean(n).mean trial.mean(n).lin] = FindMainTrajNEW(trial.itv(find(trial.dir==n),:),whl.ctr);
      else
	continue;
      end
    end
  
  else
    [foo bah] = FindMainTrajNEW(trial.itv(find(trial.dir>1),:),whl.ctr);
    for n=unique(trial.dir)'
      if n>1
	trial.mean(n).mean = foo;
	trial.mean(n).lin = bah;
      else
	continue;
      end
    end
  end
  
  save([FileBase '.trials'],'trial');
end  

return;
