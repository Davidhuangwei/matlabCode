function [sMap, sOcc, sSpk, BinX, BinY] = PlaceMap(pos,spiket,itv,varargin)
[grid, smoothw, RateFactor] = DefaultArgs(varargin,{3,0.03,20000/39.0625});

%% function PlaceMap(pos,spiket,varargin)
%% [dummy] = DefaultArgs(varargin,{[]});
%%
%% Calculata and plot Place Map of neuron
%% 
%% pos:     nx2 matrix with x- and y-position
%% spiket:  spiketimes
%% grid:    grid-size in pos-units  
%% smoothw: width of smoothing window
%%

%% Occupation matrix
goodpos = find(WithinRanges([1:size(pos,1)],itv));
Occ = Accumulate(round(pos(goodpos,:)/grid),1)*RateFactor/20000;
Spk = zeros(size(Occ));
xSpk = Accumulate(round(pos(round(spiket/RateFactor),:)/grid),1);
Spk([1:size(xSpk,1)],[1:size(xSpk,2)]) = xSpk;


%% smooth
rx = (-size(Occ,1):size(Occ,1))/size(Occ,1);
Smootherx = exp(-rx.^2/smoothw^2/2);
ry = (-size(Occ,2):size(Occ,2))/size(Occ,2);
Smoothery = exp(-ry.^2/smoothw^2/2);

sOcc = conv2(Smootherx, Smoothery, Occ, 'same');
sSpk = conv2(Smootherx, Smoothery, Spk, 'same');

%% rate Map
Map = zeros(size(Occ));
Map(find(Occ)) = Spk(find(Occ))./Occ(find(Occ));
sMap =  conv2(Smootherx, Smoothery, Map, 'same');

Map2 = sSpk./sOcc;
Map2(find(sSpk==0)) = 0;

BinX = [1:size(Map,1)]*grid;
BinY = [1:size(Map,2)]*grid;

%% Plot
if nargout==0
  imagesc(sMap')
  axis xy
  colorbar
end

return;