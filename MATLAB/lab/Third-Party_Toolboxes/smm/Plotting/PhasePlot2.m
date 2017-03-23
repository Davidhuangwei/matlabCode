% function PhasePlot(x,y,varargin)
% useful for plotting phase plots as lines (rather than a histogram)
% filling in the edges (circular)
% 
% function PhasePlot(x,y,varargin)
% if max(x(end,:)) > pi
%     x = [x-360;x;x+360];
%     y = [y;y;y];
%     plot(x,y,varargin{:})
% else
%     x = [x-2*pi;x;x+2*pi];
%     y = [y;y;y];
%     plot(x,y,varargin{:})
% end
% 
% tag:phase
% tag:plot
% tag:histogram

function PhasePlot(x,y,varargin)
if max(x(end,:)) > pi
    x = [x-360;x;x+360];
    y = [y;y;y];
    plot(x,y,varargin{:})
else
    x = [x-2*pi;x;x+2*pi];
    y = [y;y;y];
    plot(x,y,varargin{:})
end