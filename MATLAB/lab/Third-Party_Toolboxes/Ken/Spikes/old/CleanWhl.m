% [CleanWhl GoodRanges] = CleanWhl(Whl, StretchLen);
%
% "cleans up" a wheel file by interpolating missing stretches
% up to StretchLen long (default 100)
%
% also returns the ranges where the whl file is valid (in .whl units)
% GoodRanges which gives start and end samples of the good ranges
% (so Whl(GoodRanges) has no -1 values).

function [cWhl, GoodRanges] = CleanWhl(Whl, StretchLen, JumpSize);

if nargin<2
	StretchLen = 100;
end

% find points that are not -1 and no big jumps (the rat can't move 3cm in 25 ms)
BigJump = abs(diff(Whl(:,1)))>10 | abs(diff(Whl(:,2)))>10;
Good = find(Whl(:,1)>-1 & ~([BigJump;0] | [0;BigJump]));


% interpolate missing values
cWhl = round(interp1(Good, Whl(Good,:), 1:size(Whl,1), 'linear', -1));

% now overwrite bad bits

dGood = [-(Whl(1,1)==-1) ; diff(Whl(:,1)>-1)];

BadStart = find(dGood<0);
BadEnd = find(dGood>0)-1;

% if last point is bad, need to finish off BadEnd
if Whl(end,1)==-1
	BadEnd = [BadEnd; size(Whl,1)];
end

TooLong = find(BadEnd-BadStart>StretchLen);
for i=TooLong(:)'
	cWhl(BadStart(i):BadEnd(i),:) = -1;
end

WhlGood = [0 ; Whl(:,1)~=-1; 0];
dWhlGood = diff(WhlGood);
GoodStart = find(dWhlGood==1);
GoodEnd = find(dWhlGood==-1)-1;
LongEnough = (GoodEnd-GoodStart)>StretchLen;
GoodRanges = [GoodStart(LongEnough), GoodEnd(LongEnough)]; % in .whl units
