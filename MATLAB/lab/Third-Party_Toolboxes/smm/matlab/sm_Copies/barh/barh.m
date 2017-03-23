function hh = barh(varargin)
%BARH Horizontal bar graph.
%    BARH(X,Y) draws the columns of the M-by-N matrix Y as M groups of
%    N horizontal bars.  The vector X must be monotonically increasing
%    or decreasing.
%
%    BARH(Y) uses the default value of X=1:M.  For vector inputs,
%    BARH(X,Y) or BARH(Y) draws LENGTH(Y) bars.  The colors are set by
%    the colormap.
%
%    BARH(X,Y,WIDTH) or BARH(Y,WIDTH) specifies the width of the
%    bars. Values of WIDTH > 1, produce overlapped bars.  The
%    default value is WIDTH=0.8.
%
%    BARH(...,'grouped') produces the default vertical grouped bar chart.
%    BARH(...,'stacked') produces a vertical stacked bar chart.
%    BARH(...,LINESPEC) uses the line color specified (one of 'rgbymckw').
%
%    H = BARH(...) returns a vector of patch handles.
%
%    Use SHADING FACETED to put edges on the bars.  Use SHADING FLAT to
%    turn them off.
%
%    Examples: subplot(3,1,1), barh(rand(10,5),'stacked'), colormap(cool)
%              subplot(3,1,2), barh(0:.25:1,rand(5),1)
%              subplot(3,1,3), barh(rand(2,3),.75,'grouped')
%
%    See also PLOT, BAR, BAR3H.

%    Copyright 1984-2002 The MathWorks, Inc. 
%    $Revision: 1.16 $  $Date: 2002/06/05 17:52:51 $

error(nargchk(1,4,nargin));

[msg,x,y,xx,yy,linetype,plottype,barwidth,equal] = makebars(varargin{:});
if ~isempty(msg), error(msg); end

cax = newplot;
next = lower(get(cax,'NextPlot'));
hold_state = ishold;
edgec = get(gcf,'defaultaxesxcolor');
facec = 'flat';
h = []; 
cc = ones(size(xx,1),1);
if ~isempty(linetype), facec = linetype; end
for i=1:size(xx,2)
  numBars = (size(xx,1)-1)/5;
  for j=1:numBars,
     f(j,:) = (2:5) + 5*(j-1);
  end
  v = [yy(:,i) xx(:,i)];
  h=[h patch('faces', f, 'vertices', v, 'cdata', i*cc, ...
        'FaceColor',facec,'EdgeColor',edgec)];
end
if length(h)==1, set(cax,'clim',[1 2]), end
if ~equal, 
  hold on,
  plot(zeros(size(x,1),1),x(:,1),'*')
end
if ~hold_state, 
  % Set ticks if less than 16 integers
  if all(all(floor(x)==x)) & (size(x,1)<16),  
    set(cax,'ytick',x(:,1))
  end
  hold off, view(2), set(cax,'NextPlot',next);
  set(cax,'Layer','Bottom','box','on')
  % Switch to SHADING FLAT when the edges start to overwhelm the colors
  if size(xx,2)*numBars > 150, shading flat, end
end
if nargout==1, hh = h; end
