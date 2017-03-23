% function mVdata = Bits2mV(bitsData,varargin)
% [vRange,nBits,amp] = DefaultArgs(varargin,{[-10 10],16,1000})
function mVdata = Bits2mV(bitsData,varargin)
[vRange,nBits,amp] = DefaultArgs(varargin,{[-10 10],16,1000});


mVdata = bitsData*abs(diff(vRange))/(2^nBits)/amp*1000;
return

