% DIR_MEAN          Compute the mean and sd of directional data.
%
%   input:    theta - a vector of directions;
%             f     - a vector of corresponding values;
%             graph - a string representing type of graph to be shown.
%
%   format:   both vectors should be of the same length;
%             theta - may contain any value (radians);
%             f     - may contain any value (not all zeros);
%             graph - is optional.
%
%   call:     [x0 S0 s0] = DIR_MEAN(THETA,F) only computes;
%             DIR_MEAN(...,'compass') also plots a compass;
%             DIR_MEAN(...,'linear') also plots a stem;
%             DIR_MEAN(...,num,'subplots') plots on current figure on a 2x2;
%             'compass' and 'linear' may be preceeded by a title string.
%
%   output:   x0 - the mean direction (rad);
%             S0 - the circular variance (uniformity, 0 to 1);
%             s0 - the sd (rad).

% directional statistics package
% Nov-2001 ES

% revisions
% 26-aug-02 ~any(f) added
% 02-oct-05 1. 'all values are zero' remarked
%           2. atan2 used

function [x0, S0, s0] = dir_mean(theta,f,varargin);

% handle input errors
if length(theta)~=length(f)
    error('input vectors must be of the same size');
end
if ~any(f)
%    error('all values are zero');
    % temp
    %disp('        all values are zero');
    x0 = NaN; S0 = NaN; s0 = NaN;
    return;
end
if size(theta)~=size(f)
    f=f';
end

    % basic computations
    n = sum(f);
    x = f.*cos(theta);
    y = f.*sin(theta);
    C = sum(x)/n;
    S = sum(y)/n;
    x0 = mod( atan2( S, C ), 2 * pi );
%     x0t = atan(S/C);
%     
%     % assignment of angle mod 2*pi
%     if (C<0)
%         x0 = x0t + pi;
%     else if (S<0)
%             x0 = x0t + 2*pi;
%         else
%             x0 = x0t;
%         end
%     end
    
    % uniformity and variance
    R = (C^2 + S^2)^0.5;
    S0 = 1 - R;
    s0 = (-2*log(R))^0.5;

    
    % normalize vector
%    nor_vec = n*R/mean(f)
    
% visuals
nin = nargin - 2;
while (nin>0 & isstr(varargin{nin}))
    graph = varargin{nin};     
    switch (graph)
    case 'compass'
        % handle case of one point only
        if length(theta) == 1
            C = x; S = y;
        end
        compass(x,y), hold on, compass(C,S,'r'), hold off;
%        xbuf = sprintf('mean=%g; R=%g; sd=%g', x0, R, s0);
        xbuf = sprintf('mean=%0.3g; R=%0.3g', x0, R);
        xlabel(xbuf);
    case 'linear'
        figure, stem(theta,f), hold on, stem(x0,R,'r'), hold off;
        xbuf = sprintf('mean=%g; R=%g; sd=%g', x0, R, s0);
        xlabel(xbuf), ylabel('f');
    case 'subplots'
        nin = nin - 1;        
        if length(theta) == 1
            C = x; S = y;
        end
        subplot(2,2,varargin{nin}),compass(x,y), hold on, compass(C,S,'r'), hold off;
        xbuf = sprintf('mean=%0.3g; S=%0.3g; n=%g', x0, 1-R, length(theta));
%        xbuf = sprintf('mean=%g; R=%g; sd=%g', x0*180/pi, R, s0*180/pi);
        xlabel(xbuf);
    otherwise
        tbuf = graph;
        title(tbuf);        
    end
    nin = nin - 1;
end
    
