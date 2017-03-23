function [intmat,indvec]=interact(varargin)
%INTERACT Interactions for interacting terms in  glmlab.
%USE:    [intmat, indvec]=interact(v1,v2, ... )
%   where  v1, v2, ... are the variables to interact
%          intmat  is the resultant incidence matrix;
%          indvec  is the matrix of  matrix indicies.
%EXAMPLE:  To find the interaction between a (qual), b (qual)
%          and c (quantitative), use:
%             interact(fac(a), fac(b), c);

%This seems very slow code, but it is a general routine allowing
%for many levels of interactions. 

%Copyright 1996, 1997 Peter Dunn
%06 October 1997

num_vars=length(varargin);

lengths=zeros(1,num_vars);
for i=1:num_vars,

   eval(['v',num2str(i),'=varargin{',num2str(i),'};']);
   eval(['lengths(i)=size(v',num2str(i),',2);']);

end;

matl=prod(lengths);

%intmat
intmat=kron(v1,ones(1,matl/size(v1,2)));
index1=size(v1,2);index2=matl/size(v1,2);

for i=2:num_vars,

   eval(['ll=size(v',num2str(i),',2);']);
   index2=index2/ll;
   eval(['newmat=kron(ones(1,index1),kron(v',num2str(i),',ones(1,index2)));']); 
   intmat=intmat.*newmat;
   index1=index1*ll;

end;

for i=1:num_vars,
   indvec(:,i)=makefac(matl,lengths(i),matl/prod(lengths(1:i)));
end;

%Now some fiddles for when quantitative variables are interacted
%(The guts of glmlab understands negative indicies to be ignored, for
% the case when quantitative vars interact.)
for i=1:size(indvec,2),
   if all(indvec(:,i)==1), indvec(:,i)=-indvec(:,i); end;
end;
