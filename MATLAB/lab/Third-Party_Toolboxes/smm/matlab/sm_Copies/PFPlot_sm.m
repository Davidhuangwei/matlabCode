function h = PFPlot(PlaceMap, colorLimits, NaNValue, Gamma)

if ~exist('Gamma','var') | isempty(Gamma)
    Gamma = 1;
end
if ~exist('NaNValue','var') | isempty(NaNValue)
    NaNValue = 0.8;
end
if ~exist('NaNSat','var') | isempty(NaNSat)
    NaNSat = 0;
end

if ~exist('colorLimits','var') | isempty(colorLimits)
    colorLimits = [min(min(PlaceMap)) max(max(PlaceMap))];
end
 
Hsv(:,:,1) = (2/3) - (2/3)*clip((PlaceMap-colorLimits(1))./(colorLimits(2)-colorLimits(1)),0,1).^Gamma;
Hsv(isnan(PlaceMap)) = 1;
Hsv(:,:,2) =   ~isnan(PlaceMap) + isnan(PlaceMap).*NaNSat;
Hsv(:,:,3) =   ~isnan(PlaceMap) + isnan(PlaceMap).*NaNValue;

%Hsv(:,:,2) =   ~isnan(PlaceMap)'.*0.5;
%Hsv(:,:,3) =    ones(size(FireRate'));

image(hsv2rgb(Hsv));
set(gca, 'ydir', 'reverse')


% most annoying bit is colorbar
h = gca;
h2 = SideBar;
BarHsv(:,:,1) = (2/3) - (2/3)*(0:.01:1)'.^Gamma;
BarHsv(:,:,2) = ones(101,1);
BarHsv(:,:,3) = ones(101,1);
image(0,(colorLimits(1):(colorLimits(2)-colorLimits(1))/100:colorLimits(2)), hsv2rgb(BarHsv));
set(gca, 'ydir', 'normal');
set(gca, 'xtick', []);
set(gca, 'yaxislocation', 'right');
axes(h);
return
