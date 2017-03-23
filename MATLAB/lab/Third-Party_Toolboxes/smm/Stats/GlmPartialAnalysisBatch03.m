function GlmPartialAnalysisBatch03(analProgName,analRoutine,nameNote,filesDesig,fileExt,indepVarCell)
%function GlmPartialAnalysisBatch03(analProgName,nameNote,files,fileExt,indepVarCell)
% GlmPartialAnalysisBatch03('CalcRunningSpectra9_noExp','secondRun',LoadVar('AlterFiles'),'_LinNear.eeg',{'speed.p0','accel.p0'})
%analProgName = 'CalcRunningSpectra9_noExp';
%nameNote = 'firstRun';
%files = LoadVar('AlterFiles');
%fileExt = '_LinNear.eeg';
%indepVarCell = {'speed.p0','accel.p0'};
files = [];
for m=1:size(filesDesig,2)
    files = [files; LoadVar(filesDesig{m})];
end

chanDir = 'ChanInfo/';
chanMat = LoadVar([chanDir 'ChanMat' fileExt '.mat']);
selChans = load([chanDir 'SelectedChannels' fileExt '.txt']);
nchan = max(max(chanMat));

GlmPartialModel03(analProgName,analRoutine,nameNote,files,fileExt,'thetaPowPeak6-12Hz',indepVarCell,nchan,0)
GlmPartialModel03(analProgName,analRoutine,nameNote,files,fileExt,'thetaPowIntg6-12Hz',indepVarCell,nchan,0)
GlmPartialModel03(analProgName,analRoutine,nameNote,files,fileExt,'gammaPowPeak60-120Hz',indepVarCell,nchan,0)
GlmPartialModel03(analProgName,analRoutine,nameNote,files,fileExt,'gammaPowIntg60-120Hz',indepVarCell,nchan,0)
for j=1:length(selChans)
    selChanName = ['.ch' num2str(selChans(j))]
    GlmPartialModel03(analProgName,analRoutine,nameNote,files,fileExt,['thetaCohMedian6-12Hz' selChanName],indepVarCell,nchan,0)
    GlmPartialModel03(analProgName,analRoutine,nameNote,files,fileExt,['gammaCohMedian60-120Hz' selChanName],indepVarCell,nchan,0)
end
% GlmPartialModel03(analProgName,analRoutine,nameNote,files,fileExt,'powSpec.yo',indepVarCell,nchan,1)
% for j=1:length(selChans)
%     selChanName = ['.ch' num2str(selChans(j))]
%     GlmPartialModel03(analProgName,analRoutine,nameNote,files,fileExt,['cohSpec.yo' selChanName],indepVarCell,nchan,1)
% end