function [uniqueData outData] = GroupData(groupingData,data)

uniqueData = unique(groupingData);
for j=1:length(uniqueData)
    outData{j} = data(groupingData==uniqueData(j),:,:,:,:,:,:,:);
end
return