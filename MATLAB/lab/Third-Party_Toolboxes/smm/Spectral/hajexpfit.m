% function beta =hajexpfit(x,y,plotresult)
% this function fits y = a + c * exp(-b*x), as defined in HAJEXP
% the initial parameter is defined as follows
% a .. mean of last 5 values of y;
% b .. 1/10 of the length fo the fit 
% c ..  (y-a)/exp(-b*x) 

function [beta,corrected] =hajexpfit(x,y,plotresult)

if nargin == 2
    plotresult = 0;
end

x = x(:);
y = y(:);

init_param= zeros(3,1);
init_param(1) = mean(y(end-2:end));
init_param(2) = 1/length(y)*10;
init_param(3) = (mean(y(1:10))-init_param(1))/exp(init_param(2)*x(3)) ;
%init_param(1) = mean(y(end-5:end));
%init_param(2) = 1/length(y)*10;
%init_param(3) = (mean(y(1:5))-init_param(1))/exp(init_param(2)*x(3)) ;

[beta,r,j] = nlinfit(x,y,@hajexp,init_param);

corrected = y - hajexp(beta,x);

if plotresult ~=0
    
    subplot(1,2,1);
    plot(x,y);
    hold on;
    plot(x,hajexp(beta,x),'r');
    title(num2str(beta(2)));
    hold off
    subplot(1,2,2);
    plot(x,corrected,'k');
end

