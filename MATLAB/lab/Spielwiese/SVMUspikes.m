%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% get the spikes!
[spike.t, spike.ind, spike.pos, numclus, xspikeph, spike.clu] = SpikePos(FileBase,[],WhlRate,1,SampleRate);

%% get spikes in theta periods
spike = FindGoodTheta(FileBase,spike);

%% take spikes only during track running
gst = find(ismember(states.ind,[2 4 23]));
in = WithinRanges(round(spike.t/SampleRate*states.rate),states.itv(gst,:));
spike.good = spike.good.*in;

if unique(spike.good)==0
  fprintf('for some reason: there are no good spikes. set all spikes to good.')
  spike.good = spike.good+1;
end

%% get spike phase
%% -- THIS NEEDS SOME WORK! IDEALLY IT SHOULD BE COMPUTED WITH
%% -- ADAPTIVE FILTER!
%% -- [spike.ph spike.uph] = SpikePhaseAdapt(FileBase,spike.t,SampleRate,EegRate);
[spike.ph spike.uph] = SpikePhase(FileBase,spike.t,SampleRate,EegRate);

%% give file label to each neuron
ALL(f).file = repmat(f,size(spike.clu,1),1);

