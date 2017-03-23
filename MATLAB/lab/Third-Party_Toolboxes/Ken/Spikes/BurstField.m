% Map = BurstField(Res, Whl, Params)
%
% calculates the fraction of ISIs that are under 6ms as a function of position.
% Whl is assumed at 32*16 times slower sampling than Res.
% They must both start at 0!
%
% optional outputs: Map - firing rate map
%
% optional Params input - {Shrink, xMax, yMax, Smoother, TimeThresh, VelThresh}

function [Map, Info] = BurstField(Res, Whl, Params)


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


% Find short ISIs
ISI = diff(Res)/20;
PrevISI = [inf; ISI];
NextISI = [ISI; inf];
BurstRes = Res(find(NextISI<6));

% compute smoother
FilterSize = ceil(max(xMax, yMax)/2);

% Smoother - if length 1 do single Gaussian of that size
% else just normalize it
if (length(Smoother) == 1)
	Smoother = exp(-(-FilterSize:FilterSize).^2/(2*Smoother.^2));
end;	
Smoother = Smoother/sum(Smoother(:));

WhlFileLen = size(Whl, 1);


% do input checks

if any(Whl ~= floor(Whl))
	error('Whl does not consist of integers!');
end

% find obscured positions
if (nargin>=3)
	[ResGood, WhlGood] = PlaceFieldObscurement(Res, Whl, Params);
	[BurstResGood, WhlGood] = PlaceFieldObscurement(BurstRes, Whl, Params);
else
	[ResGood, WhlGood] = PlaceFieldObscurement(Res, Whl);
	[BurstResGood, WhlGood] = PlaceFieldObscurement(BurstRes, Whl);
end

% compute rat position for each spike
SpikeTime = 1+floor(Res(find(ResGood))/sRatio); % in whl file units
BurstTime = 1+floor(BurstRes(find(BurstResGood))/sRatio); % in whl file units

Pos = Whl(SpikeTime,:);

% bin spikes
nSpikes = full(sparse(...
				1+floor(Whl(SpikeTime,1)/Shrink), ...
				1+floor(Whl(SpikeTime,2)/Shrink), ...
				1, xMax, yMax)...
			);

% bin bursts
nBursts = full(sparse(...
				1+floor(Whl(BurstTime,1)/Shrink), ...
				1+floor(Whl(BurstTime,2)/Shrink), ...
				1, xMax, yMax)...
			);

% smooth them
if min(size(Smoother)) == 1
	% 1d smoother
	snSpikes = conv2(Smoother, Smoother, nSpikes, 'same');
	snBursts = conv2(Smoother, Smoother, nBursts, 'same');
else
	% 2d smoother
	snSpikes = conv2(nSpikes, Smoother, 'same');
	snBursts = conv2(nBursts, Smoother, 'same');
end

% compute firing rate and gray out places the rat never went
ZeroBits = find(snSpikes<.2);
BurstFrac = snBursts./snSpikes;
BurstFrac(ZeroBits) = 0;

if nargout>=1
	Map = BurstFrac;
else	
	% plot map

	% make color map
	numcolor = 63;
%	PlaceMap = floor(numcolor*BurstFrac/max(BurstFrac(:)))+2;
	PlaceMap = floor(numcolor*BurstFrac)+2;
	PlaceMap(ZeroBits) = 1;
	
	image(PlaceMap');
	set(gca, 'XTick', []);
	set(gca, 'YTick', []);
	cbar = colorbar;

	% set up plot colors and stuff - cribbed from Haj
	plcolormap = jet(numcolor+1);
	plcolormap(1,:) = [.7,.7,.7];
	set(gcf,'Colormap',plcolormap);
%	set(cbar,'YTick', (0:.25:1)*numcolor);
%	set(cbar, 'YTickLabel', round((0:25:100)*max(FireRate(:)))/100);
	set(cbar,'YTick', [1 numcolor]);
%	lab = [0, max(BurstFrac(:))];
	lab = [0, 1];
		set(cbar, 'YTickLabel', lab);
	
end

return

if nargout>=2
	% compute information measure
	LocProb = sTimeSpent/sum(sTimeSpent(:));
	MeanFireRate = WhlFileSampRt * sum(snSpikes(:)) / sum(sTimeSpent(:));
	LogArg = FireRate(:)/MeanFireRate;
	LogArg(find(LogArg==0)) = 1;
	Info = sum(LogArg.*log2(LogArg).*LocProb(:));
	
%   alternative CoV measure
%	Info = sqrt(sum((LogArg).^2.*LocProb(:)) - sum(LogArg.*LocProb(:)).^2);
%	subplot(3,2,5);
%	imagesc(FireRate'/MeanFireRate);
%	fprintf('info %f\n', Info);
%	pause
end
