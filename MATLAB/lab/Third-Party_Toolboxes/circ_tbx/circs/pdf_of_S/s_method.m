%   S_METHOD        Explains the S method by examples (uniform, von Mises).
%
%       See COMP_CIRC_VAR, PLOT_S, VMRND.

% directional statistics package
% Dec-2001 ES

function s_method(n,myu0,kappa,NS,show);

% arguments
if nargin<5
    all = 0;
else
    all = 1;
end

% compute the cdf
reps = 100000; % use 100,000
x = rand(reps,n)*2*pi;
temp = comp_circ_var(x);
[yy,xx,rs,emsg] = cdfcalc(temp);

% compute S and its p value for a random uniform sample
uniform_theta = rand(n,1)*2*pi;
if all
    S_uniform = plot_s(uniform_theta,'compass','r');
    tbuf = sprintf('~U[0,2*pi), n=%g', n);
    title(tbuf)
else
    S_uniform = plot_s(uniform_theta);
end    
index_uniform = min(find(xx>S_uniform));
p_uniform = yy(index_uniform);

% do the same for a random von Mises sample
vm_theta = vmrnd(myu0,kappa,n);
if all
    S_vm = plot_s(vm_theta,'compass','k');
    tbuf = sprintf('~M(%0.3g,%0.3g), n=%g', myu0, kappa, n);
    title(tbuf)
else
    S_vm = plot_s(vm_theta);
end
index_vm = min(find(xx>S_vm));
p_vm = yy(index_vm);

% now repeat the process for NS samples from each distribution
for i=1:NS
    uniform_theta = rand(n,1)*2*pi;
    S_uniform = plot_s(uniform_theta);
    index_uniform_samples(i) = min(find(xx>S_uniform));

    vm_theta = vmrnd(myu0,kappa,n);    
    S_vm = plot_s(vm_theta);
    index_vm_samples(i) = min(find(xx>S_vm));
end


% plot the cdf and the 2 samples
figure, plot([0;xx],yy)
hold on, plot(xx(index_uniform),yy(index_uniform),'ro')
hold on, plot(xx(index_vm),yy(index_vm),'ko')

% and superimpose the 2*NS additional samples
if NS
    dely = 0.02;
    hold on, 
    line([xx(index_uniform_samples)'; xx(index_uniform_samples)']...
        ,[yy(index_uniform_samples)'+dely; yy(index_uniform_samples)'-dely]...
        ,'Color',[1 0 0]) % red
    p_uniform_mean = mean([yy(index_uniform_samples);yy(index_uniform)]);
    p_uniform_std = std([yy(index_uniform_samples);yy(index_uniform)]);

    hold on, 
    line([xx(index_vm_samples)'; xx(index_vm_samples)']...
        ,[yy(index_vm_samples)'+dely; yy(index_vm_samples)'-dely]...
        ,'Color', [0 0 0]) % black
    p_vm_mean = mean([yy(index_vm_samples);yy(index_vm)]);
    p_vm_std = std([yy(index_vm_samples);yy(index_vm)]);
    
    set(gca,'YLim',[0 1])
    tbuf = sprintf('n=%g, p(~M)=%0.3g (%0.3g+-%0.3g, n=%g), p(~U)=%0.3g (%0.3g+-%0.3g , n=%g), reps=%g'...
        ,n,  p_vm, p_vm_mean, p_vm_std, NS+1,  p_uniform, p_uniform_mean, p_uniform_std, NS+1, reps);
else
    tbuf = sprintf('n=%g, p(~M)=%0.3g, p(~U)=%0.3g, reps=%g', n, p_vm, p_uniform, reps);
end

title(tbuf), xlabel('S'), ylabel('F(S)')
legend('cdf(S)','S(uniform)','S(von Mises)',2)
legend('boxoff')

% plot the power histograms and compute the power of each alternative
figure
subplot(2,1,1), hist([yy(index_uniform_samples);yy(index_uniform)],[0.025:0.05:0.975])
power_u = sum([yy(index_uniform_samples);yy(index_uniform)]<0.1)/(NS+1);
tbuf = sprintf('Monte Carlo simulations - %g repetitions, H1=~U, n=%g, power=%0.3g',NS+1,n,power_u);
title(tbuf), xlabel('S'), ylabel('counts')

subplot(2,1,2), hist([yy(index_vm_samples);yy(index_vm)],[0.025:0.05:0.975])
power_vm = sum([yy(index_vm_samples);yy(index_vm)]<0.1)/(NS+1);
tbuf = sprintf('Monte Carlo simulations - %g repetitions, H1=~VM(%0.3g,%g), n=%g, power=%0.3g',NS+1,myu0,kappa,n,power_vm);
title(tbuf), xlabel('S'), ylabel('counts')

disp('plotted')
