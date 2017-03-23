function interpedData = ShankInterp(inputData,badChans,interpMethod,interpWeightOrder)
% function interpedData = ShankInterp(inputData,badChans,interpMethod,interpWeightOrder)

switch interpMethod
    case 'NearAve'
    [interpedData junk] = InterpNearAve(inputData,badChans,100);
else
    nShanks = size(inputData,2);
    chansPerShank = size(inputData,1);

    for j=1:nShanks
        channels = (j-1)*chansPerShank+1:j*chansPerShank;

        goodChan = [];
        for i=1:length(channels)
            if isempty(find(channels(i)==badChans))
                goodChan = [goodChan i];
            end
        end
        interpedData(:,j) = interp1(goodChan,inputData(goodChan,j),1:chansPerShank,interpMethod,'extrap');
    end
end
return
