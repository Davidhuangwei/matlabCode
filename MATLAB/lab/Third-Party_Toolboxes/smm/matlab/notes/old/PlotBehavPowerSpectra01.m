function PlotBehavPowerSpectra01(depVar,fileExt,spectAnalBase,analRoutine,varargin)
[glmVersion,midPointsBool,minSpeed,winLength] ...
    = DefaultArgs(varargin,{'GlmWholeModel07',1,0,626});
%analRoutine = 'CalcRunningSpectra9_noExp';
% analRoutine = 'RemVsRun_noExp';
% winLength = 1250;
% midPointsBool=0;
% %analRoutine = 'AlterGood_MR';
% analRoutine = 'RemVsRun';
% glmVersion = 'GlmWholeModel05';
chanDir = 'ChanInfo/';
% % fileExt = '.eeg';
% % fileExt = '_NearAveCSD1.csd';
% % fileExt = '_LinNearCSD121.csd';

% depVar = 'powSpec.yo';
selChansCell = Struct2CellArray(LoadVar([chanDir 'SelChan' fileExt '.mat']));
% selChanNames = selChans(:,1);
% selChans = cell2mat(selChans(:,2));
if midPointsBool
    midPointsText = '_MidPoints';
else
    midPointsText = [];
end

dirName = [spectAnalBase midPointsText '_MinSpeed' num2str(minSpeed) 'Win' num2str(winLength) fileExt];

load(['TrialDesig/' glmVersion '/' analRoutine '.mat'])
fileName = ParseStructName(depVar);
fs = LoadField([fileBaseCell{1} '/' dirName '/' fileName{1} '.fo']);

% depCell = Struct2CellArray(LoadDesigVar(fileBaseCell(1:4,:),dirName,depVar,trialDesig),[],1);
files = MatStruct2StructMat(dir('sm96*'),'name');
%fileBaseCell = mat2cell(fileBaseMat,ones(size(fileBaseMat,1),1),size(fileBaseMat,2));
depCell = Struct2CellArray(LoadDesigVar(cell2mat(intersect(fileBaseCell,files.name)),dirName,depVar,trialDesig),[],1);

plotColors = [0 0 0;1 0 0;0 1 0;0 0 1];
for j=1:size(selChansCell,1)
%     subplot(size(selChansCell,1),1,j)
figure(j)
clf
hold on
    for k=1:size(depCell,1)
        plot(fs,squeeze(mean(depCell{k,2}(:,selChansCell{j,2},:))),'color',plotColors(k,:));
    end
    title(selChansCell{j,1})
    set(gca,'xlim',[0 120],'xtick',[0:20:160])
    set(gcf,'name',Dot2Underscore(fileExt))
end
%  ReportFigSM(1:8,['/u12/smm/public_html/NewFigs/ForGyuri/PowSpec/' analRoutine '/'])    
 return