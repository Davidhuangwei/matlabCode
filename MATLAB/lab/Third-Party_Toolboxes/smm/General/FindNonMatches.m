function matching = FindNonMatches(vector1,vector2)
% function matching = FindNonMatches(vector1,vector2)
% returns values that are in vector1 but not vector2

matching = [];
for i=1:length(vector1)
    if isempty(find(vector2 == vector1(i)))
        matching = [matching; vector1(i)];
    end
end
return