function [namelist,intx,xvars,conequiv]=...
         loseint(interaction, varlist,intx,indvec,xvars,namelist,conequiv)
%LOSEINT  Finds the incidence matrix after losing terms due to interactions
%         in  glmlab
%USE:     See function call
%   where   interaction  is the interaction to test (fac(a)@fac(b)@fac(c), eg)
%           varlist  is the lower order ones that could be in  interaction
%              (eg  fac(a),  fac(a)@fac(d)  or fac(b)@fac(c))
%           losemat  is the matrix of terms to lose.
%           intx  is the matrix of the full interaction terms (some to omit)
%           indvec  is the list of indicies (some to omit)
%           xvars  is the full X matrix
%           namelist  is a list of var names to be printed
%           conequiv is 1 if the constant term (or its equivalent) is present

%Copyright 1996 Peter Dunn
%01 August 1997

losemat=[];
intatchar=[findstr(interaction,'@'),length(deblank(interaction))+1];
    %Positions of  @  in interaction
seps=findstr(varlist,'|'); %the separators

for i=1:length(seps)-1, %for each variable...

   %only do for interaction terms lower than that in  interaction
   lowerint=varlist(seps(i)+1:seps(i+1)-1);
   loserow=zeros(1,length(findstr(interaction,'@'))+1);

   atchar=[0,findstr(lowerint,'@'),length(deblank(lowerint))+1];
   %Positions of the  @  in the lower order int
   numats=length(atchar)-1; %the number of  @'s, (# terms)
   if numats<length(intatchar), %for those terms of lower order interaction

      for j=1:numats,

         var=lowerint(atchar(j)+1:atchar(j+1)-1); %var to test for
         there=wildfind(['@',deblank(interaction),'@'],['@',var,'@']);

         if ~isempty(there), %then place it in the right spot
            there=there(1);
            pos=min(find(there<intatchar)); %Finds where to pop the  1
            loserow(pos)=1;
         end;

      end;

      losemat=[losemat;loserow];

   end;

end;

if conequiv,
   losemat=[losemat;ones(1,length(intatchar))];
else
   conequiv=0;
end;

%Now omit what needs to be omitted:  data from X matrix and indicies
%from the index matrix
for i=1:size(losemat,1),
   omitcols=find(losemat(i,:)==1);

   if ~isempty(omitcols),

      testthese=indvec(:,omitcols); 
      testrow=ones(1,size(testthese,2));

      for j=1:size(indvec,1),

         gone(j)=all(testthese(j,:)==testrow);

      end;

      %omit terms from the index matrix
      ggone=gone(1:size(indvec,1));
      indvec(find(ggone==1),:)=[];
      %omit terms from the X matrix
      intx(:,find(ggone==1))=[];

   end;

end;

xvars=[xvars,intx];

%Now fiddle with the variable names
for j=1:size(indvec,1),
   row=''; 
   gorows=(indvec(j,:)~=-1); %where go=0, quant, so fiddle output

   for k=1:size(indvec,2),

      thisint=interaction; thisintlist=[];

      %put each var of interaction into it's own row (for formatting)
      atchar=[0,findstr(thisint,'@'),length(deblank(thisint))+1]; 

      for i=1:length(atchar)-1;
         thisintlist=str2mat(thisintlist,thisint(atchar(i)+1:atchar(i+1)-1));
      end;

      thisintlist(1,:)=[]; %it's empty

      if gorows(k), %Fac
         row=[row,deblank(thisintlist(k,:)),'(',num2str(indvec(j,k)),')@'];
      else, %Quant
         row=[row,deblank(thisintlist(k,:)),'@'];
      end;

   end;

   row=row(1:length(row)-1);
   namelist=str2mat(namelist,strrep(row,',0)',')') );

end;
