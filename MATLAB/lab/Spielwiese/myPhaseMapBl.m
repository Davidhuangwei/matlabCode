% [Phase, Radius, Conc] = PhaseMap(Pos, Ph, Smooth, nGrid, PlotThresh, Bar)
% Makes a phase map from position Pos and phase Ph of each spike
% works by fitting a locally weighted von Mises distribution
%
% Pos is a nx2 array giving position in each epoch.  It should be in
% the range 0 to 1.  SpkCnt gives the number of spikes in each epoch.
%
% Smooth is the width of the Gaussian smoother to use (in 0...1 units).
%
% nGrid gives the grid spacing to evaluate on (should be larger than 1/Smooth)
%
% output Phase is the mean phase, Radius is the mean radius.  Conc is the
% von mises concentration parameter.  only specify this if you need it, since
% calculation takes some time.
%
% if you specify Bar it will plot a color bar (default 0)
%
% PlotThresh is for scaling of intensity when you have no arguments to draw
% (default 20)
% (see PFPlot)

function [Phase, Radius, Conc] = myPhaseMapBl(Pos, Ph, Smooth, nGrid, PlotThresh, Bar)

if nargin<5
    PlotThresh = 20;
end

if nargin<6
    Bar = 0;
end

%keyboard;

% integrized Pos (in the range 1...nGrid
iPos = 1+floor(nGrid*Pos/(1+eps));

% complex vector

% make unsmoothed arrays
n = full(sparse(iPos(:,1), iPos(:,2), 1, nGrid, nGrid));
cVec = full(sparse(iPos(:,1), iPos(:,2), exp(i*Ph), nGrid, nGrid));

% do the smoothing
r = (-nGrid:nGrid)/nGrid;
Smoother = exp(-r.^2/Smooth^2/2);

sn = conv2(Smoother, Smoother, n, 'same');
sMeanVec = conv2(Smoother, Smoother, cVec, 'same');

ComplexMap = sMeanVec./(sn+eps);

Phase = angle(ComplexMap);
%Phase = mod(angle(ComplexMap)-pi,2*pi);

Radius = abs(ComplexMap);

% compute conc. param if necessary ...
if nargout>=3
    for x=1:size(Radius,1)
        for y=1:size(Radius,2)
            func = sprintf('besseli(1,x)./besseli(0,x)-%f', Radius(x,y));
            Conc(x,y) = fzero('besseli(1,x)./besseli(0,x)-.5', 0) ;
        end
    end
end

%keyboard;

if nargout==0
%    ComplexImage(-ComplexMap.'./(1+PlotThresh./sn.'), .5);
    myComplexImageBl(-ComplexMap.'./Radius.'./(1+PlotThresh./sn.'), .5);
    MainAx = gca;
    set(gca, 'ydir', 'normal');
    title('Phase');

    if Bar
		SideBar;
		h = hsv(360); h2 = [h(181:end,:); h(1:180,:)]; %h2 = flipud(h);
		image(reshape(h2,[360 1 3]))
		set(gca, 'xtick', [])
		set(gca, 'ytick', [1 90 180 270 360])
		set(gca, 'yticklabel', [0 90 180 270 360])
		set(gca, 'yaxislocation', 'right');
		set(gca, 'ydir', 'normal');
	
        axes(MainAx);
    end
end