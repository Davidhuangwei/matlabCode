%function [st] = StimExclude(FileBase,N)
%
%
% Select the events corresponding to the stimmulation. 
% returns a vector containing the vector indices of the eeg with
% intervals around the stimulation of size N  


function [st] = StimExclude(FileBase,N)


FileBase = 'CS090302';

stimnum = 88;  %88 identifies the stimulation

events=load(['../video+events/' FileBase '.evt']);

stim = events(find(events(:,2)==88));

nstim = [];

for i=1:length(stim)
  nstim(:,i) = [stim(i)-round(N*0.25):stim(i)+round(N*0.75)];
end

st = reshape(nstim,[],1);

