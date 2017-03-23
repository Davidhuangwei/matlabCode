function string=fixmeup(lstring);
%FIXMEUP Fixes string input in  glmlab: removes spaces, adds commas, brackets

%Copyright 1996, 1997 Peter Dunn
%18 October 1997

string=cel2lstr(lstring);	  %Convert cell to in-line string
string=strrep(deblank(string),'        ',' ');%Remove extraneous spaces
string=strrep(string,'    ',' '); %ditto
string=strrep(string,'  ',' ');   %ditto
string=strrep(string,'  ',' ');   %ditto
string=strrep(string,', ',',');   %Remove spaces near commas
string=strrep(string,' ,',',');   %ditto
string=strrep(string,' ',',');    %Replace remaining spaces with commas
string=strrep(string,',,,,',','); %Replace doubled up commas
string=strrep(string,',,',',');   %Remove double up of commas
string=strrep(string,',,',',');   %ditto

if length(cel2lstr(string))==0,  %if, after all that, its empty: return
   return; 
end;

if strcmp(string(1),','), 
   string(1)=[];                 %remove  ,  at start
end;

if strcmp(string(1),';'),        %remove  ;  at start
   string(1)=[]; 
end;

if strcmp(string(length(string)),','),  %remove  ,  at end
   string(length(string))=[]; 
end;

if strcmp(string(length(string)),';'),  %remove  ;  at end
   string(length(string))=[];
end; 

%string=strrep(string,'''''',''''); %replace '' by '
%string=strrep(string,'''''',''''); %replace '' by '
string=strrep(string,'''''',''); %replace '' by 
string=strrep(string,'''''',''); %replace '' by 

opensb=[]; closesb=[];
opensb=find(string=='[');	  %find opening [
closesb=find(string==']');        %find closing ]


for i=1:length(closesb)-1,

   lowerth=find(opensb<closesb(i));
   loseind=max(lowerth);
   opensb(loseind)=[];

end;


%Remove square brackets if they are at the start and end of the string
%  (ie  [fred,mary]  -->  fred,mary )
if length(opensb)>0,

   if opensb==1,

      if ~isempty(closesb),

         if closesb(length(closesb))==length(string),
            string(1)=[];
            string(length(string))=[];
         end;

      else  %not matching, so delete opening brackets

         string(opensb)=[];

      end;

   end;

end;

tag='';
if strcmp(string(length(string)),''''),
   tag='''';
   string=string(1:length(string)-1); %Remove ' for time being
end;

s2n=str2num(string(1));
if strcmp(string(1),'.'),       %Exceptions: start with dec point
   s2n=1; 
end;

if strcmp(string(1),'-'),       %Exception: start with minus sign
   s2n=1; 
end;

if isempty(s2n),               %then var name used

   string=[deblank(string),tag];

else                           %then something like [1 2 3] used

   string=[ '[' deblank(string) ']',tag]; %Add [ and ] and return transpose character if supplied

end;
