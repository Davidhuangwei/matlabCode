function [return1,return2]=facfidle(when,i,in1,in2,in3,in4,in5)
%FACFIDLE  Does some fiddling with the factors in glmalb

%Copyright 1996 Peter Dunn
%11/11/1996

if when==1, 				%pre eval-ing

   %Rename the inputs
   conequiv=in1;
   sortlist=in2;
   evallist=in3;

   %Ensure the whole incidence matrix is returned
   evallist(i,:)=strrep(evallist(i,:),')   ',',0) ');

   if conequiv==0,			%Constant equivalent now included
      conequiv=1;
   else					%Since constant equiv includeded, omit first column
      evallist(i,:)=strrep(sortlist(i,:),',0)  ',',1)  ');
   end;

   %Return parameters
   return1=conequiv;
   return2=evallist;

else 					%post eval-ing

   %Rename the inputs
   addx=in1;
   sortlist=in2;
   xvars=in3;
   evallist=in4;
   namelist=in5;

   xvars=[xvars,addx];			%Add next var
   addme=1;				%A fiddle factor

   if ~strcmp(deblank(sortlist(i,:)),deblank(evallist(i,:))),
      addme=0;
   end;

   for j=1:size(addx,2),		%Add each var to list

      userow=sortlist(i,:);		%The row name
      userow=strrep(userow,',0)',')');  %Ensure the  ",0"  component not in the name

      namelist=str2mat(namelist,...     %Add the row name
                       [deblank(userow),...
                       '(',num2str(j+addme),')']);
   end;

   %Return parameters
   return1=namelist;
   return2=xvars;

end;
