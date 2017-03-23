function spike=FindGoodTheta(FileBase,spike,varargin);
[overwrite] = DefaultArgs(varargin,{0});
fprintf('  find theta episodes....\n');


Par = LoadPar([FileBase '.xml']);
RateFact = Par.SampleRate/Par.lfpSampleRate;

if ~FileExists([FileBase '.sts.ask']) | overwrite
  ask = input('Do you want to select good theta periods [0/1]? ');
  msave([FileBase '.sts.ask'],ask);
end
SelectGoodTheta = load([FileBase '.sts.ask']);
if SelectGoodTheta
  load([FileBase '.elc'],'-MAT');
  if ~FileExists([FileBase '.sts.states']) | overwrite
    states = input('Which states to divide {give as cell array}? ');
    save([FileBase '.sts.states'],'states','-MAT');
  else
    load([FileBase '.sts.states'],'-MAT');
  end
  for sts=1:length(states)
    if ~FileExists([FileBase '.sts.' states{sts}]) | overwrite
      CheckEegStates(FileBase,states{sts},[],[1 100],elc.theta,1);
      go = input('go? ');
    end
    newstats = load([FileBase '.sts.' states{sts}]);
    goodspikes = WithinRanges(round(spike.t/RateFact),newstats);
    spike = setfield(spike,states{sts},goodspikes);
  end
  %% the old good - because many programms are using this
  %% assumes that, if existing, the first state is 'RUN'
  oldgood = load([FileBase '.sts.' states{1}]);
  spike.good = WithinRanges(round(spike.t/RateFact),oldgood);
else
  %for sts=1:length(states)
  %  spike = setfield(spike,states{sts},ones(length(spike),1));
  %end
  spike.good = ones(length(spike.t),1);
end
