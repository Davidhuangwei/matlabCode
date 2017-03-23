%FileBaseMat2FileBaseCell

dayCell = Struct2CellArray(LoadVar('DayStruct.mat'));
days = unique(dayCell(:,2));
for j=1:length(days)
    dayName = days{j};
    day = dayCell(strcmp(dayCell(:,2),dayName),1);
    fprintf(['\n\n' dayName '\n'])
    currDir = pwd;
    cd(['../' dayName '/analysis/FileInfo/']);
    dirOut = dir;
    for k=3:length(dirOut)
        fileBaseMat = LoadVar(dirOut(k).name);
        fprintf([dirOut(k).name '\n'])
        fileBaseCell = mat2cell(fileBaseMat,ones(size(fileBaseMat,1),1),size(fileBaseMat,2));
        fileBaseCell = intersect(fileBaseCell,day)
        fprintf('save(dirOut{k}.name,SaveAsV6,fileBaseCell);\n\n');
        save(dirOut(k).name,SaveAsV6,'fileBaseCell');
        %eval(['!cp *Files.mat ../' dayName '/analysis/FileInfo/']);
    end
    cd(currDir);
end


return



dayCell = Struct2CellArray(LoadVar('DayStruct.mat'));
days = unique(dayCell(:,2));
for j=1:length(days)
    dayName = days{j};
    day = dayCell(strcmp(dayCell(:,2),dayName),1);
    fprintf(['\n\n' dayName '\n'])
    currDir = pwd;
    cd(['../' dayName '/analysis/ChanInfo/']);
    eval('!cp AnatCurvesNew.mat AnatCurvesNew.mat.backup')
    eval('!cp AnatCurves.mat AnatCurves.mat.old.1')
    eval('!cp AnatCurvesNew.mat AnatCurves.mat')
    eval('!mv OffSet.eeg.txt Offset.eeg.txt')
    eval('!mv OffSet.dat.txt Offset.dat.txt')
    eval('!mv OffSet_LinNear.eeg.txt Offset_LinNear.eeg.txt')
    eval('!mv OffSet_LinNearCSD121.csd.txt Offset_LinNearCSD121.csd.txt')
    eval('!mv OffSet_NearAveCSD1.csd.txt Offset_NearAveCSD1.csd.txt')
    ls
   cd(currDir);
end

