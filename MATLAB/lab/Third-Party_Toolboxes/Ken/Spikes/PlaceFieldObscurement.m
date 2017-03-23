% [ResGood, WhlGood] = PlaceFieldObscurement(Res, Whl, Params)
%
% subfunction for PlaceField that calculates which wheel file samples
% and which spikes should be used in place field calculation.
%
% Wheel file samples are not used if the camera wasn't working
% near the time of the spike, or if the rat's velocity was too small.
% Spikes are not used if they don't fall into good wheel file samples

function [ResGood, WhlGood] = PlaceFieldObscurement(Res, Whl, Params)

%% PARAMETERS
sRatio = 32*16; % sampling rate ratio (Res file over Wheel file)
WhlFileSampRt = 20000/sRatio;
TimeThresh = 1; % any less than this time in a place, and it doesn't count
Shrink = 8; % how much to divide Whl by before binning
xMax = 42; % size of output array
yMax = 31; % size of output array
MaxFireRate = 30;
Smoother = 1;
VelThresh = 0.2;

if nargin>=3
	Shrink = Params{1};
	xMax = Params{2};
	yMax = Params{3};
	Smoother = Params{4};
	TimeThresh = Params{5};
	VelThresh = Params{6};
	
end

dWhl = Derivative(Whl(:,1:2));
Vel = sqrt(sum(dWhl.*dWhl, 2));
dChk = Derivative(rand(size(Whl,1), 1).*(Whl(:,1)<0));
VelGood = (dChk==0 & Whl(:,1)>=0); % this will be non-zero if any Whl in the filter region are <0


if (VelThresh >= 0) % 	positive VelThresh sets lower limit for velocity
	WhlGood = VelGood & (Vel>VelThresh);
else
	WhlGood = VelGood & (Vel<-VelThresh);
end

% compute rat position for each spike

SpikeTime = 1+floor(Res/sRatio); % in whl file units

% sanity check
if any(diff(Res)<0)
	error('Res input must be increasing!\n');
end

% find spikes which occur before the end of wheel file
LastSpike = sum(SpikeTime<=size(Whl,1));

ResGood = zeros(size(Res));
ResGood(1:LastSpike) = WhlGood(SpikeTime(1:LastSpike));

%fprintf('%d out of %d spikes good\n', sum(ResGood), length(Res));