function OUT = SortPoints(VIN)
%% sorts a 2D array into a curve.
%%
%% 

IN=[VIN find(VIN(:,1))];

%if size(IN,2)~=2
%  error('IN has to be 2-column vectors')
%end

yesno = ones(length(IN),1);

%% start with one: 
indx(1) = 0;
gout(1,:) = IN(1,:);
yesno(1) = 0;

[SDIN I] = sortrows([abs((IN(:,1)-gout(1,1)) +i*(IN(:,2)-gout(1,2))) IN(:,3)],1);
gout(2,:) = IN(I(2),:);
yesno(2) = 0;
indx(2) = 1;

for n=3:length(IN);
  [SDIN I] = sortrows([abs((IN(:,1)-gout(n-1,1)) +i*(IN(:,2)-gout(n-1,2))) IN(:,3)],1);
  
  k=2;
  while ~yesno(I(k))
    k=k+1;
  end
  gout(n,:) = IN(I(k),:);
  yesno(I(k)) = 0;
  
  [dummy imin] = min(indx); 
  [dummy imax] = max(indx); 
  Babs = abs((gout(n,1)-gout(imin,1)) +i*(gout(n,2)-gout(imin,2)));
  Eabs = abs((gout(n,1)-gout(imax,1)) +i*(gout(n,2)-gout(imax,2)));
  
  if Babs<Eabs
    indx(n)=min(indx)-1;
  else
    indx(n)=max(indx)+1;
  end
end


OUT=sortrows([gout indx'],4);

%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%



return;

for n=1:length(IN)
  [SDIN I] = sort(abs((IN(:,1)-IN(n,1)) +i*(IN(:,2)-IN(n,2))));
  
  len(n) = sum(SDIN);
  %n
  %if abs(SDIN(3)-SDIN(2))<=SDIN(3)
  %  break;
  %end
end  

gout(1,:) = IN(I(1),:);
indx = ones(length(IN),1);
indx(I(1),1) = 0; 

m=1;
for n=1:length(IN);
  if ~indx(n)
    continue;
  end
  [SDIN I] = sort(abs((IN(:,1)-gout(n,1)) +i*(IN(:,2)-gout(n,2))));
  k=2;
  m=m+1;
  gout(m,:) = IN(I(k),:);
  while ~indx(I(2))
    k=k+1;
    gout(m,:) = IN(I(k),:);
  end
  indx(I(k),1) = 0;
end

return;