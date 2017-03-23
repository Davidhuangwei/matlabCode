%   WHEELER_SIM     Check Wheeler's 2 sample test for equality.
%
%       call:   P_VALUE = WHEELER_SIM(REP,RANGE).
%       input:  rep     - number of repetitions of each test
%               range   - range of uniform distribution of second test

% directional statistics package
% Dec-2001 ES

function wheeler_sim(rep,range);

%% both samples are uniformly distributed along the circle
p_value = [];
for i = 1:rep
   % select sample sizes - 4 to 14
   n1 = round(rand(1)*10+4);
   n2 = round(rand(1)*10+4);
   % select directions
   theta1 = rand(1,n1)*2*pi;
   theta2 = rand(1,n2)*2*pi;
   % conduct the test
   [H0 p_value(i)] = wheeler(theta1,theta2,0.05);%,'compass');
end
% plot the p values
figure, subplot(2,1,1), hist(p_value,20);
tbuf = sprintf('%g repetitions of Wheeler test for 2 samples of n=4-14 each\n2 * ~U(0,2*pi)',rep);
title(tbuf), ylabel('counts')

%% is sample is uniformly distributed along half a circle
p_value = [];
for i = 1:rep
   % select sample sizes - 4 to 14
   n1 = round(rand(1)*10+4);
   n2 = round(rand(1)*10+4);
   % select directions
%   input('hit')
   cen = rand(2,1)*2*pi;
   theta1 = mod(rand(1,n1)*range*pi+cen(1),2*pi);
   theta2 = mod(rand(1,n2)*range*pi+cen(2),2*pi);
   % conduct the test
   [H0 p_value(i)] = wheeler(theta1,theta2,0.05);%,'compass');
 %  p_value(i)
end
% plot the p values
subplot(2,1,2), hist(p_value,20);
tbuf = sprintf('~U(alpha,alpha+%g*pi), ~U(beta,beta+%g*pi)',range,range);
title(tbuf), xlabel('p value'), ylabel('counts')
