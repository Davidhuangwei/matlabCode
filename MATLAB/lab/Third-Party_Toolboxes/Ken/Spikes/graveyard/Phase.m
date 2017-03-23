% ph = Phase(Res, Theta, MaxPeriod)
%
% calculates phase relative to theta rhythm
% Inputs - Res = times of spikes (ie .res file)
%          Theta = times of theta troughs (ie .theta file)
%          MaxPeriod = maximum theta period not to be ignored
%                      (default 3000 = 150ms @ 20kHz)
%
% Res and Theta can be arrays or filenames
%

function ph = Phase(Res, Theta, MaxPeriod)

if (isstr(Res)) Res = load(Res); end
if (isstr(Theta)) Theta = load(Theta); end
if (nargin<3) MaxPeriod = 3000; end;

% OK, here we go
% start by making combined array and sorting
[sorted index] = sort([Res ; Theta]);

% now we want to find the previous theta trough for each 