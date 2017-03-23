function outStructMat = MatStruct2StructMat_smm(inMatStruct,fields,dims)
%function outStructMat = MatStruct2StructMat_smm(inMatStruct,fields,dims)

if ~exist('fields','var') | isempty(fields)
    fields = [];
end

structVec = inMatStruct(1);
for i=2:numel(inMatStruct)
    structVec = NinjaCat(structVec,inMatStruct(i),fields);
end
  
outStructMat = NinjaReshape(inMatStruct,inMatStruct(1),structVec,fields);

if exist('dims','var') & ~isempty(dims)
    if ndims(inMatStruct) == length(dims)
        outStructMat = NinjaPermute(outStructMat,dims,fields);
    else
        error
    end
end
return


%%%%%%% recursive helper functions %%%%%%%
function outStructVec = NinjaCat(catStructMat1,catStructMat2,fields)
if isstruct(catStructMat2)
    if ~exist('fields','var') | isempty(fields)
        fields = fieldnames(catStructMat2);
    end
    for j=1:length(fields)
        outStructVec.(fields{j}) = NinjaCat(catStructMat1.(fields{j}),catStructMat2.(fields{j}));
    end
else
    %size(catStructMat1(:))
    %size(catStructMat2(:))
    outStructVec = cat(1,catStructMat1(:),catStructMat2(:));
end
return

function outStructMat = NinjaReshape(matStruct,structMat,structVec,fields)
if isstruct(structMat)
    if ~exist('fields','var') | isempty(fields)
        fields = fieldnames(structMat);
    end
    for j=1:length(fields)
        outStructMat.(fields{j}) = NinjaReshape(matStruct,structMat.(fields{j}),structVec.(fields{j}));
    end
else
    if ndims(structMat) == 2 & size(structMat,2) == 1
        reshVec1 = size(structMat,1);
    else
        reshVec1 = size(structMat);
    end
    if ndims(matStruct) == 2 & size(matStruct,2) == 1
        reshVec2 = size(matStruct,1);
    else
        reshVec2 = size(matStruct);
    end
    try outStructMat = reshape(structVec,cat(2,reshVec1,reshVec2));
    catch
        error
%         mfilename
%         fprintf('ERROR!!!\n')
%         keyboard
    end
end
return

function outStructMat = NinjaPermute(inStructMat,dims,fields)
if isstruct(inStructMat)
    if ~exist('fields','var') | isempty(fields)
        fields = fieldnames(inStructMat);
    end
    for j=1:length(fields)
        outStructMat.(fields{j}) = NinjaPermute(inStructMat.(fields{j}),dims,fields);
    end
else
    origDims = 1:ndims(inStructMat);
    newDims(dims) = origDims(end-length(dims)+1:end);
    newDims(setdiff(origDims,dims)) = origDims(1:end-length(dims));
    try outStructMat = permute(inStructMat,newDims);
    catch
        error
%         mfilename
%         fprintf('ERROR!!!\n')
%         keyboard
    end
end
return
