function textOut = RmTextSpaces(textIn)
% function textOut = RmTextSpace(textIn)
% takes text vector and returns text without spaces
textOut = [];
for i=1:length(textIn)
    if textIn(i)~=' '
        textOut = [textOut textIn(i)];
    end
end