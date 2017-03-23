% function uVdBPow = BitsdBpow2uVdBpow(bitsdBpow,varargin)
% [vRange,nBits,amp] = DefaultArgs(varargin,{[-10 10],16,1000});
function uVdBPow = BitsdBpow2uVdBpow(bitsdBpow,varargin)
[vRange,nBits,amp] = DefaultArgs(varargin,{[-10 10],16,1000});

uVdBPow = bitsdBpow + 10*log10(((abs(diff(vRange))*10^6/amp)/(2^nBits))^2)

return

