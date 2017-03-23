% [R v1 v2] = IntersectRanges(R1, R2)
% R1 and R2 are nx2 arrays giving start and finish times for a set of ranges
% The function returns R, the intersection of these ranges, and "inclusion
% vectors" v1 and v2 which conain 0 or 1 according to whether a subrange
% contributed to the final output
%
% e.g. if R1 = [1 3;10 20; 30 35] and R2 = [2 4; 31 33] then R = [2 3; 31 33].
%
% R1 and R2 should not contain overlapping subranges.

function [Out, v1, v2] = IntersectRanges(R1, R2)

n1 = size(R1, 1);
n2 = size(R2, 1);
v1 = zeros(n1, 1);
v2 = zeros(n2, 1);

Out = [];

for i1=1:n1
	for i2=1:n2
		l = max(R1(i1,1), R2(i2,1));
		r = min(R1(i1,2), R2(i2,2));
		if l<=r
			Out = [Out ; l r];
            v1(i1) = 1;
            v2(i2) = 1;
		end
	end
end