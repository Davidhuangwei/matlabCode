%   PLOT_S          Compute the circular variance and plot.

% directional statistics package
% Dec-2001 ES

function S0 = plot_s(theta,show,color);

% make sure theta is a column vector
[s1 s2] = size(theta);
if s1>1 & s2>1
    error('theta may not be a matrix')
end
if s1<s2
    theta = theta';
end

% basic computations
n = length(theta);
x = cos(theta);
y = sin(theta);
C = sum(x)/n;
S = sum(y)/n;
x0t = atan(S/C);

% assignment of angle mod 2*pi
if (C<0)
    x0 = x0t + pi;
else if (S<0)
        x0 = x0t + 2*pi;
    else
        x0 = x0t;
    end
end

% uniformity and variance
R = (C^2 + S^2)^0.5;
S0 = 1 - R;


if nargin>1 & strcmp(show,'compass')

    if nargin<3
        color = 'r';
    end

    % handle case of one point only
    if length(theta) == 1
        C = x; S = y;
    end
    if strcmp(color,'r')
        figure, subplot(1,2,1)
    else
        subplot(1,2,2)
end
%    my_compass(x,y), hold on, my_compass(C,S,color), hold off;
    my_polar(theta,ones(n,1)), hold on, my_compass(C,S,color), hold off;
    xbuf = sprintf('mean=%0.3g; R=%0.3g', x0, R);
    xlabel(xbuf);
end
