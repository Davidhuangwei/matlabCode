% ph = Phase(Res, Theta, MaxPeriod)
%
% calculates phase relative to theta rhythm
% Inputs - Res = times of spikes (ie .res file)
%          Theta = times of theta troughs (ie .theta file)
%          MaxPeriod = maximum theta period not to be ignored
%                      (default 5000 = 250ms @ 20kHz)
%
% Res and Theta can be arrays or filenames
%
% output ph is 0..2*pi or -1 if phase cannot be calculated (because
% period exceeds MaxPeriod)

function ph = Phase(Res, Theta, MaxPeriod)

if (isstr(Res)) Res = load(Res); end
if (isstr(Theta)) Theta = load(Theta); end
if (nargin<3) MaxPeriod = 5000; end;

% preliminary array processing
Res = Res(:);
Theta = [-inf ; Theta(:) ; inf]; % surround by -inf and inf.
nSpikes = length(Res);
nTroughs = length(Theta);

% OK, here we go
% start by making combined array and sorting
[sorted index] = sort([Res ; Theta]);

% indicator variables showing what the type the entry is
TroughIndicator = (index>nSpikes);
ResIndicator= (index<=nSpikes);

% previous trough given by cumsum TroughIndicator (i.e. number of troughs previous)
TroughCount = cumsum(TroughIndicator); 
PrevTrough = TroughCount(ResIndicator);

% calculate periods (first and last will be inf)
ThetaPeriod = [diff(Theta)];

% find those that less than the prescribed maximum
ThetaPeriodGood = ThetaPeriod < MaxPeriod;

% initialize all phases to -1
ph = -ones(size(Res));

% Change all those that should be changed - after first trough and period in range
ToChange = find(ThetaPeriodGood(PrevTrough));
													
ph(ToChange) = 2*pi*(Res(ToChange)-Theta(PrevTrough(ToChange)))./ThetaPeriod(PrevTrough(ToChange));

