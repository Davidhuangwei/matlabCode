%   COS_THETA       Analysis of the null distribution of the circular variance.

% directional statistics package
% Dec-2001 ES

function cos_theta

for n = [1 2 3 4 5 10 15 20 100]
    % theta
    theta = rand(1000,n)*2*pi;
    % sum(cos(theta))
    figure, subplot(2,4,1)
    plot(sum(cos(theta),2),'.'),
    tbuf = sprintf('sum(cos(theta)); n = %g',n), title(tbuf)
    % sum(cos(theta))^2
    subplot(2,4,2)
    sum_cos_sq = (sum(cos(theta),2)).^2;
    plot( sum_cos_sq, '.')
    tbuf = sprintf('sum(cos(theta))^2; n = %g',n), title(tbuf)
    
    % sum(sin(theta))
    subplot(2,4,5)
    plot(sum(sin(theta),2),'.'),
    tbuf = sprintf('sum(sin(theta)); n = %g',n), title(tbuf)
    % sum(sin(theta))^2
    subplot(2,4,6)
    sum_sin_sq = (sum(sin(theta),2)).^2;
    plot( sum_sin_sq, '.')
    tbuf = sprintf('sum(sin(theta))^2; n = %g',n), title(tbuf)
    
    % sum(sin(theta))^2 + sum(cos(theta))^2
    sum_sin_cos = sum_sin_sq + sum_cos_sq;
    subplot(2,4,3)
    plot(sum_sin_cos,'.')
    tbuf = sprintf('sum sin cos; n = %g',n), title(tbuf)
    % sqrt ( sum(sin(theta))^2 + sum(cos(theta))^2 )
    sq_sum_sin_cos = sqrt ( sum_sin_cos );
    subplot(2,4,7)
    plot(sq_sum_sin_cos,'.')
    tbuf = sprintf('sq sum sin cos; n = %g',n), title(tbuf)
    
    % sqrt ( sum(sin(theta))^2 + sum(cos(theta))^2 ) / n
    R = sq_sum_sin_cos/n;
    subplot(2,4,4)
    plot(R,'.')
    tbuf = sprintf('R = sq sum sin cos / n; n = %g',n), title(tbuf)
    
    % 1 - sqrt ( sum(sin(theta))^2 + sum(cos(theta))^2 ) / n
    U = 1 - R;
    subplot(2,4,8)
    plot(U,'.')
    tbuf = sprintf('U = 1 - R; n = %g',n), title(tbuf)
       
end
