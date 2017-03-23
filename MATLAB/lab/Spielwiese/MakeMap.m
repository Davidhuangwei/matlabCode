function [Av Bin1 Bin2] = MakeMap(Pos,Aux,varargin)
%function [Av Bin1 Bin2] = MakeMap(Pos,Aux,varargin)
%[Nbin,Smooth,Plot] = DefaultArgs(varargin,{100,1,0});
[Nbin,Smooth,Plot] = DefaultArgs(varargin,{100,1,0});

%% X and Y of position
X = Pos(:,1);
Y = Pos(:,2);

%% shift
dX = max(X)-min(X);
dY = max(Y)-min(Y);

%% scaling factor for rounding position
k = max([Nbin/dX Nbin/dY]);

%% rounded position
rX = round((X-min(X))*k)+1;
rY = round((Y-min(Y))*k)+1;

%% matrix size
msize = [max(rX) max(rY)];

%% compute average
[Av Std Bins] = MakeAvF([rX rY],Aux,msize);

%% rescale Bins
Bin1 = (Bins{1}-1)/k+min(X);
Bin2 = (Bins{2}-1)/k+min(Y);

%% make map suitable for plotting and smoothing
Occ = Accumulate([rX rY],1,msize);
Av(find(Occ==0))=min(min(Av(find(Occ~=0))))-(max(max(Av(find(Occ~=0))))-min(min(Av(find(Occ~=0)))))/63;

%% smooth map
if Smooth
  Smooth = Nbin/3000;
  r1 = (-msize(1):msize(1))/msize(1);
  r2 = (-msize(2):msize(2))/msize(2);
  Smoother1 = exp(-r1.^2/Smooth^2/2);
  Smoother2 = exp(-r2.^2/Smooth^2/2);
  sAv = conv2(Smoother1,Smoother2,Av,'same');
else
  sAv = Av;
end

%% plot map
if Plot
  imagesc(Bin1,Bin2,sAv')
  colorbar
  colormap('default')
  cc = colormap;
  cc(1,:) = [0 0 0];
  colormap(cc)
  imagesc(Bin1,Bin2,sAv')
  colorbar
  axis xy
end


return;