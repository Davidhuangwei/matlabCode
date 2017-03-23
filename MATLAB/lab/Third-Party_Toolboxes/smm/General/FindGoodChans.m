function goodChan = FindGoodChans(nChans,badChans)
%function goodChan = GoodChans(nChans,badChans)

goodChan = [];
for i=1:nChans
    if isempty(find(badChans == i))
        goodChan = [goodChan; i];
    end
end
return