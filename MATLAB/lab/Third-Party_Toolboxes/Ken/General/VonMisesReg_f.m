function f=VonMisesReg_f(v, th, x)
% callback for VonMisesReg

g = inline('2*atan(x)');
dg = inline('2./(1+x.*x)');

f = -sum(cos(th-v(1)-g(x*v(2:end)')));

b = v(2:end); mu = v(1);
%return
hold off; plot(x(:,1), mod(th,2*pi), '.', 'markersize', 1);
xr = sort(x);
hold on; plot(xr(:,1), mod(mu+g(xr*b'),2*pi), 'r');
drawnow