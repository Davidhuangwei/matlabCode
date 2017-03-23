function FindSessionsKenji

list =  LoadStringArray('KenjiList.txt');

for n=1:length(list)
  
  inlist = LoadStringArray([list{n} '/mylist.txt']);
  
  Sessions=FindSessions(list{n},inlist)
  
end
