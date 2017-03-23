% [Out FromSub RecNo] = CatStructArray(In)
% takes a vector of structure arrays and concatenates them into
% one big structure array.
%
% i.e Out.field1 = [Out(1).field1 Out(2).field1 ...]
% Out.field2 = [Out(1).field2 Out(2).field2 ...]
% etc.
%
% each field in each structure must be a vector, and all the
% fields in one structure must be the same length.
%
% optional output FromSub which counts which structure it was from
% optional output RecNo keeps track of global record numbers

function [Out, FromSub, RecNo] = CatStructArray(In)

FromSub = [];
Out = [];
RecNo = []; LastRec = 0;
Names = fieldnames(In(1));
for i=1:length(In)
	s = In(i);
	if ~isequal(fieldnames(s), Names)
		error('All structs must have the same fields');
	end

    len = length(getfield(s, Names{1}));
	for n=1:length(Names);
		Name = Names{n};
		new = getfield(s, Name);
        
        if len~=length(new)
            error('All substructures must have the same length');
        end
        
        if i==1
			subsasgn(Out, struct('type', '.', 'subs', Name), new(:));
		else
			subsasgn(Out, struct('type', '.', 'subs', Name), [getfield(Out, Name); new(:)]);
       end
              
   end
   
   FromSub = [FromSub; ones(len,1)*i];
   RecNo = [RecNo; LastRec+(1:len)'];
   LastRec=LastRec+len;

end
