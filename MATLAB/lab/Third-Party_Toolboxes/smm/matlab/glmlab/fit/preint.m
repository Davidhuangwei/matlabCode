function intterm=preint(sortlist,i)
%PREINT  Does the work before  interact  is called in xvarcont in  glmlab

%Copyright 1996 Peter Dunn
%11 Nov 1996

userow=['@',deblank(sortlist(i,:)),'@'];
atchar=findstr(userow,'@');
allvars=wildfind(userow,'@*@');

%First ensure that all fac-ing is with  ,0  option
facterms=wildfind(userow,'fac(*)')-1; %Terms with factors
okterms=wildfind(userow,'fac(*,0)')-1; %Those already ,0)-ed

   %And now find quant terms
loose=zeros(size(allvars,1),1);

if ~isempty(facterms),
   for j=1:size(allvars,1),
      loose(j)=sum(allvars(j,1)==facterms(:,1));
   end;
end;

loose=[];

for j=1:size(okterms,1),
   loose=[loose;find(facterms(:,1)==okterms(j,1))];
end;

intterm='';

if ~isempty(loose),
   facterms(loose,:)=[];
end;

if ~isempty(facterms),
   intterm=mystrrep(sortlist(i,:),facterms(:,2)',',0)');
else
   intterm=sortlist(i,:);
end;

intterm=strrep(intterm,'@',',');

%%%SUBFUNCTION mystrrep
function s=mystrrep(s1,pos,s3)
%MYSTRREP Replaces strings given their _position_
%USE      s=mystrrep(s1,pos,s3) replaces s1(pos) with s3.
%         pos  is a vector of positions in string  s1  to change to string  s3.

%Copyright 1996 Peter Dunn
%11 Nov 1996

if (pos>length(s1))|(pos<1),
   error('Can''t replace a position that doesn''t exist!');
end;

s=s1;
pos=sort(pos);
tpos=pos;
delta=0;

for i=1:length(pos),
   s=[s(1:tpos(i)-1),s3,s(tpos(i)+1:length(s))];
   delta=delta+length(s3)-1;tpos=pos+delta;
end;
