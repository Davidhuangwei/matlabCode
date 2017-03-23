%
% perminv - returns the inverse permutation vector
%
% [invvec] = perminverse(vector);
%

% Scott Makeig 11-30-96 CNL / Salk Insitute, La Jolla
% 4-4-97 shortened name to perminv() -sm
% 4-7-97 allowed row vector, added tests -sm

function [invvec]=perminv(vector)

[n,c] = size(vector);
if n>1 & c>1,
    fprintf('perminv(): input must be a vector.\n');
	return
end
transpose=0;
if c>1
	vector = vector';
	transpose =1;
end

invvec = zeros(size(vector));
for i=1:length(vector)
  invvec(vector(i)) = i;
end;

if transpose==1,
	invvec = invvec';
end
