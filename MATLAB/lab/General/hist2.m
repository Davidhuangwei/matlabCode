% [Out, XBins, YBins, Pos] = hist2(Data, XBins, YBins, Normalize, Smooth, Outliers)
%
% Makess a 2d histogram of the data.
% XBins and YBins are optional arguments
% which give the number of grid segments.
% - default is 50.
% Normalize, if not 0 then normalizes count to integrate to 1 along given dimension (1 or 2)
% Bin edges returned in XBins, YBins
% Pos returns grid position of each element - 0 if not in grid
%
% so that output is the same size as XBins x YBins
% and anything equal to upper limit goes in top bin.

function [out, XBins, YBins, Pos] = hist2(Data, varargin)

[XBins, YBins, Normalize, Smooth,Outliers] =  DefaultArgs(varargin,{50,50,0,0,[]});

% if XBins is a scalar, evenly space the bins
if length(XBins)==1
    MinX = min(Data(:,1));
    MaxX = max(Data(:,1));
    XBins = MinX:(MaxX-MinX)/XBins:MaxX;
end
if length(YBins)==1
    MinY = min(Data(:,2));
    MaxY = max(Data(:,2));
    YBins = MinY:(MaxY-MinY)/YBins:MaxY;
end


% compute bin positions
[dummy XBin] = histc(Data(:,1), XBins);
[dummy YBin] = histc(Data(:,2), YBins);

% anything equal to top bin goes inside
XBin(find(Data(:,1)==XBins(end))) = length(XBins)-1;
YBin(find(Data(:,2)==YBins(end))) = length(YBins)-1;

Pos = [XBin, YBin];

% Only use those inside bins
Good = find(XBin>0 & YBin>0);

%now make array
%h = full(sparse(XBin(Good), YBin(Good), 1, length(XBins)-1, length(YBins)-1));
h = accumarray(Pos(Good,:), 1, [length(XBins)-1, length(YBins)-1], @sum);
if Smooth ~=0 | length(Smooth)==2
   if length(Smooth)==1 Smooth =[1 1 ]*Smooth; end
   h = conv2(gausswin(Smooth(1),1),gausswin(Smooth(2),1),h,'same'); 
end
if Normalize ==1
    h = h./repmat(sum(h,1),size(h,1),1);
elseif Normalize ==2
    h = h./repmat(sum(h,2),1,size(h,2));
elseif Normalize==3
    h = h./repmat(sum(h(:)),size(h,1),size(h,2));
end

XBins = (XBins(1:end-1)+XBins(2:end))/2;
YBins = (YBins(1:end-1)+YBins(2:end))/2;

if nargout>0
    out = h;
    XBins = XBins(:); 
    YBins = YBins(:);
else
    imagesc(XBins, YBins, h')
%    pcolor(XBins(:), YBins(:), h');
 %   shading flat
    set(gca, 'ydir', 'normal')
end