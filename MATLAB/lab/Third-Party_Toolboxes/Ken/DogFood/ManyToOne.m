% [Index1 Index2] = ManyToOne(Many, One)
%
% finds arrays such that Many(Index1) = One(Index2).
%
% you can do a similar thing with intersect but the difference
% is that there, if there are several elemnts of Many that correspond
% to one in One, only one match would be reported.
%
% nb if elements of One are not unique, the first one will be used

function [Index1, Index2] = ManyToOne(Many, One)

Many = Many(:);
One = One(:);

nMany= length(Many);
nOne = length(One);

[b i j] = unique([Many;One]);

LastPos = i(j); % the last point in [Many;One] where element occurs

Index1 = find(LastPos(1:nMany)>nMany);
Index2 = LastPos(Index1)-nMany;