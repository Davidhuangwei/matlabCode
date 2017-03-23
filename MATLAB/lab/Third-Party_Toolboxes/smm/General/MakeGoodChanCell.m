function goodChanCell = MakeGoodChanCell(chanMat,badChans)
% function goodChanCell = MakeGoodChanCell(chanMat,badChans)
% creates a cell array containing only good channels (for fileCSD)

goodChanCell = cell(1,size(chanMat,2));
for i=1:size(chanMat,2)
    for j=1:size(chanMat,1)
        if isempty(find(chanMat(j,i)==badChans))
            goodChanCell{:,i} = cat(2,goodChanCell{:,i},chanMat(j,i));
        end
    end
end
return