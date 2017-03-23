% function failedDirs = MakeOriginalTime(fileBaseCell,spectAnalBase,fileExtCell,addedTrialsFilesCell)
% retroactively makes originalTime file to designate which times were from
% original time calculation before any AddSpectralTrials was performed
% tag:original
% tag:time
% tag:AddSpectralTrials

function failedDirs = MakeOriginalTime(fileBaseCell,spectAnalBase,fileExtCell,addedTrialsFilesCell)

failedDirs = {};
for j=1:length(fileBaseCell)
    for k=1:length(fileExtCell)
        saveDir = [SC(fileBaseCell{j}) SC([spectAnalBase fileExtCell{k}])];
        time = LoadVar([saveDir...
            'time.mat']);
        lastOrigTime = find(diff(time)<=0,1);

        newTimesVec = zeros(size(time));
        for m=1:length(addedTrialsFilesCell)
            newTimesVec = newTimesVec | ...
                LoadVar([saveDir...
                addedTrialsFilesCell{m}]);
        end
        beforeAdded = find(newTimesVec,1)-1;
        
        if isempty(lastOrigTime)
            lastOrigTime = size(time,1);
        end
        if isempty(beforeAdded)
            beforeAdded = size(time,1);
        end
        
        if lastOrigTime == beforeAdded
            originalTime = zeros(size(time));
            originalTime(1:lastOrigTime) = 1;
            save([saveDir 'originalTime.mat'],SaveAsV6,'originalTime');
        else
            warning(['SKIPPING: ' saveDir 'originalTime.mat'])
            failedDirs = cat(1,failedDirs,{saveDir})
        end
    end
end
