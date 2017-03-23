%
% abspeak() - find peak amps/latencies in each row of a single-epoch data matrix 
%
% Usage:
%        >> [amps,frames,signs] = abspeak(data);
%        >> [amps,frames,signs] = abspeak(data.frames);
%
%   frames - frames per epoch in data {default|0 -> whole data}

% Scott Makeig, CNL / Salk Institute, La Jolla
% 3-9-98 added frames arg -sm

function [amps,frames,signs]= abspeak(data,fepoch);

if nargin < 1
  help abspeak
  return
end

[chans,ftot] = size(data);
if nargin < 2
  fepoch = 0;
end
if fepoch == 0
  fepoch = ftot;
end
epochs = floor(ftot/fepoch);
if fepoch*epochs ~= ftot
   fprintf('asbpeak(): frames arg does not divide data length.\n')
   return
end

amps   = zeros(chans,epochs);
frames = zeros(chans,epochs);
signs  = zeros(chans,epochs);

for e=1:epochs
  for c=1:chans
    dat = abs(matsel(data,fepoch,0,c,e))';
    [sdat,si]   = sort(dat);
    amps(c,e)   = dat(si(fepoch));           % abs value at peak
    frames(c,e) = si(fepoch);                % peak frame
    signs(c,e)  = sign(data(c,frames(c,e))); % sign at peak
  end
end
