

powerMat(ch x f x t)
cohMat(selch x ch x f x t)
phaseMat(selch x ch x f x t)

mazeFiles = LoadVar('FileInfo/MazeFiles')
trialDesig.maze = {{{'taskType','alter'}},...
                    {{'taskType','circle'}},...
                    }
thetaFreq = LoadDesigVar(mazeFiles,'RemVsRun02_noExp_MinSpeed0Win1250.eeg',...
    'thetaFreq4-12Hz',trialDesig);
 trialDesig  = LoadField('TrialDesig/GlmWholeModel07/RemVsRun.trialDesig') 
 
 trialDesig.maze = {{{'speed.p0',[1],'>',0}}}
 
 selChan = LoadVar('ChanInfo/SelChan.eeg')
load('TrialDesig/GlmWholeModel07/RemVsRun.mat')
thetaFreq = LoadDesigVar(fileBaseCell,'RemVsRun01_noExp_MinSpeed0Win1250.eeg',...
    'thetaFreq4-12Hz',trialDesig);
thetaFreq = EqualizeN(thetaFreq,0);
 
fileBaseCell = LoadVar('FileInfo/MazeFiles')
thetaFreq = LoadDesigVar(fileBaseCell,'CalcRunningSpectra14_noExp_MinSpeed5wavParam6Win1250.eeg',...
    'thetaFreq4-12Hz',trialDesig);

thetaFreq
clf
offset = 0.1
binFactor = 3;
temp = Accumulate(round(thetaFreq.rem(:,selChan.lm)*binFactor));
bar([1:length(temp)]/binFactor+offset,temp,0.5,'r')
hold on
temp = Accumulate(round(thetaFreq.maze(:,selChan.lm)*binFactor));
bar([1:length(temp)]/binFactor-offset,temp,0.5,'b')
set(gca,'xlim',[4 12])



minPT = 20;
tpa = 1700;
na = 4;
minph = 60;
hpd = 24;

totalmin = tpa*na*minPT
totaldays = totalmin/minph/hpd

 
trialDesig.maze = {{{'speed.p0',[1],'>',0}}}
depVarName = 'powSpec';
depVarName = 'cohSpec';
depVarName = 'phaseSpec';

depVarName = 'thetaFreq4-12Hz';
depVarName = 'thetaPowIntg4-12Hz';
depVarName = 'thetaCohMean4-12Hz';
depVarName = 'thetaPhaseMean4-12Hz';
depVarName = 'gammaPowIntg40-100Hz';
depVarName = 'gammaCohMean40-100Hz';
depVarName = 'gammaPhaseMean40-100Hz';
spectAnalDir = 'CalcRunningSpectra14_noExp_MinSpeed5wavParam6Win1250';
spectAnalDir = 'RemVsRun01_noExp_MinSpeed0Win1250';
analRoutine = 'AllMazeTrials';
fileExt = '.eeg';
fileExt = '_LinNearCSD121.csd';
load(['TrialDesig/GlmWholeModel08/' analRoutine])
fileBaseCell = fileBaseCell(1:4);
depVar = LoadDesigVar(fileBaseCell,[spectAnalDir fileExt],[depVarName '.yo'],trialDesig);
 
PlotBehavAnatMap03(depVarName,fileExt,spectAnalDir,analRoutine)
PlotBehavPowerSpectra03(depVarName,fileExt,spectAnalDir,analRoutine)
PlotBehavCohSpectra01(depVarName,fileExt,spectAnalDir,analRoutine)
PlotBehavPhaseSpectra02(depVarName,fileExt,spectAnalDir,analRoutine)


depVar
(depVar,fileExt,spectAnalDir,analRoutine,varargin)
[colorLimits,interpFunc,glmVersion,subtractMeanBool] ...
    = DefaultArgs(varargin,{[],'linear','GlmWholeModel08',1});


bar(Accumulate(round(thetaFreq.maze(:,selChan.lm))),'b')

hist(thetaFreq.maze(:,selChan.lm),75)
hold on
hist(thetaFreq.rem(:,selChan.lm),70)


CalcRunningSpectra11_noExp_MinSpeed0Win1250.eeg