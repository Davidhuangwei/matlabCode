function outStructMat = MatStruct2StructMat(inMatStruct,varargin)
%function outStructMat = MatStruct2StructMat(ins,fields, dims, withind)
%turns a MatStruct (i.e. junk(x,y).a) into a StructMat (i.e. junk.a(x,y)
%for specified fields and dimensions
%first tries Sean's method that should be robust but slow and then try Anton's
%method that is much faster, but not as robust.

try outStructMat = MatStruct2StructMat_smm(inMatStruct,varargin{:});
catch
    fprintf('WARNING: MatStruct2StructMat_smm failed!\n')
    outStructMat = MatStruct2StructMat_ant(inMatStruct,varargin{:});
end
return