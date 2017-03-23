
cd /BEEF01/smm/sm9603_Analysis/3-21-04/analysis/


chanLocVersion = 'Full'
animalDirs = {{pwd}}
spectAnalBase = spectAnalBaseCell{1}
fileExt = fileExtCell{1}
depVar = depVarCell{1}
selChan = SelChan(fileExt)
selChansCell = Struct2CellArray(selChan,[],1)
glmVersion = 'GlmWholeModel08'
analRoutine = analRoutine{1}
selChanBool = 0
catMethod = 'chan'
load(['TrialDesig/' glmVersion '/' analRoutine '.mat'])
files.name = fileBaseCell;
fileName = ParseStructName(depVar);
dirName = [spectAnalBase  fileExt];


m=3
    depCell = Struct2CellArray(LoadSpectAnalResults01(animalDirs,spectAnalBase,fileExt,[depVar '.yo.' selChansCell{m,1}] ,glmVersion,...
    analRoutine,selChanBool,catMethod,chanLocVersion),[],1);

foCell = Struct2CellArray(LoadDesigInfo(intersect(fileBaseCell,files.name),dirName,[depVar '.fo'],trialDesig),[],1);
for j=1:size(foCell,1)
    try fo = foCell{j,end}(1,:);
        break
    end
end

chanLoc = LoadVar('ChanInfo/ChanLoc_Full.eeg.mat')
badChan = load('ChanInfo/BadChan.eeg.txt')  

chanrad = setdiff([chanLoc.rad{:}],badChan)
chanlm = setdiff([chanLoc.lm{:}],badChan)
depCell{1,2}

depCell{1,2}{3} = depCell{1,2}{3}(2,:); %ch12
depCell{1,2}{4} = depCell{1,2}{4}(2,:); %ch39?
clf
hold on
plotTemp = UnATanCoh(squeeze(mean(depCell{k,2}{3},1)));
plot(fo,plotTemp,'k');
plotTemp = UnATanCoh(squeeze(mean(depCell{k,2}{4},1)));
plot(fo,plotTemp,'r');
set(gca,'xlim',[3 24])
set(gca,'ylim',[0.75 1])

cd /u12/smm/public_html/NewFigs/ThetaPaper/psFigs/new07
PrintSaveFig('ThetaPowerSpectra_ref37v12_39_sm9603_3-21_02')


cd /BEEF01/smm/sm9603_Analysis/3-21-04/analysis/
m=4
    depCell = Struct2CellArray(LoadSpectAnalResults01(animalDirs,spectAnalBase,fileExt,[depVar '.yo.' selChansCell{m,1}] ,glmVersion,...
    analRoutine,selChanBool,catMethod,chanLocVersion),[],1);

chanrad = setdiff([chanLoc.rad{:}],badChan)
chanlm = setdiff([chanLoc.lm{:}],badChan)
depCell{1,2}

depCell{1,2}{3} = depCell{1,2}{3}(9,:); %ch38
depCell{1,2}{4} = depCell{1,2}{4}(7,:); %ch90
clf
hold on
plotTemp = UnATanCoh(squeeze(mean(depCell{k,2}{3},1)));
plot(fo,plotTemp,'k');
plotTemp = UnATanCoh(squeeze(mean(depCell{k,2}{4},1)));
plot(fo,plotTemp,'r');
set(gca,'xlim',[3 24])
set(gca,'ylim',[0.8 1])

cd /u12/smm/public_html/NewFigs/ThetaPaper/psFigs/new07
PrintSaveFig('ThetaPowerSpectra_ref40v38_90_sm9603_3-21_02')


















m=3
    depCell = Struct2CellArray(LoadSpectAnalResults01(animalDirs,spectAnalBase,fileExt,[depVar '.yo.' selChansCell{m,1}] ,glmVersion,...
    analRoutine,selChanBool,catMethod,chanLocVersion),[],1);

foCell = Struct2CellArray(LoadDesigInfo(intersect(fileBaseCell,files.name),dirName,[depVar '.fo'],trialDesig),[],1);
for j=1:size(foCell,1)
    try fo = foCell{j,end}(1,:);
        break
    end
end

LoadVar('ChanInfo/ChanLoc_Min.eeg.mat')
badChan = load('ChanInfo/BadChan.eeg.txt')  

depCell{1,2}{3} = depCell{1,2}{3}(1,:); %ch12
depCell{1,2}{4} = depCell{1,2}{4}(3,:); %ch40?
clf
hold on
plotTemp = UnATanCoh(squeeze(mean(depCell{k,2}{3},1)));
plot(fo,plotTemp,'k');
plotTemp = UnATanCoh(squeeze(mean(depCell{k,2}{4},1)));
plot(fo,plotTemp,'r');
set(gca,'xlim',[3 24])
set(gca,'ylim',[0.75 1])

cd /u12/smm/public_html/NewFigs/ThetaPaper/psFigs/new07
PrintSaveFig('ThetaPowerSpectra_ref37v12_40_sm9603_3-21_01')


cd /BEEF01/smm/sm9603_Analysis/3-21-04/analysis/
m=4
    depCell = Struct2CellArray(LoadSpectAnalResults01(animalDirs,spectAnalBase,fileExt,[depVar '.yo.' selChansCell{m,1}] ,glmVersion,...
    analRoutine,selChanBool,catMethod,chanLocVersion),[],1);
depCell{1,2}{3} = depCell{1,2}{3}(3,:); %ch37
depCell{1,2}{4} = depCell{1,2}{4}(4,:); %ch72
clf
hold on
plotTemp = UnATanCoh(squeeze(mean(depCell{k,2}{3},1)));
plot(fo,plotTemp,'k');
plotTemp = UnATanCoh(squeeze(mean(depCell{k,2}{4},1)));
plot(fo,plotTemp,'r');
set(gca,'xlim',[3 24])
set(gca,'ylim',[0.75 1])

cd /u12/smm/public_html/NewFigs/ThetaPaper/psFigs/new07
PrintSaveFig('ThetaPowerSpectra_ref40v37_72_sm9603_3-21_01')



plotTemp = UnATanCoh(squeeze(mean(depCell{k,2}{j},1)));
plot(fo,plotTemp,'k');
plotTemp = UnATanCoh(squeeze(mean(depCell{k,2}{j},1)));
plot(fo,plotTemp,'r');