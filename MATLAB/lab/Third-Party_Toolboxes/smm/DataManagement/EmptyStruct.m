% function outStruct = EmptyStruct(fieldsCell)
% e.g.
% {{'or','ca1Pyr','rad','lm','mol','gran','hil','ca3Pyr','noLayer'},cellTypeLabels = {'w' 'n' 'x'}}
function outStruct = EmptyStruct(fieldsCell)

if length(fieldsCell)==1
    for j=1:length(fieldsCell{1})
        outStruct.(fieldsCell{1}{j}) = [];
    end
else
    for j=1:length(fieldsCell{1})
        outStruct.(fieldsCell{1}{j}) = EmptyStruct(fieldsCell(2:end));
    end
end
return