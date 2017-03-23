function textOut = SaveTheUnderscores(textIn)
%pass a text string or a cell array of text strings and all "_" will be
%replaced by "\_" and returned
% tag:underscore
% tag:text
% tag:save
if isempty(textIn)
    textOut = textIn;
elseif iscell(textIn) 
    for j=1:length(textIn)
        newTextIn = textIn{j};
        underscorePos = find(newTextIn == '_');
        if isempty(underscorePos)
            textOut = newTextIn;
        else
            textOut = [];
            beginPos = 1;
            for i=1:length(underscorePos)
                textOut = [textOut newTextIn(beginPos:underscorePos(i)-1) '\'];
                beginPos = underscorePos(i);
            end
            if length(newTextIn) > underscorePos(end)
                textOut = [textOut newTextIn(underscorePos(end):end)];
            end
        end
        newTextOut{j} = textOut;
    end
    textOut = newTextOut;
else
    underscorePos = find(textIn == '_');
    if isempty(underscorePos)
        textOut = textIn;
    else
        textOut = [];
        beginPos = 1;
        for i=1:length(underscorePos)
            textOut = [textOut textIn(beginPos:underscorePos(i)-1) '\'];
            beginPos = underscorePos(i);
        end
        if length(textIn) > underscorePos(end)
            textOut = [textOut textIn(underscorePos(end):end)];
        end
    end
end
return