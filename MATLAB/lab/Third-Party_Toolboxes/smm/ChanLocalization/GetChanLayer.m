function outLayers = GetChanLayer(channels,chanLoc)

chanLocNames = fieldnames(chanLoc);
chanLocCell = {};
for j=1:length(chanLocNames)
    chanLocCell = cat(1,chanLocCell,cat(2,...
        mat2cell([chanLoc.(chanLocNames{j}){:}]',repmat(1,size([chanLoc.(chanLocNames{j}){:}]'))),...
        repmat(chanLocNames(j),size([chanLoc.(chanLocNames{j}){:}]'))));
end
for j=1:length(channels)
    if sum([chanLocCell{:,1}]==channels(j)) == 1
        outLayers{j} = chanLocCell{[chanLocCell{:,1}]==channels(j),2};
    else
        outLayers{j} = '';
    end
end
