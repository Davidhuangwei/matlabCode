% [PlaceMap, OccupancyMap] = PlaceField(Res, Whl, EnvSize, Smooth, nGrid, Dir, TopRate)
%
% New and (hopefully) improved place field program.
% Whl is assumed at 512 times slower sampling than Res.
% i.e. it only works at 20kHz. WATCH OUT! (outputs are in Hz and seconds)
%
% EnvSize gives size of room in .whl units. room is assumed square (default 350).
% Smooth gives smoothing width in .whl units (default 10)
% nGrid is size of output grid (only affects display - default 64)
%
% if you have a 4 column wheel file (see WhichWayGeorge), then
% Dir allows you to specify direction +1 or -1. [] for either way.
% if you specify 3, it outputs a 3d array giving both.
%
% optional outputs: Map - firing rate map
%
% Optional argument TopRate is top firing rate of color map
%
% see also PFClassic

function [PlaceMap, OccupancyMap, TopRate] = myPlaceField(Res, Whl, varargin)
[EnvSize, Smooth, nGrid, Dir, TopRate,WhlRate] = DefaultArgs(varargin,{300,10,64,[],[],39.0625});

if ~isempty(Dir) & Dir==3
    [PlaceMap(:,:,1), OccupancyMap(:,:,1)] = NuPlaceField(Res, Whl, EnvSize, Smooth, nGrid, -1, TopRate);
    [PlaceMap(:,:,2), OccupancyMap(:,:,2)] = NuPlaceField(Res, Whl, EnvSize, Smooth, nGrid, 1, TopRate);
end

nWhl = size(Whl,1);

% if max(Whl(:))>EnvSize
%     error(sprintf('EnvSize is too small! for Whl value %d', max(Whl(:))));
% end
OutOfRange = find(any(Whl(:,1:2)>EnvSize, 2));
Whl(OutOfRange,:) = -1;
if ~isempty(OutOfRange)
    warning('Deleting Out of range elements!');
end


sRat = 20000/WhlRate; % sample rate converstion
if isempty(Res)
    SpkCnt = zeros(nWhl,1);
else
    SpkCnt = histc((Res-1)/sRat, 0:nWhl-1);
end

if size(Whl,2)>=4 & ~isempty(Dir)
    Good = find(Whl(:,1)>-1 & Whl(:,4)==Dir);
else
    if ~isempty(Dir)
        warning('Whl is not 4 columns. ignoring Dir argument');
    end
    Good = find(Whl(:,1)>-1);
end

sConv = WhlRate;
[PlaceMap, OccupancyMap] = myPFClassic(Whl(Good,1:2)/EnvSize, SpkCnt(Good), Smooth/EnvSize, nGrid, TopRate,WhlRate);
PlaceMap = PlaceMap * sConv;
OccupancyMap = OccupancyMap / sConv;
if nargout==0
    myPFPlot(PlaceMap, OccupancyMap, TopRate);
    %PFClassic(Whl(Good,1:2)/EnvSize, SpkCnt(Good), Smooth/EnvSize, nGrid, TopRate);
end

return



%%%%%%%%%%%%%%%%%%%%%%




if nargout>=1
	Map = FireRate;
else	
	% plot map

	% make color map
	numcolor = 63;
	PlaceMap = floor(numcolor*FireRate/(max(FireRate(:))+eps))+2;
	PlaceMap(ZeroBits) = 1;
	
	if 1 % traditional place field map
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
	lab = {'0 Hz', sprintf('%.1f', max(FireRate(:)))};
	set(cbar, 'YTickLabel', lab);
	
	else % hsv map
	Hsv(:,:,1) = (2/3) - (2/3)*FireRate'/(max(FireRate(:))+eps);
	%Hsv(:,:,1) = (2/3) - (2/3)*FireRate'/MaxFireRate;
	Hsv(:,:,3) = (sTimeSpent'/(max(sTimeSpent(:))+eps)).^.35;	
	Hsv(:,:,2) = ones(size(FireRate'));
	image(hsv2rgb(Hsv));
	end
end


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
