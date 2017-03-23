function names = getfilenames(regEx,orderIndexes)
% Returns a matrix with each row containing the basename of each file in the current directory 
% that matches the regular expression regEx
% If the orderIndexes are given the output is ordered based on the number found
% between index1 & index2 in each filename

eval(['ls --quoting-style=c ' regEx]);
a = ans;
f = find(a=='"');
numentries = length(f);
for i=1:2:numentries;
    names((i+1)/2,:) = a(f(i)+1:f(i+1)-5);
end

if exist('orderIndexes', 'var')
    orderIndexes
    [m n] = size(names);
    numbers = str2num(names(:,orderIndexes(1):orderIndexes(1)));
    [junk orderindex] = sort(numbers);
    names = names(orderindex,:);
end
    
return