function NMM = MinMaxClean(MM,fintpos)
%% function NMM = MinMaxClean(MM)
%% 
%% MM: 
%%
%%
%% clean up extrema

NMM=[];
j=1;
i=2;

%NMM(1,:) = MM(1,:);
kk = MM(1,:);

while i<=length(MM)
  %kk=MM(i,:);
  l=1;
  while (MM(i,2)==MM(i-1,2) & i<=length(MM))
    mm = fintpos(MM(i-1,1));
    zz = fintpos(MM(i,1));
    if MM(i,2)==-1
      if zz<mm;
	kk = MM(i,:);
      end
    elseif MM(i,2)==1
      if zz>mm;
	kk = MM(i,:);
      end
    end
    i=i+1;
  end
  NMM(j,:) = kk;
  kk=MM(i,:);
  i=i+1;
  j=j+1;
end

if ~(MM(end,2)==MM(end-1,2))
   NMM(j+1,:) = MM(end,2);
end
  
  
return;

NMM=[];
j=1;
i=1;
while i<length(MM)
  kk=MM(i,:);
  l=1;
  mm = fintpos(MM(i,1));
  while (MM(i,2)==MM(i+1,2) & i< length(MM))
    i=i+1;
    zz = fintpos(MM(i,1));
    if MM(i,2)==-1
      if zz<mm;
	kk = MM(i,:);
      end
    elseif MM(i,2)==1
      if zz>mm;
	kk = MM(i,:);
      end
    end
  end
  NMM(j,:) = kk;
  i=i+1;
  j=j+1;
end

return;