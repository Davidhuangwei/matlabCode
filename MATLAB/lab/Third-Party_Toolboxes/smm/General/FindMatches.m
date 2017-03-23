function matching = FindMatches(vector1,vector2)

matching = [];
for i=1:length(vector1)
    if ~isempty(find(vector2 == vector1(i)))
        matching = [matching; vector1(i)];
    end
end
return