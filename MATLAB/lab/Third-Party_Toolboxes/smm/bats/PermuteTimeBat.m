function PermuteTimeBat(analDirs,fileBaseCellName,spectAnalDir)

for j=1:length(analDirs)
    fileBaseCell = LoadVar([analDirs{j} 'FileInfo/' fileBaseCellName]);
    for k=1:length(fileBaseCell)
        time = LoadVar([analDirs{j} fileBaseCell{k} '/' spectAnalDir '/time']);
        if size(time,1)<size(time,2)
            time = time';
        end
        save([analDirs{j} fileBaseCell{k} '/' spectAnalDir '/time'],SaveAsV6,'time');
        
        eegSegTime = LoadVar([analDirs{j} fileBaseCell{k} '/' spectAnalDir '/eegSegTime']);
        if size(eegSegTime,1)<size(eegSegTime,2)
            eegSegTime = eegSegTime';
        end
        save([analDirs{j} fileBaseCell{k} '/' spectAnalDir '/eegSegTime'],SaveAsV6,'eegSegTime');
        
         allEegSegTime = LoadVar([analDirs{j} fileBaseCell{k} '/' spectAnalDir '/allEegSegTime']);
        if size(allEegSegTime,1)<size(allEegSegTime,2)
            allEegSegTime = allEegSegTime';
        end
        save([analDirs{j} fileBaseCell{k} '/' spectAnalDir '/allEegSegTime'],SaveAsV6,'allEegSegTime');
        
         keptTime = LoadVar([analDirs{j} fileBaseCell{k} '/' spectAnalDir '/keptTime']);
        if size(keptTime,1)<size(keptTime,2)
            keptTime = keptTime';
        end
        save([analDirs{j} fileBaseCell{k} '/' spectAnalDir '/keptTime'],SaveAsV6,'keptTime');
    end
end
