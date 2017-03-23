function  makeparfiles()
%makes a par file for each .dat file in directory
ls --quoting-style=c *.dat
a = ans;
f = find(a=='"');
numentries = length(f);
for i=1:2:numentries;
     names((i+1)/2,:) = a(f(i)+1:f(i+1)-5);
end
     [names_m n] = size(names);
for(i=1:names_m)
     parfileid = fopen([names(i,:) '.par'],'w');
     fprintf(parfileid,'97 16\n');
     fprintf(parfileid,'50 800\n');
     fprintf(parfileid,'1\n');
     fprintf(parfileid,'96\n');
     fprintf(parfileid,'1\n');
     fprintf(parfileid,'%s\n',names(i,:));
     fclose(parfileid);
end




