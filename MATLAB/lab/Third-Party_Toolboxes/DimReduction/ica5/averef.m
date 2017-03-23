% averef() - convert common-reference EEG data to average reference
%
% Usage:
%          >> data = averef(data);
%
% data is (chans,frames*epochs) EEG or MEG data

% Scott Makeig, CNL / Salk Institute, La Jolla CA 11/99
% 12/16/99 Corrected denomiator on the suggestion of Ian Nimmo-Smith, Cambridge UK

function data = averef(data)

if nargin<1
  help averef
  return
end
chans = size(data,1);
if chans < 2 
  help averef
  return
end

% avematrix = eye(chans)-ones(chans)*1/chans;
% data = avematrix*data; % implement as a matrix multiply
% else (faster?)

  data = data - ones(chans,1)*sum(data)/chans;

