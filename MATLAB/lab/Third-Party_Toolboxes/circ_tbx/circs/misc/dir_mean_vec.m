% DIR_MEAN_VEC      Compute the mean and sd of directional data (dir_mean for vectorial observations)  
%                   NOTE - applicable to non-negative data !! 
%   input:    theta - a vector of directions;
%             f     - a mat of corresponding values (row = time, col = dir)
%
%   format:   both vectors should be of the same length;
%             theta - may contain any value (radians);
%             f     - may contain any value (not all zeros);
%             graph - is optional.
%
%   call:     [x0 S0 s0] = DIR_MEAN(THETA,F) only computes;
%
%   output:   x0 - the mean direction (rad);
%             S0 - the circular variance (uniformity, 0 to 1);
%             s0 - the sd (rad).
% directional statistics package
% Nov-2001 ES
% 26-aug-02 ~any(f) added
% 19oct04 IA started working on that & suddenly realized it was not applicable to vector format data if data points can be +/- !!    
%            hence added check. the function works (w/o graphics)  

function [x0, S0, s0] = dir_mean_vec(theta,f);

% handle input errors
if length(theta)~=size(f,2) 
    error('input data & theta must be of same # of dirs');
end
theta=repmat(theta',size(f,1),1); 
if ~any(f)
%    error('all values are zero');
    % temp
    disp('        all values are zero');
    x0 = NaN*ones(size(f,1),1); S0 = NaN*ones(size(f,1),1); s0 = NaN*ones(size(f,1),1);
    return;
end
if any(any(f<0))
        error('input elements must non-negative');
end 
    % basic computations
    n = sum(f,2);
    x = f.*cos(theta);
    y = f.*sin(theta);
    C = sum(x,2)./n;
    S = sum(y,2)./n;
    x0t = atan(S./C);
    
    % assignment of angle mod 2*pi
    x0=x0t; 
    Cneg_inds=find(C<0); 
    Sneg_inds=find(C<0);
    if ~isempty(Cneg_inds)
        x0(Cneg_inds) = x0t(Cneg_inds) + pi;
    else ~isempty(Sneg_inds)
            x0(Sneg_inds) = x0t(Sneg_inds) + 2*pi;
    end
    
    % uniformity and variance
    R = (C.^2 + S.^2).^0.5;
    S0 = 1 - R;
    s0 = (-2*log(R)).^0.5;

    
    % normalize vector
%    nor_vec = n*R/mean(f)
    
% % visuals
% nin = nargin - 2;
% while (nin>0 & isstr(varargin{nin}))
%     graph = varargin{nin};     
%     switch (graph)
%     case 'compass'
%         % handle case of one point only
%         if length(theta) == 1
%             C = x; S = y;
%         end
%         compass(x,y), hold on, compass(C,S,'r'), hold off;
% %        xbuf = sprintf('mean=%g; R=%g; sd=%g', x0, R, s0);
%         xbuf = sprintf('mean=%0.3g; R=%0.3g', x0, R);
%         xlabel(xbuf);
%     case 'linear'
%         figure, stem(theta,f), hold on, stem(x0,R,'r'), hold off;
%         xbuf = sprintf('mean=%g; R=%g; sd=%g', x0, R, s0);
%         xlabel(xbuf), ylabel('f');
%     case 'subplots'
%         nin = nin - 1;        
%         if length(theta) == 1
%             C = x; S = y;
%         end
%         subplot(2,2,varargin{nin}),compass(x,y), hold on, compass(C,S,'r'), hold off;
%         xbuf = sprintf('mean=%0.3g; S=%0.3g; n=%g', x0, 1-R, length(theta));
% %        xbuf = sprintf('mean=%g; R=%g; sd=%g', x0*180/pi, R, s0*180/pi);
%         xlabel(xbuf);
%     otherwise
%         tbuf = graph;
%         title(tbuf);        
%     end
%     nin = nin - 1;
% end
%     
