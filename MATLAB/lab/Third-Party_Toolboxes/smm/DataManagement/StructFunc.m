% function outStruct = StructFunc(funcHandle,inStruct1,inStruct2)
% Performs: outStruct = funcHandle(inStruct1,inStruct2)
%
% inStruct1 and/or inStruct2 can be a constant.
% e.g. 5 = StructFunc(@plus,2,3)
%
% if inStruct1 and inStruct2 are structs they must both have the same 
% number of branches or a constant and each branch point 
%
% e.g. outStruct = StructFunc(@plus,struct1,struct2)
% struct1.a.j = 5
% struct1.a.k = 10
% struct2.a.j = 1
% struct2.a.k = 3
% outStruct.a.j = 6
% outStruct.a.k = 13
%
% e.g. outStruct = StructFunc(@plus,struct1,struct2)
% struct1.a.j = 5
% struct1.a.k = 10
% struct2.a = 3
% outStruct.a.j = 8
% outStruct.a.k = 13
%
% e.g. outStruct = StructFunc(@plus,struct1,struct2)
% struct1.a.j = 5
% struct1.a.k = 10
% struct2.a.j = 3
% ERROR

function outStruct = StructFunc(funcHandle,inStruct1,inStruct2)

outStruct = [];

if ~isstruct(inStruct1) & ~isstruct(inStruct2) % terminal condition
    outStruct = funcHandle(inStruct1,inStruct2);
elseif isstruct(inStruct1) & isstruct(inStruct2)
        structFields1 = fieldnames(inStruct1);
        structFields2 = fieldnames(inStruct2);
        if strcmp(structFields1,structFields2)
            for j=1:length(structFields1)
                outStruct.(structFields1{j}) = StructFunc(funcHandle,...
                    inStruct1.(structFields1{j}),inStruct2.(structFields1{j}));
            end
        else
            ERROR_MISSING_FIELDS
        end
elseif isstruct(inStruct1)
    structFields1 = fieldnames(inStruct1);
    for j=1:length(structFields1)
        outStruct.(structFields1{j}) = StructFunc(funcHandle,...
            inStruct1.(structFields1{j}),inStruct2);
    end
else isstruct(inStruct2)
    structFields2 = fieldnames(inStruct2);
    for j=1:length(structFields2)
        outStruct.(structFields2{j}) = StructFunc(funcHandle,...
            inStruct1,inStruct2.(structFields2{j}));
    end
end
return