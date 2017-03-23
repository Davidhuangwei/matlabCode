%   RAO_SIM         Check Rao's equal spacing test for uniformity.
%
%       call:   P_VALUE = RAO_SIM(REP,TYPE).
%               TYPE may be either 'uniform' or 'cosine'

% directional statistics package
% Dec-2001 ES

function p_value = rao_sim(rep,type);

switch type
case 'uniform'
   
%% uniformly distributed along the circle
p_value = [];
for i = 1:rep
   % select sample size - 4 to 14
   n = round(rand(1)*10+4);
   % select n directions
   theta = rand(1,n)*2*pi;
   % conduct Rao's spacing test
   [H0 p_value(i)] = rao_test(theta,0.05);
end
% plot the p values
figure, subplot(2,1,1), hist(p_value,20);
tbuf = sprintf('%g repetitions of Rao test for a sample of n=4-14\n~U(0,2*pi)',rep);
title(tbuf), ylabel('counts')

%% uniformly distributed along half a circle
p_value = [];
for i = 1:rep
   % select sample size - 4 to 14
   n = round(rand(1)*10+4);
   % select n directions
   theta = rand(1,n)*pi;
   % conduct Rao's spacing test
   [H0 p_value(i)] = rao_test(theta,0.05);
end
%plot
subplot(2,1,2), hist(p_value,20);
tbuf = sprintf('~U(0,pi)',rep);
title(tbuf), xlabel('p value'), ylabel('counts')

case 'cosine'
%% cosine distributed along the circle
p_value = [];
for i = 1:rep
   % select sample size - 4 to 14
   n = round(rand(1)*10+4);
   % select center
   cen = rand(1)*2*pi;
   % select n directions
   theta = cos((2*pi/n:2*pi/n:2*pi)+cen);
   theta = pi*(theta+1);
%   input('hit')
%   dir_mean(theta,ones(n,1),'compass');
   % conduct Rao's spacing test
   [H0 p_value(i)] = rao_test(theta,0.05);
%   p_value(i)
end
%plot
figure, hist(p_value,20);
tbuf = sprintf('%g repetitions of Rao test for a sample of n=4-14\n~cos(0,2*pi)',rep);
title(tbuf), xlabel('p value'), ylabel('counts')

cen = rand(1)*2*pi;
cos((2*pi/n:2*pi/n:2*pi)+cen);

end % switch