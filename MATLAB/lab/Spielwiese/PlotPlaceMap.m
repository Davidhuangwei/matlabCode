function PlotPlaceMap(X,Y,Z,BinX,BinY,varargin)
[NumBin,circ,smooth] = DefaultArgs(varargin,{50,0,0});

%% calculate the accumulated average (option: in circular coordinates)
%% Plot place map: axsis dim are taken from max and min of BinX,
%% and BinY

%% Axis:

min1 =  min(BinX);
max1 =  max(BinX);
min2 =  min(BinY);
max2 =  max(BinY);
Bin1 = [min1:(max1-min1)/NumBin:max1]';
Bin2 = [min2:(max2-min2)/NumBin:max2]';

[Av Std Bins OcMap] = myMakeAveCirc([X Y],Z,{Bin1 Bin2});
Av = mod(Av*180/pi,360)/180*pi;

%% ==>> good plotting with
%% ==>> local smoothing.
colormap('default');
%imagesc(Bin1,Bin2,mySmooth(Av,1)');%,[min(Av(find(Av>0))) max(max(Av))]);
imagesc(Bin1,Bin2,Av',[min(Av(find(OcMap(:)~=0))) max(Av(find(OcMap(:)~=0)))]);
%ImageScRmNan(Bin1,Bin2,Av',[min(Av(find(OcMap(:)~=0))) max(Av(find(OcMap(:)~=0)))],[],[]);
cc = colormap; 
ccnew = [cc(1:2:64,:) ;cc(64:-2:1,:)];
ccnew(1,:) = [0.9 0.9 0.9] ;
colormap(ccnew);
set(gca, 'ydir', 'normal')
colorbar
