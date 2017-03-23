function t=IntegrateAndFire(input, args);

if nargin<2
	args = '';
end

bsave('input.dat', input, 'double');

cmd = ['!IntegrateAndFire ' args ' < input.dat > spikes.res'];
eval(cmd);
t = load('spikes.res');