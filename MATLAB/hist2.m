function [h, XBins, YBins, Pos] = hist2(x, y, XBins, YBins)
% [phi, xc, yc] = hist2(x, y, XBins, YBins)
% 
% Makess a 2d histogram of the data.
% XBins YBins and ZBins are 
% Bin edges returned in XBins, YBins, ZBins (length(out)=inBins+1)
% XBins = MinX:(MaxX-MinX)/XBins:MaxX if not given edges;
% Pos returns grid position of each element - 0 if not in grid
%
% so that output is the same size as XBins(in) x YBins(in)
% and anything equal to upper limit goes in top bin. YY


if length(XBins)<2
    XBins=linspace(min(x),max(x),XBins+1);
end
if length(YBins)<2
    YBins=linspace(min(y),max(y),YBins+1);
end
% compute bin positions
[dummy, XBin] = histc(x, XBins);
[dummy, YBin] = histc(y, YBins);
% anything equal to top bin goes inside
n=length(XBins)-1;
m=length(YBins)-1;
XBin(x==XBins(end)) = n;
YBin(y==YBins(end)) = m;

Pos = [XBin, YBin];

% % Only use those inside bins
% Good = find(XBin>0 & YBin>0);(Goods)(Goods)

%now make array
XBin(XBin==0)=1;
YBin(YBin==0)=1;
h= full(sparse(XBin, YBin, 1, n, m));


%% I don't like MIT file... do it myself.
% %HIST2 Two-dimensional histogram.
% 
% if (nargin < 3)
%    n = 10;  % default bins
% 
% xmin = min(x);
% xmax = max(x);
% ymin = min(y);
% ymax = max(y);
% 
% % Bin edges.
% xedges = linspace(xmin, xmax, n + 1);
% yedges = linspace(ymin, ymax, n + 1);
% end
% n=length(xedges);
% m=length(yedges);
% % Generate histograms along y-axis.
% for i = 1:n,
%    yi = y(x >= xedges(i) & x < xedges(i + 1));
%    if ~isempty(yi)
%       yhisti = histc(yi, yedges);
%    else
%       yhisti = zeros(1, n+1);
%    end
%    h(:,i) = fliplr(yhisti(1:(end - 1)))';
% end
% 
% xc = (xedges(1:end-1) + xedges(2:end))/2;
% yc = (yedges(1:end-1) + yedges(2:end))/2;
% 
% % Plot or output mass matrix.
% if (nargout == 0)
%    % Note: the matrix h is arranged as y->i, x->j
%    imagesc(h)
%    colorbar
%    
%    xcenters = (xedges(2:end) + xedges(1:end-1))/2;
%    ycenters = (yedges(2:end) + yedges(1:end-1))/2;
%    xlabels = xcenters(get(gca, 'XTick'));
%    ylabels = ycenters(get(gca, 'YTick'));
%    set(gca, 'XTickLabel', num2str(xlabels'));
%    set(gca, 'YTickLabel', num2str(fliplr(ylabels)'));
%    xlabel('\itx')
%    ylabel('\ity')
%    %bar3(xc, h, 1, 'hist')
% else
%    phi = h;
% end