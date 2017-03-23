function outStruct = GetStructMatSub(structMat,subsMat)
% Given a structure tree with matrices at the conclusion of each branch,
%   returns the submatrix specified by the subsMat.
% SubsMat is an n by 2 mat with the first column
%   designating the dimension of the index in the second column.
% The dims of the matrices in structMat that are specified by subsMat must
%   have the same size across all matrices in structure tree.

outStruct = [];
if ~isstruct(structMat)
    outStruct = NDimSub(structMat,subsMat);
    return
else
    fields = fieldnames(structMat);
    for i=1:length(fields)
        outStruct.(fields{i}) = GetStructMatSub(structMat.(fields{i}),subsMat);
    end
    return
end
