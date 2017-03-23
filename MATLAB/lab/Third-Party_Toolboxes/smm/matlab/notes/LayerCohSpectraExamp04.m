
cd /BEEF01/smm/sm9603_Analysis/3-21-04/analysis/

%cd /BEEF01/smm/sm9603_Analysis/3-20-04/analysis/

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


foCell = Struct2CellArray(LoadDesigInfo(intersect(fileBaseCell,files.name),dirName,[depVar '.fo'],trialDesig),[],1);
for j=1:size(foCell,1)
    try fo = foCell{j,end}(1,:);
        break
    end
end
m=3
desigCell = Struct2CellArray(LoadDesigVar(fileBaseCell,SC(dirName),[depVar '.yo.' selChanCell{m,1}],trialDesig),[],1);

figure
hold on
k=1
ch1 = 12
% meanTemp = (squeeze(mean(desigCell{k,2}(:,ch,:),1)));
% sdTemp = (squeeze(std(desigCell{k,2}(:,ch,:),[],1)));
for j=1:size(desigCell{k,2}(:,ch1,:),3)
    bsTemp(:,j) = BsErrBars(@median,99,1000,@median,1,squeeze(desigCell{k,2}(:,ch1,j)));
end
plot(fo,UnATanCoh(bsTemp(1,:)),'k')
plot([fo; fo],UnATanCoh([bsTemp(2,:); bsTemp(3,:)]),'k')
% plot(fo,UnATanCoh(meanTemp),'k')
% plot([fo; fo],UnATanCoh([meanTemp-sdTemp meanTemp+sdTemp]'),'k')

ch2 = 39
for j=1:size(desigCell{k,2}(:,ch2,:),3)
    bsTemp(:,j) = BsErrBars(@median,99,1000,@median,1,squeeze(desigCell{k,2}(:,ch2,j)));
end
plot(fo,UnATanCoh(bsTemp(1,:)),':k')
plot([fo; fo],UnATanCoh([bsTemp(2,:); bsTemp(3,:)]),'k')
set(gca,'xlim',[3 24])
set(gca,'ylim',[0.8 1])
cwd = pwd
cd /u12/smm/public_html/NewFigs/ThetaPaper/psFigs/new18/
title(SaveTheUnderscores(['CohSpect_WInVsBTW_' analRoutine selChanCell{m,1} num2str(selChanCell{m,2}) 'vs_ch' num2str(ch1) '_ch' num2str(ch2) '_example03']))
PrintSaveFig(['CohSpect_WInVsBTW_' analRoutine selChanCell{m,1} num2str(selChanCell{m,2}) 'vs_ch' num2str(ch1) '_ch' num2str(ch2) '_example03'])



cd(cwd)
m=4
desigCell = Struct2CellArray(LoadDesigVar(fileBaseCell,SC(dirName),[depVar '.yo.' selChanCell{m,1}],trialDesig),[],1);

figure
clf
hold on
k=1
ch1 = 72
% meanTemp = (squeeze(mean(desigCell{k,2}(:,ch,:),1)));
% sdTemp = (squeeze(std(desigCell{k,2}(:,ch,:),[],1)));
for j=1:size(desigCell{k,2}(:,ch1,:),3)
    bsTemp(:,j) = BsErrBars(@median,99,1000,@median,1,squeeze(desigCell{k,2}(:,ch1,j)));
end
plot(fo,UnATanCoh(bsTemp(1,:)),'k')
plot([fo; fo],UnATanCoh([bsTemp(2,:); bsTemp(3,:)]),'k')
% plot(fo,UnATanCoh(meanTemp),'k')
% plot([fo; fo],UnATanCoh([meanTemp-sdTemp meanTemp+sdTemp]'),'k')

ch2 = 38
for j=1:size(desigCell{k,2}(:,ch2,:),3)
    bsTemp(:,j) = BsErrBars(@median,99,1000,@median,1,squeeze(desigCell{k,2}(:,ch2,j)));
end
plot(fo,UnATanCoh(bsTemp(1,:)),':k')
plot([fo; fo],UnATanCoh([bsTemp(2,:); bsTemp(3,:)]),'k')
set(gca,'xlim',[3 24])
set(gca,'ylim',[0.8 1])
cwd = pwd
cd /u12/smm/public_html/NewFigs/ThetaPaper/psFigs/new18/
title(SaveTheUnderscores(['CohSpect_WInVsBTW_' analRoutine selChanCell{m,1} num2str(selChanCell{m,2}) 'vs_ch' num2str(ch1) '_ch' num2str(ch2) '_example03']))
PrintSaveFig(['CohSpect_WInVsBTW_' analRoutine selChanCell{m,1} num2str(selChanCell{m,2}) 'vs_ch' num2str(ch1) '_ch' num2str(ch2) '_example03'])


