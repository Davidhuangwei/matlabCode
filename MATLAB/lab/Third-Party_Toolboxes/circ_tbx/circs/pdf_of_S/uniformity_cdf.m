%   UNIFORMITY_CDF  Plot the cumulative null distribution of circular variance.
%
%       See COMP_CIRC_VAR (for computations).

% directional statistics package
% Dec-2001 ES

% use 100000 reps

function str = uniformity_cdf(n,reps);

S = []; c = 0;
color = ['c' 'b' 'g' 'r' 'k' 'm' 'y'];
figure(1), clf(1)
for i = n
    hold on, c = c + 1;
%    if ~mod(c,7) 
    my_cdfplot(comp_circ_var(rand(reps,i)*2*pi),color(mod(c,7)+1));
end
title('Cumulative Distribution of the Circular Variance')
xlabel('S'), ylabel('F(S)')

% legend('n= ','n= ','n= ');

str = sprintf('');
for i=1:length(n);
    if i~=length(n)
        temp_str = sprintf('''n=%d'', ',n(i));
    else
        temp_str = sprintf('''n=%d''',n(i));
    end
    str = strcat(str,temp_str);
end
%legend(str,2);