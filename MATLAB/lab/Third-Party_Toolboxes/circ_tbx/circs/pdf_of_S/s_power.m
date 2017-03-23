%   S_POWER        Computes the power of the S test by Monte Carlo simulations.
%
%       call:   S_POWER(N,MYU0,KAPPA,NS,MODE)
%               where n is the sample size, myu0 is the VM mean,
%               kappa is a vector of concentrations, NS is number of repetitions,
%               and mode is 1 or 2 (uni- or bi- modal, default is 1).
%
%       See COMP_CIRC_VAR, PLOT_S, VMRND.

% directional statistics package
% Dec-2001 ES

function [power_vm, power_ray] = s_power(n,myu0,kappa,NS,mode);

if nargin<5
    mode=1;
elseif mode~=1 & mode~=2
    error('mode may be 1 or 2')
end
% compute the cdf
reps = 10000; % use 100,000
x = rand(reps,n)*2*pi;
temp = comp_circ_var(x);
[yy,xx,rs,emsg] = cdfcalc(temp);

NK = length(kappa);
power_ray = zeros(NK,1);
if mode==2
    myu0
    myu1 = mod(myu0+(2*rand(1)-1)*pi,2*pi) % bimodal
    input('hit to confirm')
end

% now repeat the process for NS samples from each distribution
for i=1:NS
    disp(['iteration ',num2str(i)])
%     uniform_theta = rand(n,1)*2*pi;
%     S_uniform = plot_s(uniform_theta);
%     index_uniform_samples(i) = min(find(xx>S_uniform));

    for j=1:NK
        vm_theta = [];
        if mode==1
            vm_theta = vmrnd(myu0,kappa(j),n);                  % unimodal alternative
        else
            vm_theta = vmrnd2([myu0 myu1],[kappa(j) kappa(j)],n); % bimodal alternative
        end
        S_vm = plot_s(vm_theta);
%        index_vm_samples(j,i) = min(find(xx>S_vm));       
        if min(xx)>S_vm
            index_vm_samples(j,i) = 1;
        elseif max(xx)<S_vm
            index_vm_samples(j,i) = length(xx);
        else
            index_vm_samples(j,i) = max(find(xx<S_vm));
        end
        % if more than 4 observations/sample, apply Rayleigh's test as well
        if n>=5
            power_ray(j) = power_ray(j) + ray_test(vm_theta,ones(length(vm_theta),1),0.1);
        end
    end

end 

% plot the power histograms and compute the power of each alternative
%figure
%subplot(NK+1,1,1), hist(yy(index_uniform_samples),[0.025:0.05:0.975])
%%%%%%%%power_u = sum(yy(index_uniform_samples)<0.1)/NS;
%tbuf = sprintf('Monte Carlo simulations - %g repetitions, n=%g',NS,n);
%xbuf = sprintf('H1=~U, power=%0.3g',power_u);
%title(tbuf), xlabel(xbuf), ylabel('counts')
for j=1:NK   
%    subplot(NK+1,1,j+1), hist(yy(index_vm_samples(j,:)),[0.025:0.05:0.975])
    power_vm(j) = sum(yy(index_vm_samples(j,:))<0.1)/NS;
%    xbuf = sprintf('H1=~VM(%0.3g,%g), power=%0.3g',myu0,kappa(j),power_vm(j));
%    xlabel(xbuf), ylabel('counts')    
end

%figure, subplot(2,1,1), plot([0 kappa],[power_u power_vm],'v')
figure, subplot(2,1,1), plot(kappa,power_vm,'v')
if n>=5
    power_ray = 1 - power_ray/NS;
    hold on, plot(kappa,power_ray,'^r')
    legend('S test','Rayleigh''s test',2)
    legend('boxoff')
else
    legend('S test',2)
    legend('boxoff')
end    
%set(gca,'XTick',[0 kappa])
set(gca,'XTick',kappa)
xlabel('kappa'), ylabel('power')
if mode==1
    tbuf = sprintf('Monte Carlo simulation results - %g repetitions, n=%g, H1=VM(%0.3g,kappa)',NS,n,myu0); % unimodal alternative
else
% bimodal alternative : 
tbuf = sprintf('Monte Carlo simulation results - %g repetitions, n=%g, H1=VM(%0.3g,kappa)+VM(%0.3g,kappa)',NS,n,myu0,myu1); 
end
title(tbuf)

CPS = 20;
%cum_power_u = 1 - (1-power_u)^CPS;
cum_power_s = 1 - (1-power_vm).^CPS;
subplot(2,1,2)
if n>=5
%    plot([0 kappa],[cum_power_u cum_power_s],'v')
    plot(kappa,cum_power_s,'v')
    cum_power_ray = 1 - (1-power_ray).^CPS;
    hold on, plot(kappa,cum_power_ray,'^r')
    legend('S test','Rayleigh''s test',2)
    legend('boxoff')
else
%    plot([0 kappa],[cum_power_u cum_power_s])
    plot(kappa,cum_power_s)
    legend('S test',2)
    legend('boxoff')
end    
tbuf = sprintf('Cumulative power computed for %g samples each of n=%g',CPS,n);
title(tbuf), ylabel('cumulative power'), xlabel('kappa')


disp('plotted')
