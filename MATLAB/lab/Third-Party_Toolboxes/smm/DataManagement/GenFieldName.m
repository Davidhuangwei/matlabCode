% function textOut = GenFieldName(textIn)
%pass a text string or a cell array of text strings and all 
% '.' > '_'
% ',' > '_'
% '=' > '_'
% '*' > 'X'
% ' ' > ''
% '-' > '_'
% tag:field
% tag:file
% tag:name
% tag:generate
function textOut = Dot2Underscore(textIn)

textOut = textIn;

if iscell(textOut)
    for j=1:length(textOut(:))
        textX = textOut{j};
        textX(find(textX=='.')) = '_';
        textX(find(textX=='=')) = '_';
        textX(find(textX==',')) = '_';
        textX(find(textX=='*')) = 'X';
        textX(find(textX==' ')) = '';
        textX(find(textX=='-')) = '_';
        textOut{j} = textX;
    end
else
    textOut(find(textOut=='.')) = '_';
    textOut(find(textOut=='=')) = '_';
    textOut(find(textOut==',')) = '_';
    textOut(find(textOut=='*')) = 'X';
    textOut(find(textOut==' ')) = '';
    textOut(find(textOut=='-')) = '_';
end
return