function ConcatEegWhl(FileBase,list,varargin)
[RateFactor, WhilDim] = DefaultArgs(varargin,{1250/39.0625, 4});
%%
%% ConcatEegWhl(FileBase,list)
%%
%%  and whl from list
%% keeps timestamps of segments
%% asks for state specification


if ~FileExists([FileBase '.whl'])
  
  Par = LoadPar([FileBase '.par']);

  whl = [];
  for i=1:length(List)
    
    % states 
    nfilebase = [List{i} '/' List{i}]
    LL = FileLength([nfilebase '.eeg'])/2/Par.nChannels;
    
    st(i) = LL;
    %states.ind(i) = input('what state is this [1=sleep; 2=run-track; 3=run-openfield]? ')
    
    %% whl
    if ~FileExists([nfilebase '.whl'])
      whl = [whl; -ones(round(LL/RateFactor),WhilDim)];
    else
      whl = [whl; load([nfilebase '.whl'])];
    end
    
  end
  
  sst = cumsum(st);
  states.itv(1:i,1) = [1; sst(1:i-1)'+1];
  states.itv(1:i,2) = sst';
  
  states.info = {'1=sleep'; '2=run-track'; '3=run-openfield'};
  
  msave([FileBase '.whl'], whl)
end

return;