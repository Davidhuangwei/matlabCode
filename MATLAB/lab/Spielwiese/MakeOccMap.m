function [OccMap SOccMap Bin1 Bin2] = MakeOccMap(W,varargin)
% function [OccMap SOccMap Bin1 Bin2] = MakeOccMap(W,varargin)
% [Nbin,Smooth,Plot] = DefaultArgs(varargin,{100,[],1});
[Nbin,Smooth,Plot] = DefaultArgs(varargin,{100,[],1});

wx = W(:,1);
wy = W(:,2);

%keyboard

%% scaling factor for rounding position
dx = max(wx) - min(wx); 
dy = max(wy) - min(wy); 

if size(Nbin)==1
  Nbin = [Nbin Nbin];
end
k = [Nbin(1)/dx Nbin(2)/dy];

%% rounded position
X = round((wx-min(wx))*k(1))+1;
Y = round((wy-min(wy))*k(2))+1;

%% matrix size
msize = [max(X) max(Y)];

%% Occupancy
OccMap = Accumulate([X Y],1,msize);
%% UNITS!!!


if isempty(Smooth)
  Smooth = Nbin/3000;
end
r1 = (-msize(1):msize(1))/msize(1);
r2 = (-msize(2):msize(2))/msize(2);
Smoother1 = exp(-r1.^2/Smooth(1)^2/2);
Smoother2 = exp(-r2.^2/Smooth(2)^2/2);
SOccMap = conv2(Smoother1,Smoother2,OccMap,'same');

Bin1 = ([1:msize(1)]-1)/k(1) + min(wx);
Bin2 = ([1:msize(2)]-1)/k(2) + min(wy);

if Plot
  imagesc(Bin1,Bin2,SOccMap')
  colorbar
  axis xy
end

return;
