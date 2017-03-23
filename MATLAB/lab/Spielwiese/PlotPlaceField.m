function [RateMap Bin1 Bin2] = PlotPlaceField(spiket,whlx,whly,varargin)
[SpikeRate,WhlRate,Nbin,Smooth,Plot] = DefaultArgs(varargin,{20000,39.0625,100,[],1});

%% scaling factor for rounding position
dx = max(whlx) - min(whlx); 
dy = max(whly) - min(whly); 
k = max([Nbin/dx Nbin/dy]);

%% rounded position
X = round((whlx-min(whlx))*k)+1;
Y = round((whly-min(whly))*k)+1;

%% matrix size
msize = [max(X) max(Y)];

%% Occupancy
Occ = Accumulate([X Y],1,msize);
%% UNITS!!!

%imagesc(Occ')
%axis xy

%% spike count
xindx = round(spiket/SpikeRate*WhlRate);
indx = xindx(find(xindx>0 & xindx<=length(X)));
spikep(:,1) = X(indx);
spikep(:,2) = Y(indx);

Count = Accumulate(spikep,1,msize);

%% spike Rate
Rate = Count./Occ;
Rate(isnan(Rate)) = 0;

%% smooth
if isempty(Smooth)
  Smooth = Nbin/3000;
end
r1 = (-msize(1):msize(1))/msize(1);
r2 = (-msize(2):msize(2))/msize(2);
Smoother1 = exp(-r1.^2/Smooth^2/2);
Smoother2 = exp(-r2.^2/Smooth^2/2);
SRate = conv2(Smoother1,Smoother2,Rate,'same');

%% plot place field
%SRate(find(SRate<max(max(SRate))/64*2)) = max(max(SRate))/64*2;
SRate(find(Occ==0))=min(min(SRate))-(max(max(SRate))-min(min(SRate)))/63;

RateMap = SRate;
Bin1 = ([1:msize(1)]-1)/k + min(whlx);
Bin2 = ([1:msize(2)]-1)/k + min(whly);

if Plot
  imagesc(Bin1,Bin2,SRate')
  colorbar
  colormap('default')
  cc = colormap;
  cc(1,:) = [0 0 0];
  colormap(cc)
  imagesc(Bin1,Bin2,SRate')
  colorbar
  axis xy
end


%keyboard

return