% function RndEegSegTime(fileBaseCell,spectAnalDir)
function RndEegSegTime(fileBaseCell,spectAnalDir)

for j=1:length(fileBaseCell)
    fileBase = fileBaseCell{j};
    eegSegTime = round(LoadVar([SC(fileBase) SC(spectAnalDir) 'eegSegTime'])); %load spectAnalTimes
    allEegSegTime = round(LoadVar([SC(fileBase) SC(spectAnalDir) 'allEegSegTime'])); %load spectAnalTimes
    
    
    save([SC(fileBase) SC(spectAnalDir) 'eegSegTime.mat'],SaveAsV6,'eegSegTime')
    save([SC(fileBase) SC(spectAnalDir) 'allEegSegTime.mat'],SaveAsV6,'allEegSegTime')
end