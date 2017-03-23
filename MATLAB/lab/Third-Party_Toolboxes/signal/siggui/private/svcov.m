function [errstr,P,f] = svcov(x,Fs,valueArray)
%SVCOV spectview Wrapper for Covariance method.
%  [errstr,P,f] = SVCOV(x,Fs,valueArray) computes the power spectrum P
%  at frequencies f using the parameters passed in via valueArray:
%
%   valueArray entry     Description
%    ------------         ----------
%          1                Order
%          2                Nfft

%   Copyright (c) 1988-98 by The MathWorks, Inc.
% $Revision: 1.1 $ $Date: 1998/05/22 20:06:53 $

errstr = '';
P = [];
f = [];

order = valueArray{1};
nfft  = valueArray{2};
evalStr = '[P,f] = pcov(x,order,nfft,Fs);';

err = 0;
eval(evalStr,'err = 1;')
if err,
    errstr = {'Sorry, couldn''t evaluate pcov; error message:'
               lasterr };
    return
end

[P,f] = svextrap(P,f,nfft);

