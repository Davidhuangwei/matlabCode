function names = getdatfilenames(orderbool,regEx,index1,index2)
% Returns a matrix with each row containing the basename of each file in the current directory 
% that matches the regular expression regEx
% If the orderbool = 1 the output is ordered based on the number found
% between index1 & index2 in each filename

eval(['ls --quoting-style=c ' regEx]);
a = ans;
f = find(a=='"');
numentries = length(f);
for i=1:2:numentries;
    names((i+1)/2,:) = a(f(i)+1:f(i+1)-5);
end

if exist('orderbool', 'var')
    [m n] = size(names);
    numbers = str2num(names(:,index1:index2));
    [junk orderindex] = sort(numbers);
    names = names(orderindex,:);
end
    
return