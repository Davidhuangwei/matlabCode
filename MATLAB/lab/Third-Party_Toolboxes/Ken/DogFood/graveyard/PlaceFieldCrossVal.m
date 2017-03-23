% PlaceFieldCrossVal(Res, Whl, Params)
%
% Experimental function to evaluate the fit of a place field by 
% cross-validation.

function PlaceFieldCrossVal(Res, Whl, Params)

Shrink = 8; % how much to divide Whl by before binning
sRatio = 32*16; % sampling rate ratio (Res file over Wheel file)
dt = sRatio/20000; % time for one whl file sample

WhlFileLen = size(Whl, 1);

WhlHalfTime = ceil(WhlFileLen/2);
ResHalfTime = sRatio*WhlHalfTime;

Whl1 = Whl(1:WhlHalfTime,:);
Whl2 = Whl(WhlHalfTime+1:end,:);
Res1 = Res(find(Res<=ResHalfTime));
Res2 = Res(find(Res>ResHalfTime))-ResHalfTime;

subplot(2,1,1);
Map1 = PlaceField(Res1, Whl1, Params);
subplot(2,1,2);
Map2 = PlaceField(Res2, Whl2, Params);

return

NotOccluded1 = find(Whl(:,1)>=0);
Traj1x = 1+floor(Whl(NotOccluded1,1)/Shrink); % trajectory of non-occluded ...
Traj1y = 1+floor(Whl(NotOccluded1,2)/Shrink); % stuff in Map coordinates

GoodTimes = find(Res<size(Whl,1)*sRatio); times for which whl file is there
SpkPos = Whl(1+floor(Res(GoodTimes)/sRatio),:); %position in Whl units
% find those that are not occluded
NotOccludedSpikes = find(SpkPos(:,1)>=0);
SpkPosNotOcc = SpkPos(NotOccludedSpikes,1:2); % positions of non-occluded spikes

LogL = dt*sum(Map1(sub2ind(size(Map1), Traj1x, Traj1y)));

dbstop

return

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
sTimeSpent = conv2(TimeSpent, Smoother, 'same');
snSpikes = conv2(nSpikes, Smoother, 'same');


% compute firing rate and gray out zero bits (places the rat never went)
ZeroBits = find(sTimeSpent<TimeThresh);
FireRate = WhlFileSampRt*snSpikes./(sTimeSpent+eps);
FireRate(ZeroBits) = 0;

% and smooth it again
sFireRate = conv2(FireRate, Smoother, 'same');

% make color map
numcolor = 63;
PlaceMap = floor(numcolor*sFireRate/(max(sFireRate(:))+eps))+2;
PlaceMap(ZeroBits) = 1;


if 0
im = image(PlaceMap');
cbar = colorbar;
% set up plot colors and stuff - cribbed from Haj
plcolormap = jet(numcolor+1);
plcolormap(1,:) = [.7,.7,.7];
set(gcf,'Colormap',plcolormap);
set(cbar,'YTick', (0:.25:1)*numcolor);
set(cbar, 'YTickLabel', round((0:25:100)*max(sFireRate(:)))/100);
set(gca, 'XTick', []);
set(gca, 'YTick', []);
else
1234
Hue = sFireRate/(max(sFireRate(:))+eps);
Sat = sTimeSpent/(max(sTimeSpent(:))+eps);
Val = ones(size(Hue));
image(hsv2rgb([Hue Sat Val]));
end

if nargout>=1
	Map = sFireRate;
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