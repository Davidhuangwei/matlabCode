% p = VonMisesPdf(th,mu,k)
% 
% computes pdf of th according to VonMises(mu,k)
% The size of p is the common size of the input arguments. A scalar input  
% functions as a constant matrix of the same size as the other inputs.    

function p = VonMisesFit(th, mu, k)

[errorcode th mu k] = distchck(3,th, mu, k);

if errorcode > 0
    error('Requires non-scalar arguments to match in size.');
end

p = exp(k.*cos(th-mu))./(2*pi*besseli(0,k));