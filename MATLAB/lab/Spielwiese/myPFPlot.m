% PFPlot(PlaceMap, OccupancyMap, TopRate, TimeThresh, Gamma) = 
%
% Plots a place field (see PFClassic)
%
% These are now plotted with directions as in the wheel file!
%
% NB PlaceMap and OccupancyMap should be in Hz and seconds.
% this is NOT how they are output from PFClassic (which depends)
% on the sample rates.  So convert them!

function myPFPlot(PlaceMap, sTimeSpent, TopRate, TimeThresh, Gamma)

FireRate = PlaceMap;

if nargin<4
    TimeThresh=1;
end
if nargin<5;
    Gamma = 1;
end
if nargin<3 | isempty(TopRate)
    TopRate = max(FireRate(find(sTimeSpent>TimeThresh)));
    if TopRate<1 , TopRate=1; end;
    if isempty(TopRate), TopRate=1; end;
end

Hsv(:,:,1) = (2/3) - (2/3)*clip(FireRate'/TopRate,0,1).^Gamma;
Hsv(:,:,2) = ones(size(FireRate'));
Hsv(:,:,3) = 1./(1+TimeThresh./sTimeSpent');

%subplot(2,1,1)
image(hsv2rgb(Hsv));
set(gca, 'ydir', 'normal')
 

%Rate = PlaceMap./sTimeSpent;
%subplot(2,1,1)
%imagesc(Rate);
%set(gca, 'ydir', 'normal')

%mtsp = mean(mean(sTimeSpent));

%subplot(2,1,2)
%image(sTimeSpent'/mtsp);
%set(gca, 'ydir','normal')



% most annoying bit is colorbar
h = gca;
h2 = mySideBar;
BarHsv(:,:,1) = (2/3) - (2/3)*(0:.01:1)'.^Gamma;
BarHsv(:,:,2) = ones(101,1);
BarHsv(:,:,3) = ones(101,1);
image(0,(0:.01:1)*TopRate, hsv2rgb(BarHsv));
set(gca, 'ydir', 'normal');
set(gca, 'xtick', []);
set(gca, 'yaxislocation', 'right');
axes(h);
