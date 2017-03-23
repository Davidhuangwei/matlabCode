function names = geteegfilenames()
% returns a matrix with each row containing the basename of each .eeg file in the current directory 
ls --quoting-style=c *.eeg
a = ans;
f = find(a=='"');
numentries = length(f)
for i=1:2:numentries;
    names((i+1)/2,:) = a(f(i)+1:f(i+1)-5);
end
return