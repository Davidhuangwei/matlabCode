%   VMRND2           von Mises distribution random number generator.
%
%       call:   THETA = VMRND(MYU0,KAPPA,N) return a vector of n samples
%               from a von Mises distribution with myu0 and kappa (vectors).
%               VMRND(...,string) also plots.
%
%       string: 'cdf' plots the cdf and the samples on it;
%               'compass' plots the sample on the unit circle;
%               'uniform' chooses N points from a uniform pdf and plots.

% directional statistics package
% Dec-2001 ES

function vm_theta = vmrnd2(myu0,kappa,n,show);

% arguments
if nargin<4
    show = 0;
else
    show = lower(show);
end

if prod(size(myu0))~=prod(size(kappa))
    error('myu0 and k must be vectors of the same length')
end
[s1 s2] = size(n);
if s1~=1 & s2~=1
    error('m may not be a matrix')
end

% calculations
theta = [0.001:0.001:2*pi];
%vm = 1/(2*pi*besseli(0,kappa))*exp(kappa*cos(theta-myu0));
for i=1:length(kappa)
    vm(i,:) = 1/(2*pi*besseli(0,kappa(i)))*exp(kappa(i)*cos(theta-myu0(i)));
end
vm = sum(vm);
cum_vm = cumsum(vm)/sum(vm);
for i=1:n
    rand_num = rand(1);
    if min(cum_vm)<rand_num
        index(i) = max(find(cum_vm<rand_num));
    else
        index(i) = 1;
    end
end
vm_theta = theta(index);

% visuals
% show the distribution and the samples
if strcmp(show,'cdf')
    figure, plot(theta,cum_vm);
    hold on, plot(theta(index),cum_vm(index),'r.')
end

% show it on a circle and compute the parameters
if strcmp(show,'compass')
    dir_mean(vm_theta,ones(length(vm_theta),1),'compass');
    tbuf = sprintf('~VM(%0.3g,%0.3g)+VM(%0.3g,%0.3g), n=%g', myu0(1), kappa(1), myu0(2), kappa(2), n);
    title(tbuf)
end

% select an identical number of samples from a uniform circular pdf
if strcmp(show,'uniform')
    dir_mean(rand(n,1)*2*pi, ones(n,1), 'compass')
    tbuf = sprintf('~U[0,2*pi), n=%g', n);
    title(tbuf)
end