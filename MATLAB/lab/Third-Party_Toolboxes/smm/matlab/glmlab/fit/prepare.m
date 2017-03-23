function nlist=prepare(xname)
%PREPARE  Prepares the x-variables named in the glmlab window for later use

%Copyright 1996 Peter Dunn
%11/11/1996

if xname(length(xname))=='''',
   xname=xname(1:length(xname)-1);
end;

xname=strrep(xname,'''',''''''); %replace single quote by double quote
xname(1)='''';
xname(length(xname))='''';

   %replaces the  [  and  ]  by quotes
openb=findstr(xname,'(');
closeb=findstr(xname,')');
comma=findstr(xname,','); 
noch=[];
ch=[];

for ii=1:length(comma),
   for jj=1:length(openb),
      if find((comma(ii)>openb(jj)).*(comma(ii)<closeb(jj))),
      %is comma between brackets?  If so, we don't break there
         noch=[noch,comma(ii)];
      else
         ch=[ch,comma(ii)];
      end;
   end;
end;

if ~isempty(noch),
   for ii=1:length(noch),
      xname(noch(ii))='#';
   end;
end;

xname=strrep(xname,',',''','''); %replace  ,  by  ',']
xname=strrep(xname,'#',',');
nlist=eval(['str2mat(',xname,')']);

pad=blanks(size(nlist,1))';
pad=[pad pad pad pad];
nlist=[nlist,pad,pad,pad,pad]; %Comes in useful later on!
