function df=VonMisesReg_df(v, th, x)
% derivative callback for VonMisesReg

g = inline('2*atan(x)');
dg = inline('2./(1+x.*x)');

xb = x*v(2:end)';
gxb = g(xb);

dmu = -sum(sin(th-v(1)-gxb)); % d/dmu term

db = -sum(repmat(sin(th-v(1)-gxb).* dg(xb), 1, size(x,2)).*x);

df = [dmu db];