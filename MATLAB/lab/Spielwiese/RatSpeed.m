function speed = RatSpeed(whldata,varargin)
[whlSamp,smoothlen] = DefaultArgs(varargin,{39.0625,250});
%% function [speed, accel] = RatSpeed(whldata,varargin)
%% [whlSamp,smoothlen] = DefaultArgs(varargin,{39.0625,21});
%%
%% Calculates running speed from nx2 position matrix
%%
%% whlSamp:     whl sampling rate
%% smoothlen:   smoothing length for hanning window in ms. 
%%
%% ountput:     amplitude and phase of speed

% number of points for smoothlen:
smoothlen = round(smoothlen*whlSamp/1000);

% filter whldata in x and y with a hanning window 
findex = find(whldata(:,1)>0);
hanfilter = hanning(smoothlen);
hanfilter = hanfilter./sum(hanfilter);

whldata(findex,1) = Filter0(hanfilter,whldata(findex,1));
whldata(findex,2) = Filter0(hanfilter,whldata(findex,2));

%calculate speed for values that aren't -1 or distorded by filtering
intval = findex(ceil(smoothlen/2):end-ceil(smoothlen/2));
speeddata(:,1) = diff(whldata(intval,1)) + i*diff(whldata(intval,2));

Amp = abs(speeddata)*whlSamp;
Phase = mod(angle(speeddata),2*pi);

speed = -ones(size(whldata));
speed(intval(1:end-1),:) = [Amp Phase];

return;
