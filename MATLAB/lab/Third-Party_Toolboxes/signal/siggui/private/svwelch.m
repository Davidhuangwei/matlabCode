function [errstr,P,f,Pc] = svwelch(x,Fs,valueArray,confidenceLevel)
%SVWELCH spectview Wrapper for Welch's method.
%  [errstr,P,f] = svwelch(x,Fs,valueArray) computes the power spectrum P
%  at frequencies f using the parameters passed in via valueArray:
%
%   valueArray entry     Description
%    ------------         ----------
%          1                Nfft
%          2                Window length
%          3                Window - integer
%                           index into        
%                   {'bartlett' 'blackman' 'boxcar' 'chebwin' ...
%                       'hamming' 'hanning' 'kaiser' 'triang'}
%          4                Window parameter (for chebwin and kaiser)
%          5                overlap - integer
%          6                scaling - integer {'unbiased' 'peaks'}
%
%  [errstr,P,f,Pc] = svwelch(x,Fs,valueArray,confidenceLevel) also computes
%   the confidence interval Pc.

%   Copyright (c) 1988-98 by The MathWorks, Inc.
% $Revision: 1.3 $

errstr = '';
P = [];
f = [];
Pc = [];

windowList = {'bartlett' 'blackman' 'boxcar' 'chebwin' ...
              'hamming' 'hanning' 'kaiser' 'triang'};

switch valueArray{3}
case {4,7}
    windStr = ...
    'window = feval(windowList{valueArray{3}},valueArray{2},valueArray{4});';
otherwise
    windStr = 'window = feval(windowList{valueArray{3}},valueArray{2});';
end

err = 0;
   
eval(windStr,'err = 1;')
if err
   errstr = {'Sorry, couldn''t evaluate window function; error message:'
      lasterr };
   return
end
   
nfft = valueArray{1};
noverlap = valueArray{5};
if nargin == 3
    evalStr = '[P,f] = pwelch(x,nfft,Fs,window,noverlap);';
else
    evalStr = '[P,Pc,f] = pwelch(x,nfft,Fs,window,noverlap,confidenceLevel);';
end

eval(evalStr,'err = 1;')
if err
    errstr = {'Sorry, couldn''t evaluate pwelch; error message:'
               lasterr };
    return
end

switch valueArray{6}
case 1
    normConst = 1;
case 2
    normConst = norm(window)^2/sum(window)^2;
case 3
    normConst = norm(window)^2/(sum(window.^2)*Fs);
end

P = P*normConst;
if nargin == 3
    Pc = Pc*normConst;
end

if nargin == 3
    [P,f] = svextrap(P,f,nfft);
else
    [P,f,Pc] = svextrap(P,f,nfft,Pc);
end

