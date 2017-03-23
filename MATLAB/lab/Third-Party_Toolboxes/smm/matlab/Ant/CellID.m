function cID = CellID(FileBase,elID,cluID)
%function cID = CellID(FileBase,elID,cluID)
% assumes number of clusters and electrodes less then 100 :))
fID = uniquefn(FileBase);
fIDs = addzero(fID);
elIDs = addzero(elID);
cluIDs = addzero(cluID);

cID = str2num(sprintf('%s%s%s',fIDs,elIDs,cluIDs));
tmp = ones(1,1,'int32');
cID = tmp*cID;
if nargout<1
    fprintf('%10.0f\n',cID);
end


function as=addzero(a)
as = num2str(a);
if length(as)<2
    as = ['0' as];
end
return
    