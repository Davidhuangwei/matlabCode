% [Map Info] = PlaceField(Res, Whl, Params)
%
% draws a nice little place field map
% Whl is assumed at 32*16 times slower sampling than Res.
% They must both start at 0!
%
% optional outputs: Map - firing rate map
% Info - information measure a la Skaggs
%
% optional Params input - {Shrink, xMax, yMax, Smoother, TimeThresh}

function [Map, Info] = PlaceField(Res, Whl, Params)

%% PARAMETERS
sRatio = 32*16; % sampling rate ratio (Res file over Wheel file)
WhlFileSampRt = 20000/sRatio;
TimeThresh = 0; % any less than this time in a place, and it doesn't count
Shrink = 8; % how much to divide Whl by before binning
xMax = 42; % size of output array
yMax = 31; % size of output array
MaxFireRate = 30;
% filter for smoothing
%Smoother = ones(3)/9;
Smoother = 1;

if nargin>=3
	Shrink = Params{1};
	xMax = Params{2};
	yMax = Params{3};
	Smoother = Params{4};
	TimeThresh = Params{5};
	
end

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

% Make Grids


% compute how much time the rat spent in the various locations
% uses a sparse matrix - vectorize or die
NotOccluded = find(Whl(:,1)>=0);
TimeSpent = full(sparse( ...
				1+floor(Whl(NotOccluded,1)/Shrink), ...
				1+floor(Whl(NotOccluded,2)/Shrink), ...
				1, xMax, yMax) ...
			);

% compute rat position for each spike
GoodTimes = find(Res<size(Whl,1)*sRatio);
Pos = Whl(1+floor(Res(GoodTimes)/sRatio),:);
% find those that are not occluded
NotOccludedSpikes = find(Pos(:,1)>=0);

% and bin spikes
nSpikes = full(sparse(...
				1+floor(Pos(NotOccludedSpikes,1)/Shrink), ...
				1+floor(Pos(NotOccludedSpikes,2)/Shrink), ...
				1, xMax, yMax)...
			);


% smooth them
if min(size(Smoother)) == 1
	% 1d smoother
	sTimeSpent = conv2(Smoother, Smoother, TimeSpent, 'same');
	snSpikes = conv2(Smoother, Smoother, nSpikes, 'same');
else
	% 2d smoother
	sTimeSpent = conv2(TimeSpent, Smoother, 'same');
	snSpikes = conv2(nSpikes, Smoother, 'same');
end

% compute firing rate and gray out zero bits (places the rat never went)
ZeroBits = find(sTimeSpent<TimeThresh);
FireRate = WhlFileSampRt*snSpikes./(sTimeSpent+eps);
FireRate(ZeroBits) = 0;

% and smooth it again - NOT
%sFireRate = conv2(FireRate, Smoother, 'same');
sFireRate = FireRate;

% make color map
numcolor = 63;
PlaceMap = floor(numcolor*sFireRate/(max(sFireRate(:))+eps))+2;
PlaceMap(ZeroBits) = 1;


if nargout>=1
	Map = sFireRate;
else	
	% plot map

	if 1 % traditional place field map
	im = image(PlaceMap');
	set(gca, 'XTick', []);
	set(gca, 'YTick', []);
	cbar = colorbar;

	% set up plot colors and stuff - cribbed from Haj
	plcolormap = jet(numcolor+1);
	plcolormap(1,:) = [.7,.7,.7];
	set(gcf,'Colormap',plcolormap);
	set(cbar,'YTick', (0:.25:1)*numcolor);
	set(cbar, 'YTickLabel', round((0:25:100)*max(sFireRate(:)))/100);

	else % hsv map
	%Hsv(:,:,1) = (2/3) - (2/3)*sFireRate'/(max(sFireRate(:))+eps);
	Hsv(:,:,1) = (2/3) - (2/3)*sFireRate'/MaxFireRate;
	Hsv(:,:,2) = (sTimeSpent'/(max(sTimeSpent(:))+eps)).^.35;	
	Hsv(:,:,3) = ones(size(sFireRate'));
	image(hsv2rgb(Hsv));
	end
end


if nargout>=2
	% compute information measure
	LocProb = sTimeSpent/WhlFileLen;
	MeanFireRate = WhlFileSampRt * sum(snSpikes(:)) / sum(sTimeSpent(:));
	LogArg = FireRate(:)/MeanFireRate;
	LogArg(find(LogArg==0)) = 1;
	Info = sum(FireRate(:).*log2(LogArg).*LocProb(:)) / MeanFireRate;
	% firing rate not smoothed twice.
end