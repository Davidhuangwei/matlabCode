function textOut = Dot2Underscore(textIn)
%pass a text string or a cell array of text strings and all "." will be
%replaced by "_" and returned

textOut = textIn;

if iscell(textOut)
    for j=1:length(textOut(:))
        textX = textOut{j};
        textX(find(textX=='.')) = '_';
        textOut{j} = textX;
    end
else
    textOut(find(textOut=='.')) = '_';
end
return