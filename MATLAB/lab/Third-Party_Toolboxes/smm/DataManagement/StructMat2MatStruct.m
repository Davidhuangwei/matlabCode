function matStruct = StructMat2MatStruct(structMat,extractDims)
%function matStruct  = StructMat2MatStructTest(structMat,extractDims)
% input: requires a structure tree in which each branch concludes in a
% matrix of equal size.
% performs: matStruct(x,y,z).a.b = structMat.a.b(x,y,z)
% for all subfields of structure and all dims of matrix.
% **updated to extract particular dimensions
endhelp=1;

% get the sizes of the mats in the struct tree
fieldSizes = StructFieldSizes(structMat);
if ~exist('extractDims','var') | isempty(extractDims)
    extractDims = 1:length(fieldSizes{1});
end

% check they are all the same size
for i=1:length(fieldSizes)
    try
        if fieldSizes{i}(extractDims) == fieldSizes{1}(extractDims)
        else
            fprintf('ERROR: all data must be the same size: [ ')
            fprintf('%i ',fieldSizes{i}(extractDims));
            fprintf('] ~= [ ');
            fprintf('%i ',fieldSizes{1}(extractDims));
            fprintf(']\n');
            error('EXITING...')
        end
    catch
        fprintf('ERROR: all data must be the same size: [ ')
        fprintf('%i ',fieldSizes{i});
        fprintf('] ~= [ ');
        fprintf('%i ',fieldSizes{1});
        fprintf(']\n');
        error('EXITING...')
    end
end

indexesMat = MakeSubs(fieldSizes{1}(extractDims));
if length(extractDims) == 1
    matStruct = cell(fieldSizes{1}(extractDims),1);    
else
    matStruct = cell(fieldSizes{1}(extractDims));
end
for i=1:size(indexesMat,1)
    matStruct{SubsVec2Ind(fieldSizes{1}(extractDims),indexesMat(i,:))} = ...
        GetStructInd(structMat,[extractDims' indexesMat(i,:)']);
end
matStruct = cell2mat(matStruct);

return

% function fieldSizes = StructFieldSizes(structMat)
% returns sizes of teminal fields in a cell array vector 
function fieldSizes = StructFieldSizes(structMat)
fieldSizes = {};
if ~isstruct(structMat)
    fieldSizes = {size(structMat)};
    return
else
    fields = fieldnames(structMat);
    for i=1:length(fields)
        fieldSizes = cat(1,fieldSizes,StructFieldSizes(structMat.(fields{i})));
    end
end

function outStruct = GetStructInd(structMat,indexMat)
outStruct = [];
if ~isstruct(structMat)
    outStruct = NDimSub(structMat,indexMat);
    return
else
    fields = fieldnames(structMat);
    for i=1:length(fields)
        outStruct.(fields{i}) = GetStructInd(structMat.(fields{i}),indexMat);
    end
    return
end

%function indexes = MakeSubs(dimVector)
% Makes a matrix of indexes for a matrix of dims specified by dimVector
function indexes = MakeSubs(dimVector)
indexes = [];
if ndims(dimVector) < 2 | (ndims(dimVector)==2 & size(dimVector,2)==1)
    indexes = [1:dimVector(1)]';
else
    for i=1:dimVector(1)
        tempInd = MakeSubs(dimVector(2:end));
        indexes =  cat(1,indexes,cat(2,repmat(i,size(tempInd,1),1),tempInd));
    end
end
