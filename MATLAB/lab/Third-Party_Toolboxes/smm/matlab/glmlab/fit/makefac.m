function x=makefac(size,numlevels,atatime)
%MAKEFAC Generates a qualitative variable (factor).  Like %gl in GLIM
%USE: x=makefac(size,numlevels,blocks)
%      where  x  is the new qualitative variable (factor);
%             size  is the length of x;
%             numlevels  is the number of levels of  x;
%             blocks  is the number of times each level occurs in a row;
%All three inputs are needed.
%
% x=makefac(a,b,c) is equivalent to the GLIM command  $calc x=%gl(b,c) for
% a variable of length of  a (declared with $units ).

%Copyright 1996, 1997 Peter Dunn
%14/05/1997

line=' === ERROR :-< =======================================================';
line2=' =====================================================================';
if nargin==0, 
   help makefac; 
   return;
elseif nargin~=3,
   bell;
   disp(line);
   disp(' makefac  needs three parameters!  It works like this:');
   disp('    makefac(length_of_vector, number_of_levels, block_size)');
   disp(line2);
   return;
end;
if ~all([size>0, atatime>0, numlevels>0])
   bell;
   disp(line);
   disp(' All inputs need to be positive.')
   disp(line2);
   return;
end;

for i=1:size,
   x(i)=rem( floor( (i-1)/atatime)  ,numlevels )+1;
end;

x=x(:);
