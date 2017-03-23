% function CheckAddedTime(fileBaseCell,spectAnalBase,fileExtCell,addedTrialsFilesCell)
% sanity check to see that all your times are adding up.
% tag:check
% tag:time
% tag:added

function CheckAddedTime(fileBaseCell,spectAnalBase,fileExtCell,addedTrialsFilesCell)

for j=1:length(fileBaseCell)
    for k=1:length(fileExtCell)
        dirName = [SC(fileBaseCell{j}) SC([spectAnalBase fileExtCell{k}])];
        timeCovered = zeros(size(LoadVar([dirName 'time'])));
        timeCovered(find(LoadVar([dirName 'originalTime']))) = 1;
        for m=1:length(addedTrialsFilesCell)
            if exist([dirName addedTrialsFilesCell{m}],'file')
                timeCovered(find(LoadVar([dirName addedTrialsFilesCell{m}]))) = 1;
            else
                fprintf('FileNotFound: %s\n',[dirName addedTrialsFilesCell{m}])
            end
        end
        if ~all(timeCovered)
            fprintf('**** Time NOT Covered: %s\n',dirName)
        end
    end
end