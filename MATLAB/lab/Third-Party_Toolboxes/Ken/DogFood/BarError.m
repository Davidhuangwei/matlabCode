% h = BarError(..., l, u)
%
% plots a bar chart with error bars
%
% all but 2 arguments are passed to bar.  Then errorbars are superimposed, u above, and l below
%
% u and l should be the same shape as the 'y' argument to bar - nxm where n is the number of x
% points and m is the number of groups.

function h = BarError(varargin)

holdstat = ishold;

hb = bar(varargin{1:nargin-2});
hold on;
l = varargin{nargin-1};
u = varargin{nargin};


% now loop through groups

hee = []; %handles for errorbar
for g=1:length(hb);
	h1 =hb(g);
	x = get(h1, 'XData');
	y = get(h1, 'YData');

	meanx = mean(x,1); % center point of bar
	yval = y(2,:); % y value

    he = errorbar(meanx, yval, u(:,g), l(:,g), 'k.');
	hee = [hee, he(:)'];
end

if ~holdstat
    hold off;
end

if nargout>=1
    h = [hb(:)' he(:)'];
end