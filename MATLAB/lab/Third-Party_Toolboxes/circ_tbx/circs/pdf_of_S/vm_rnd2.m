%   VM_RND          A second attempt.

% directional statistics package
% Dec-2001 ES

function vm_theta = vm_rnd2(myu0,kappa,m,show);

if nargin<4
    show = 0
end
if prod(size(myu0))~=1 | prod(size(kappa))~=1
    error('myu0 and k must be scalars')
end
[s1 s2] = size(m);
if s1~=1 & s2~=1
    error('m may not be a matrix')
end

theta = [0.001:0.001:2*pi];
%sl = length(theta);
vm = 1/(2*pi*besseli(0,kappa))*exp(kappa*cos(theta-myu0));

figure, plot(theta,cum_vm);

cum_vm = cumsum(vm)/sum(vm);
for i=1:m
    index(i) = max(find(cum_vm<rand(1)));
end
vm_theta = theta(index);

% [yy,xx] = cdfcalc(vm);
% % Create vectors
% k = length(xx);
% n = reshape(repmat(1:k, 2, 1), 2*k, 1);
% xCDF    = [-Inf; xx(n); Inf];
% yCDF    = [0; 0; yy(1+n)];
%
%
% index = round(rand(m,1)*2*sl);
% rnd = xCDF(index);
%
% % figure, subplot(2,2,1), hCDF = plot(xCDF , yCDF);
% % tbuf = sprintf('myu0 = %0.3g, kappa = %0.3g', myu0, kappa);
% % title(tbuf)
% % subplot(2,2,2), hist(rnd)
% % subplot(2,2,3), hist(xCDF(2:end-1))
% % subplot(2,2,4), hist(vm)
%
% % since the distribution is symmetrical, we choose a direction
% dir = 2*round(rand(m,1))-1;
% vm_theta = mod((myu0 + 2*pi*dir.*rnd/(xCDF(end-1)-xCDF(2))),2*pi);
%
% % temp = acos( (log(rnd*2*pi*besseli(0,kappa)))/kappa );
% %
% % % since acos is ambiguous, we choose a direction
% % dir = round(rand(m,1)); % if 0 - myu0+temo; if 1 - myu0+2*pi-temp
% % vm_theta = myu0 + dir*2*pi + ~dir.*temp - dir.*temp;
% % vm_theta = mod(vm_theta,2*pi);

if show
    dir_mean(vm_theta,ones(length(vm_theta),1),'compass');
    tbuf = sprintf('myu0 = %0.3g, kappa = %0.3g, n=%g', myu0, kappa, m);
    title(tbuf)

    dir_mean(rand(m,1)*2*pi, ones(m,1), 'compass')
    tbuf = sprintf('~U[0,2*pi), n=%g', m);
    title(tbuf)
end