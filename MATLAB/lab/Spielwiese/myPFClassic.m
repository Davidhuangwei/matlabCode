% [PlaceMap, OccupancyMap] = PFClassic(Pos, SpkCnt, Smooth, nGrid, TopRate)
% Place field calculation "classic style" where a smoothed spike count map
% is divided by a smoothed occupancy map
%
% Pos is a nx2 array giving position in each epoch.  It should be in
% the range 0 to 1.  SpkCnt gives the number of spikes in each epoch.
%
% Smooth is the width of the Gaussian smoother to use (in 0...1 units).
%
% nGrid gives the grid spacing to evaluate on (should be larger than 1/Smooth)
%
% TopRate is for the maximum firing rate on the color map (if you display it)
% if you don't specify this it will be the maximum value
%
% optional output OccupancyMap is a smoothed occupancy map

function [PlaceMap, sTimeSpent] = myPFClassic(Pos, SpkCnt, Smooth, nGrid, TopRate,WhlRate)

% when the rat spends less than this many time points near a place,
% start to dim the place field
TimeThresh = 40;

% integrized Pos (in the range 1...nGrid
iPos = 1+floor(nGrid*Pos/(1+eps));

% make unsmoothed arrays
TimeSpent = full(sparse(iPos(:,1), iPos(:,2), 1, nGrid, nGrid));
nSpikes = full(sparse(iPos(:,1), iPos(:,2), SpkCnt, nGrid, nGrid));

% do the smoothing
r = (-nGrid:nGrid)/nGrid;
Smoother = exp(-r.^2/Smooth^2/2);

sTimeSpent = conv2(Smoother, Smoother, TimeSpent, 'same');
snSpikes = conv2(Smoother, Smoother, nSpikes, 'same');

PlaceMap = snSpikes./(sTimeSpent+eps);
% NB not regularized to be mean firing rate in non-visited areas.

if nargout==0
    %FireRate = PlaceMap*20000/512;
    FireRate = PlaceMap*WhlRate;
	%if nargin<5 
        %TopRate = [];
	%end
	PFPlot(PlaceMap, sTimeSpent, TopRate, TimeThresh);
end
%     if 0
%         colormap(gca, jet);
%         imagesc(PlaceMap);
%     else
%         FireRate = PlaceMap*20000/512;
%         %CoV = snSpikes.^-.5;
%         if nargin<5 | isempty(TopRate)
%             TopRate = max(FireRate(find(sTimeSpent>TimeThresh)));
%             if TopRate<1, TopRate=1; end;
%         end
%         if isempty(TopRate) TopRate = max(FireRate(:)); end;
%     	Hsv(:,:,1) = (2/3) - (2/3)*clip(FireRate'/TopRate,0,1);
%     	%Hsv(:,:,1) = (2/3) - (2/3)*FireRate'/MaxFireRate;
%     	%Hsv(:,:,3) = (sTimeSpent'/(max(sTimeSpent(:))+eps)).^.35;	
%         %Hsv(:,:,3) = 1./(1+CoV');
%         Hsv(:,:,3) = 1./(1+TimeThresh./sTimeSpent');
%     	Hsv(:,:,2) = ones(size(FireRate'));
%     	image(hsv2rgb(Hsv));
%         
%         % most annoying bit is colorbar
%         h = gca;
%         h2 = SideBar;
%         BarHsv(:,:,1) = (2/3) - (2/3)*(0:.01:1)';
%         BarHsv(:,:,2) = ones(101,1);
%         BarHsv(:,:,3) = ones(101,1);
%         image(0,(0:.01:1)*TopRate, hsv2rgb(BarHsv));
%         set(gca, 'ydir', 'normal');
%         set(gca, 'xtick', []);
%         set(gca, 'yaxislocation', 'right');
%         axes(h);
% %        keyboard
%     end
% end
