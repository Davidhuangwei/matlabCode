function  Eeg = GetEEG(FileBase,varargin)
[epochs] = DefaultArgs(varargin,{[]});

if ~FileExists([FileBase '.elc'])
  elc = InternElc(FileBase);
  %error('no channel for theta phase detection is specified.\n');
else
  load([FileBase '.elc'],'-MAT');
end
Par = LoadPar([FileBase '.par']);
%Eeg = readsinglech([FileBase '.eeg'],Par.nChannels,elc.theta);
Eeg = LoadBinary([FileBase '.eeg'],elc.theta,Par.nChannels,[],[],[],epochs);

return;
