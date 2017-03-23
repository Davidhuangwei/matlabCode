function outputMat = Make2DPlotMat(inputVector,chanMat,badChan,interpFunc)
% function outputMat = Make2DPlotMat(inputVector,chanMat,badChan,interpFunc)
% Turns inputVector into a 2D matrix according the the arrangement specified by chanMat.
% Channels specified by badChan are given a value of NaN;
% interpFunc determines by what method bad channels are interpolated (see
% interp1)

if ~exist('badChan','var') | isempty(badChan)
    badChan = -1;
end

outputMat = NaN*zeros(size(chanMat));

[nChanY nChanX] = size(chanMat);
for x=1:nChanX
    for y=1:nChanY
        if isempty(find(badChan==chanMat(y,x))), % if the channel isn't bad
            outputMat(y,x) = inputVector(chanMat(y,x));
        end
    end
end
if exist('interpFunc','var') & ~isempty(interpFunc)
    for x=1:nChanX
        %keyboard
        outputMat(:,x) = interp1(find(~isnan(outputMat(:,x))),outputMat(find(~isnan(outputMat(:,x))),x),[1:nChanY],interpFunc,'extrap')';
        if strcmp(interpFunc,'linear')
            if ~isempty(find(chanMat(1,x)==badChan))
                outputMat(1,x) = outputMat(2,x);
            end
            if ~isempty(find(chanMat(nChanY,x)==badChan))
                outputMat(nChanY,x) = outputMat(nChanY-1,x);
            end
        end
    end
end