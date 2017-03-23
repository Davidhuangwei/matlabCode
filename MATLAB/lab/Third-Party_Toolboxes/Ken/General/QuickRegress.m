% QuickRegress(x,y, PointStyle, LineStyle)
%
% does a quick scatterplot of y vs. x, plots a lsline
% and prints stats
%
% can only deal with vector inputs for now

function QuickRegress(x,y, PointStyle, LineStyle)

x=x(:);
y=y(:);

Good = find(isfinite(x(:)) & isfinite(y(:)));

x=x(Good);
y=y(Good);

if nargin<3
    PointStyle = 'b.';
end
if nargin<4
    LineStyle = 'r-';
end

nPoints = length(x);

if iscell(PointStyle)
    plot(x,y,PointStyle{:})
elseif ~isempty(PointStyle)
    plot(x,y,PointStyle)
end

[b bint r rint stats] = regress(y, [x, ones(nPoints,1)]);

fprintf('y = %fx + %f.  R^2 = %f.  p = %f\n', b, stats([1 3]));


% plot fit line
h = ishold;
hold on;

if iscell(LineStyle)
    plot(xlim, xlim*b(1) + b(2),LineStyle{:});
elseif ~isempty(LineStyle)
    plot(xlim, xlim*b(1) + b(2),LineStyle);
end

if h==0
    hold off;
end