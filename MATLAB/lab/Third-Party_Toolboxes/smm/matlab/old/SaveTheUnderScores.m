function textOut = SaveTheUnderScores(textIn)
underScorePos = find(textIn == '_');
textOut = [];
beginPos = 1;
for i=1:length(underScorePos)
    textOut = [textOut textIn(beginPos:underScorePos(i)-1) '/_'];
    beginPos = underScorePos(i);
end
if length(textIn) > underScorePos(end)
    textOut = [textOut textIn(underScorePos(end)+1:end)];
end
return