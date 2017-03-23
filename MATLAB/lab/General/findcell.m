%function res = findcell(a,what,operation)
%does find for cell araary a
%operation is : 'eq' or 'neq'
function res = findcell(a,what,operation)
res=[];
if strcmp(operation,'eq')
    for ii=1:length(a)
        if (a{ii}==what)
            res(end+1)=ii;
        end
    end
elseif strcmp(operation, 'neq')
   for ii=1:length(a)
     if (a{ii}~=what)
        res(end+1)=ii;
     end
   end
end

if nargout<1
    display(res);
end