info:
contIndepCell
outlierDepthVar
trialMeanBool
trialDesig
dirName
fileBaseMat
minSpeed
description
winLength
thetaNW
gammaNW
w0
midPointsText
removeOutliersBool?
wholeModelBool ?
freqBool
adjDayMedBool
adjDayZbool
nWayComps

archive:
dayStruct
depStruct
contCellStruct
keepContCellStruct
keepDepStruct
partialModel
contXvarNames

anal:
% partialModel{ch,f}.ols.*
% partialModel{ch,f}.contBetas(:)   for size
% partialModel{ch,f}.Ps(:)          for size
% partialModel{ch,f}.categStats.resid    
% partialModel{ch,f}.categMeans{:}(:,2)
% partialModel{ch,f}.groupCompNames{:}(:,:)


outlierStruct
partialPs
contBetas
categStats
categMeans
groupCompNames
assumpTest
wholeModelPs
wholeModelStats

for i=1:10
junk(i).a.i = [1 2 3; 3 4 5];
junk(i).a.j = [5 6 7; 7 8 9];
junk(i).b.i = [10 20 30; 30 40 50];
junk(i).b.j = [50 60 70; 70 80 90];
end
