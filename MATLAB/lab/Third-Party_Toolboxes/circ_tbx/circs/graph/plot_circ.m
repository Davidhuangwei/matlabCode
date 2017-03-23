% PLOT_CIRC         compute and plot circular data.
%
%               see also MY_POLAR.

% 02-aug-02 ES

% revisions
% 30-aug-02 atan2; R on polar plot
% 13-nov-02 smaller FS
% 07-dec-02 optional XFS
% 31-mar-03 handles
% 24-aug-03 ; after MY_POLAR call
% 11-dec-03 XFS <= 0 doesn't text
% 24-jan-04 default THETA

function [x0, R, fh, h] = plot_circ(theta,f,fh,plot_type,XFS);

% handle input errors
f = f(:);
if nargin < 1 | isempty( theta )
    theta = [1/6 0 5/6:-1/6:1/3]'*2*pi;
end
theta = theta(:);
if length(theta)~=length(f)
    error('input vectors must be of the same size');
end
if ~any(f), disp('all values are zero'); return, end
if nargin<3 | isempty(fh), error('usage: plot_circ(theta,f,fh)'), end
if nargin<4 | isempty(plot_type), plot_type = 'polar'; end
if nargin<5 | isempty(XFS), XFS = 6; end

% basic computations
n = sum(f);
x = f.*cos(theta);
y = f.*sin(theta);
C = sum(x)/n;
S = sum(y)/n;
x0 = mod(atan2(S,C),2*pi);

if nargout > 0 | XFS >= 0
    % uniformity and variance
    R = (C^2 + S^2)^0.5;
    S0 = 1 - R;
    s0 = (-2*log(R))^0.5;
end

if strcmp(plot_type,'polar')
    subplot(fh)
%    my_polar(theta,f,'r',[C S])
    h = my_polar(theta,f,'r');
    hold on, my_polar([x0 x0]',[0 max(f)]','b');
    if XFS > 0
        set(fh,'FontSize',XFS)
    else
        return
    end
    if XFS <= 6
        xbuf = sprintf('mean=%0.2g; R=%0.2g', x0, R);
    else
        xbuf = sprintf('mean=%0.2g\nR=%0.2g', x0, R);
    end
    xlabel(xbuf)
end

return