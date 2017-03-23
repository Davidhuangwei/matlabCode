function [introws,facrows,otherrows,sortlist]=findvars(namexv)
%FINDVARS  Finds the location of different types of x-variables in glmlab

%introws  contains the row numbers of  sortlist  that contain interactions
%facrows  contains the row numbers of  sortlist  that contains factors
%otherrows  contains the row numbers of  sortlist  that contain other vars
%sortlist  is the list of vars sorted in order:  
%  quant vars, factors, interactions in increasing order

%Copyright 1996--1999 Peter Dunn
%05 February 1999

%Prepare namexv for use elsewhere:

namexv=strrep(namexv,'''','''''');           %replace single by double quote
namexv(1)='''';
namexv(length(namexv))='''';

nlist=lstr2cel(namexv);
p=blanks(size(nlist,1))';
p=[p p p p];
nlist=[char(nlist),p,p,p,p];         	%Comes in useful later on!

%Now find where the interactions are (finding '@') and where the
%factors are (finding 'fac(', not in '@' rows of course).
introws=[];
facrows=[];
otherrows=[];

for II=1:size(nlist,1),

   if findstr('@',nlist(II,:)),		%Interaction rows found by 
      introws=[introws,II];             %search for @
   else

      if findstr('fac(',nlist(II,:)),	%factor found by searching 
         facrows=[facrows,II];          %for  fac
      else
         otherrows=[otherrows,II];	%All the other rows.
      end;

   end;

end;

[dummy,ll]=sort([otherrows,facrows,introws]);	%sort in types
[dummy,ll]=sort(ll);
sortlist=nlist(ll,:);
  
introws=[];
facrows=[];
otherrows=[];

%place rows into their categories
for i=1:size(sortlist,1),

   if findstr('@',sortlist(i,:)),
      introws=[introws,i];
   else
      if findstr('fac(',sortlist(i,:)),
         facrows=[facrows,i];
      else
         otherrows=[otherrows,i];
      end;
   end;

end;

numintvars=[];

if length(introws)>0,

   for i=1:length(introws),
      numintvars(i)=length(findstr(...
                      sortlist(introws(i),:),'@'))+1;
   end;

   [dummy, intorder]=sort(numintvars);	%Sort interaction variables

   introws = introws(intorder);
   introws = [min(introws(:)):max(introws(:))];
   %introws = [min(introws):max(introws)];

   s=sortlist(introws,:); 
   s=s(intorder,:); 
   sortlist(introws,:)=s;

end;

return

%introws now orders the interaction rows in increasing order
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Also should sort quant.quant; quant.qual qual.qual etc...%
%one day, but it's no real drama.                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
