function PlaceCell=FindPlaceFieldsAllTest(FileBase, spike, whl, trial, states, varargin)
[overwrite] = DefaultArgs(varargin,{0});
%%
%% returns structure with one entry per place field (PF). 
%%
%% PlaceCell.ind = [cell cluster electrode dir celltype]; cell identification for each (PF)
%% PlaceCell.lfield = [begin end]; beginning and and of PFs in linearized coordinates.
%% PlaceCell.trials = [neuron begin end]; beginning and and of PFs in whl samples.
%%

fprintf('  find place fields....\n');

RateFactor = 20000/whl.rate;

if ~FileExists([FileBase '.PlaceCellAll']) | overwrite

  figure
  
  %% loop through cells
  count = 0;                     %% count place fields
  neurons = unique(spike.ind);   %% neuron numbers
  direct = unique(spike.dir);    %% direction numbers
  field = 0;                     %% counts place fields
  atrials = [];

  
  sts = 0;
  visited = [];
  allsts = [1:length(states.ind)];
  while sts<length(states.ind)
    sts = sts+1;
    notvisited = min(allsts(~ismember(allsts,visited)));
    
    if states.ind(notvisited)==1
      visited = [visited notvisited]
      continue
    end
    
    %%% ask: combine same-state-sessions? 
    fprintf([states.info{states.ind(sts)} '\n']);
    ask = input('Do you want to combine all sessions of this kind into one [0/1]? ');
    if ask
      goodsegs = find(states.ind==states.ind(sts));
      sts = sts+length(goodsegs)-1; 
      visited = [visited goodsegs]
    else
      visited = [visited notvisited]
    end
    
  end
  
end
