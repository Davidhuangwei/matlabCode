load TrialDesig/GlmWholeModel08/MazeAll.mat
load TrialDesig/GlmWholeModel08/MazeAllNoLGA.mat
fileExtCell = {...
                  '.eeg',...
                 '_LinNearCSD121.csd',...
                }
spectAnalBaseCell = {...
    'CalcRunningSpectra12_noExp_MidPoints_MinSpeed0Win626wavParam4',... %for theta paper
   'CalcRunningSpectra16_goodRun_MinSpeed0wavParam4Win626',... % for speed/theta analysis
}
spectAnalDir = [spectAnalBaseCell{1} fileExtCell{1}]

depVarCell = {...
                  'thetaCohLMPeak6-12Hz',...
                 'thetaCohMean6-12Hz',...
}
selChan = Struct2CellArray(SelChan(fileExtCell{1}))
badChan = BadChan(fileExtCell{1})
clear thetaCoh
for j=1:size(selChan,1)
    temp = LoadDesigVar(fileBaseCell,spectAnalDir,[depVarCell{1} '.' selChan{j,1}],trialDesig);
    temp.maze(:,badChan) = [];
    thetaCoh(j,:) = mean(temp.maze,1);
end
plot((thetaCoh),'.')
[P,T,STATS]= kruskalwallis(thetaCoh');
multcompare(STATS)


f_fet = fopen('ThetaCohClust.fet.1','w');
f_clu = fopen('ThetaCohClust.clu.1','w');
%f_spk = fopen('ThetaCohClust.spk.1');
fprintf(f_fet,'%i\n',size(thetaCoh,1));
fprintf(f_clu,'2\n');
for (j=1:size(thetaCoh,2))
fprintf(f_fet,'%6.0f %6.0f %6.0f %6.0f %6.0f %6.0f %6.0f %6.0f\n',...
      thetaCoh(1,j)*1000, thetaCoh(2,j)*1000, thetaCoh(3,j)*1000, thetaCoh(4,j)*1000,...
      thetaCoh(5,j)*1000, thetaCoh(6,j)*1000, thetaCoh(7,j)*1000, thetaCoh(8,j)*1000) ;
    fprintf(f_clu,'2 2 2 2 2 2 2 2\n');
end
fclose(f_fet);
fclose(f_clu);


plot(UnATanCoh(thetaCoh'))

for j=1:size(thetaCoh,1)
    for k=1:size(thetaCoh,1)
        diffScore(j,k) = sum(abs(thetaCoh(j,:) - thetaCoh(k,:)));
    end
end
imagesc(diffScore)
colorbar


    plotData = dataStruct.coeffs;
for k=1:size(plotData.Constant,2)
statData = [];
groupNames = {};
for j=1:size(plotData.Constant,1)
    statData = cat(1,statData,plotData.Constant{j,k});cd
    groupNames = cat(1,groupNames,repmat(selChanNames(j),size(plotData.Constant{j,k})));
end
[P,T,STATS]= kruskalwallis(statData,groupNames);
multcompare(STATS);
end
ReportFigSM(1:16,['./'],repMat({[spectAnalDir depVar analRoutine fileExt chanLocVersion 'kw_test']},16,1))
close all

    plotData = dataStruct.coeffs;
for k=1:size(plotData.Constant,2)
statData = [];
groupNames = {};
for j=1:size(plotData.Constant,1)
    statData = cat(1,statData,plotData.Constant{j,k});
    groupNames = cat(1,groupNames,repmat(selChanNames(j),size(plotData.Constant{j,k})));
end
[P,T,STATS]= anovan(statData,{groupNames});
figure
multcompare(STATS);
end
ReportFigSM(1:16,['./'],repMat({[spectAnalDir depVar analRoutine fileExt chanLocVersion 'anovan']},16,1))

