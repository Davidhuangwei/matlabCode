function TypeSize = datatypesize(DataType)
% returns the number of byte for a give format
if strcmp(DataType, 'uint8') | strcmp(DataType, 'int8')
    TypeSize = 8;
elseif strcmp(DataType, 'uint16') | strcmp(DataType, 'int16') | strcmp(DataType, 'short')
    TypeSize = 16;
elseif  strcmp(DataType, 'uint32') | strcmp(DataType, 'int32') | strcmp(DataType, 'long')
    TypeSize = 32;
end
TypeSize = TypeSize/8;

