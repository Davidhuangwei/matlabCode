%function ind = findincell(x,string)
function ind = findincell(x,string)
ind =[];
n = length(x);
for i=1:n
    if ~isempty(strfind(x{i},string))
        ind(end+1) = i;
    end
end
