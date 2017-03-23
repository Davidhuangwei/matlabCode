% [Out, XBins, YBins, Pos] = hist2(Data, XBins, YBins)
%
% Makess a 2d histogram of the data.
% XBins and YBins are optional arguments
% which give the number of grid segments.
% - default is 50.
%
% Bin edges returned in XBins, YBins
% Pos returns grid position of each element - 0 if not in grid
%
% so that output is the same size as XBins x YBins
% and anything equal to upper limit goes in top bin.

function [out, XBins, YBins, Pos] = hist2(Data, XBins, YBins)

if (nargin<2) XBins = 50; end;
if (nargin<3) YBins = 50; end;

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
h = full(sparse(XBin(Good), YBin(Good), 1, length(XBins)-1, length(YBins)-1));

if nargout>0
    out = h;
else
    imagesc(XBins, YBins, h')
    set(gca, 'ydir', 'normal')
end