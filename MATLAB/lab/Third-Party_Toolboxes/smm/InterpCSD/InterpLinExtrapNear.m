function interpData = InterpLinExtrapNear(inputData,chanMat,badChans,extrapBool)
% function interpData = InterpLinExtrapNear(inputData,chanMat,badChans,extrapBool)

if ~exist('extrapBool') | isempty(extrapBool)
    extrapBool = 1;
end    
    
linInterpData = inputData;
interpData = inputData;

if ~isempty(badChans)
    % linear interpolate
    for i=1:size(chanMat,2)
        channels = chanMat(:,i);
        goodChans = [];
        for j=1:length(channels)
            if isempty(find(channels(j)==badChans))
                goodChans = [goodChans channels(j)];
            end
        end
        if isempty(goodChans)
%             linInterpData(channels,:) = zeros(size(inputData(channels,:)));
%             fprintf('No good channels on shank %i: Replacing with zeros.\n',i)
             fprintf('No good channels on shank %i\n',i)
             
        else
            linInterpData(channels,:) = interp1(goodChans-channels(1)+1,inputData(goodChans,:),channels-channels(1)+1,'linear');
        end
    end
    
    if extrapBool
        % near extrapolate
        badChans = find(isnan(linInterpData(:,1)));
        for i=1:size(chanMat,2)
            channels = chanMat(:,i);
            goodChans = [];
            for j=1:length(channels)
                if isempty(find(channels(j)==badChans))
                    goodChans = [goodChans channels(j)];
                end
            end
            if isempty(goodChans)
                %             interpData(channels,:) = zeros(size(linInterpData(channels,:)));
                %             fprintf('No good channels on shank %i: Replacing with zeros.\n',i)
                fprintf('No good channels on shank %i\n',i)
            else
                interpData(channels,:) = interp1(goodChans-channels(1)+1,linInterpData(goodChans,:),channels-channels(1)+1,'near','extrap');
            end
        end
    end
end
return