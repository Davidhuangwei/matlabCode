%   UNIFORMITY_PDF  Find the null distribution of circular variance.
%
%       See COMP_CIRC_VAR (for computations).

% directional statistics package
% Dec-2001 ES

function S = uniformity_pdf(n1,n2,reps);

% calculate the empirical pdf and plot the cdf
S = []; %S = zeros(n2-n1+1,reps);
color = ['b' 'g' 'r' 'c' 'm' 'y' 'k'];
figure
for i = n1:n2
%    S(:,i) = comp_circ_var(rand(reps,i)*2*pi);
    hold on
%    my_cdfplot(S(:,i),color(1+mod(i-1,7)));
    my_cdfplot(comp_circ_var(rand(reps,i)*2*pi),color(1+mod(i-1,7)));
end

% % plot histograms
% for i = n1:n2
%     figure, hist(S(:,i),20),tbuf = sprintf('%g observations, %g repetitions',i,reps); title(tbuf)
% end
% 
% % transpose so that the rows are the different sample numbers
% S = S';
% 
% % save matrix in current directory
% fstr = sprintf('Sfile_%s_%s',num2str(reps),datestr(now,30))
% save(fstr,'S')