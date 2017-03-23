addpath /u12/smm/matlab/notes
cd /BEEF01/smm/sm9601_Analysis/analysis03/
CalcRunningSpectra8_2_CalcRunningSpectra9([LoadVar('AlterFiles');LoadVar('CircleFiles')]);

cd /BEEF02/smm/sm9608_Analysis/analysis02
CalcRunningSpectra8_2_CalcRunningSpectra9([LoadVar('AlterFiles');LoadVar('ForceFiles')]);


fileExtCell = {'.eeg';...
          '_LinNearCSD121.csd';...
          '_NearAveCSD1.csd';...
          '_LinNear.eeg'};
cd /BEEF01/smm/sm9603_Analysis/analysis04/
RecalcThetaGammaRange([LoadVar('AlterFiles');LoadVar('CircleFiles')],fileExtCell,[],[60 120])

fileExtCell = {'.eeg';...
          '_NearAveCSD1.csd';...
          '_LinNear.eeg'};
cd /BEEF02/smm/sm9614_Analysis/analysis02/
RecalcThetaGammaRange([LoadVar('AlterFiles');LoadVar('ZMazeFiles')],fileExtCell,[],[60 120])

fileExtCell = {'.eeg';...
          '_LinNearCSD121.csd';...
          '_LinNear.eeg'};
cd /BEEF01/smm/sm9601_Analysis/analysis03/
RecalcThetaGammaRange([LoadVar('AlterFiles');LoadVar('CircleFiles')],fileExtCell,[],[60 120])


cd /BEEF02/smm/sm9608_Analysis/analysis02
RecalcThetaGammaRange([LoadVar('AlterFiles')],fileExtCell,[],[60 120])



cd /BEEF02/smm/sm9614_Analysis/analysis02
CalcRunningSpectra9('noExp',[LoadVar('AlterFiles.mat'); LoadVar('ZMazeFiles.mat')],'_LinNearCSD121.csd',72,626,1,[6 12],[60 120]);

cd /BEEF02/smm/sm9608_Analysis/analysis02
CalcRunningSpectra9('noExp',[LoadVar('ForceFiles.mat')],'.eeg',97,626,1,[6 12],[60 120]);
CalcRunningSpectra9('noExp',[LoadVar('ForceFiles.mat')],'_LinNear.eeg',97,626,1,[6 12],[60 120]);
CalcRunningSpectra9('noExp',[LoadVar('ForceFiles.mat')],'_LinNearCSD121.csd',72,626,1,[6 12],[60 120]);


cd /BEEF01/smm/sm9601_Analysis/analysis03/
CalcRunningSpectra9('noExp',[LoadVar('CircleFiles.mat')],'.eeg',81,626,1,[6 12],[60 120]);
CalcRunningSpectra9('noExp',[LoadVar('CircleFiles.mat')],'_LinNear.eeg',81,626,1,[6 12],[60 120]);
CalcRunningSpectra9('noExp',[LoadVar('CircleFiles.mat')],'_LinNearCSD121.csd',72,626,1,[6 12],[60 120]);


fileExtCell = {'.eeg';...
          '_LinNearCSD121.csd';...
          '_NearAveCSD1.csd';...
          '_LinNear.eeg'};
cd /BEEF01/smm/sm9603_Analysis/analysis04/
for j=1:length(fileExtCell)
    GlmAnalysisBatch('CalcRunningSpectra9_noExp','secondRun',LoadVar('AlterFiles'),fileExtCell{j},{'speed.p0','accel.p0'})
end
cd /BEEF02/smm/sm9614_Analysis/analysis02/
for j=1:length(fileExtCell)
    GlmAnalysisBatch('CalcRunningSpectra9_noExp','secondRun',LoadVar('AlterFiles'),fileExtCell{j},{'speed.p0','accel.p0'})
end

fileExtCell = {'.eeg';...
          '_LinNearCSD121.csd';...
          '_LinNear.eeg'};      
cd /BEEF01/smm/sm9601_Analysis/analysis03/
for j=1:length(fileExtCell)
    GlmAnalysisBatch('CalcRunningSpectra9_noExp','secondRun',LoadVar('AlterFiles'),fileExtCell{j},{'speed.p0','accel.p0'})
end
cd /BEEF02/smm/sm9608_Analysis/analysis02
for j=1:length(fileExtCell)
    GlmAnalysisBatch('CalcRunningSpectra9_noExp','secondRun',LoadVar('AlterFiles'),fileExtCell{j},{'speed.p0','accel.p0'})
end





cd /BEEF02/smm/sm9614_Analysis/analysis02
CalcRunningSpectra9('noExp',[LoadVar('AlterFiles.mat'); LoadVar('ZMazeFiles.mat')],'_LinNearCSD121.csd',72,626,1,[6 12],[60 120]);

cd /BEEF02/smm/sm9608_Analysis/analysis02
CalcRunningSpectra9('noExp',[LoadVar('ForceFiles.mat')],'.eeg',97,626,1,[6 12],[60 120]);
CalcRunningSpectra9('noExp',[LoadVar('ForceFiles.mat')],'_LinNear.eeg',97,626,1,[6 12],[60 120]);
CalcRunningSpectra9('noExp',[LoadVar('ForceFiles.mat')],'_LinNearCSD121.csd',72,626,1,[6 12],[60 120]);

fileExtCell = {'.eeg';...
          '_LinNearCSD121.csd';...
          '_NearAveCSD1.csd';...
          '_LinNear.eeg'};
cd /BEEF02/smm/sm9614_Analysis/analysis02/
for j=1:length(fileExtCell)
    GlmAnalysisBatch('CalcRunningSpectra9_noExp','secondRun',LoadVar('AlterFiles'),fileExtCell{j},{'speed.p0','accel.p0'})
end
fileExtCell = {'.eeg';...
          '_LinNearCSD121.csd';...
          '_LinNear.eeg'};      
cd /BEEF02/smm/sm9608_Analysis/analysis02
for j=1:length(fileExtCell)
    GlmAnalysisBatch('CalcRunningSpectra9_noExp','secondRun',LoadVar('AlterFiles'),fileExtCell{j},{'speed.p0','accel.p0'})
end






cd /BEEF01/smm/sm9601_Analysis/analysis03/
CalcRunningSpectra9('noExp',[LoadVar('CircleFiles.mat')],'.eeg',81,626,1,[6 12],[60 120]);
CalcRunningSpectra9('noExp',[LoadVar('CircleFiles.mat')],'_LinNear.eeg',81,626,1,[6 12],[60 120]);
CalcRunningSpectra9('noExp',[LoadVar('CircleFiles.mat')],'_LinNearCSD121.csd',72,626,1,[6 12],[60 120]);

fileExtCell = {'.eeg';...
          '_LinNearCSD121.csd';...
          '_NearAveCSD1.csd';...
          '_LinNear.eeg'};
cd /BEEF01/smm/sm9603_Analysis/analysis04/
for j=1:length(fileExtCell)
    GlmAnalysisBatch('CalcRunningSpectra9_noExp','secondRun',LoadVar('AlterFiles'),fileExtCell{j},{'speed.p0','accel.p0'})
end
fileExtCell = {'.eeg';...
          '_LinNearCSD121.csd';...
          '_LinNear.eeg'};      
cd /BEEF01/smm/sm9601_Analysis/analysis03/
for j=1:length(fileExtCell)
    GlmAnalysisBatch('CalcRunningSpectra9_noExp','secondRun',LoadVar('AlterFiles'),fileExtCell{j},{'speed.p0','accel.p0'})
end

