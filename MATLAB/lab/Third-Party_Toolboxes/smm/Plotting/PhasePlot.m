% function PhasePlot(x,y,varargin)
% useful for plotting phase plots as lines (rather than a histogram)
% filling in the edges (circular)
% 
% if max(x(end,:)) > pi
%   plot([x(end,:)-360;x;x(1,:)+360],[y(end,:);y;y(1,:)],varargin{:})
% else
%   plot([x(end,:)-2*pi;x;x(1,:)+2*pi],[y(end,:);y;y(1,:)],varargin{:})
% end
% 
% tag:phase
% tag:plot
% tag:histogram

function PhasePlot(x,y,varargin)
if max(x(end,:)) > pi
    plot([x(end,:)-360;x;x(1,:)+360],[y(end,:);y;y(1,:)],varargin{:})
else
    plot([x(end,:)-2*pi;x;x(1,:)+2*pi],[y(end,:);y;y(1,:)],varargin{:})
end