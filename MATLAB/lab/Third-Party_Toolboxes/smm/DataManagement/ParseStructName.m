function fieldNamesCell = ParseStructName(inText)
% given 'happy.joy.love' returns {'happy','joy','love'}

cellNum = 1;
fieldNamesCell = {};
for i=1:length(inText)
    if strcmp(inText(i),'.')
        cellNum = cellNum + 1;
    else
        if isempty(fieldNamesCell) | size(fieldNamesCell,2) < cellNum
            fieldNamesCell{cellNum} = inText(i);
        else
            fieldNamesCell{cellNum} = [fieldNamesCell{cellNum} inText(i)];
        end
    end
end
