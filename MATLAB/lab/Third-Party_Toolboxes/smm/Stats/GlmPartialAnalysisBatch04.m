function GlmPartialAnalysisBatch04(analProgName,analRoutine,nameNote,filesDesig,fileExt)
%function GlmPartialAnalysisBatch04(analProgName,nameNote,files,fileExt,indepVarCell)
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

GlmPartialModel04(analProgName,analRoutine,nameNote,files,fileExt,'thetaPowPeak6-12Hz',nchan,0)
GlmPartialModel04(analProgName,analRoutine,nameNote,files,fileExt,'thetaPowIntg6-12Hz',nchan,0)
GlmPartialModel04(analProgName,analRoutine,nameNote,files,fileExt,'gammaPowPeak60-120Hz',nchan,0)
GlmPartialModel04(analProgName,analRoutine,nameNote,files,fileExt,'gammaPowIntg60-120Hz',nchan,0)
for j=1:length(selChans)
    selChanName = ['.ch' num2str(selChans(j))]
    GlmPartialModel04(analProgName,analRoutine,nameNote,files,fileExt,['thetaCohMedian6-12Hz' selChanName],nchan,0)
    GlmPartialModel04(analProgName,analRoutine,nameNote,files,fileExt,['gammaCohMedian60-120Hz' selChanName],nchan,0)
end
% GlmPartialModel04(analProgName,analRoutine,nameNote,files,fileExt,'powSpec.yo',nchan,1)
% for j=1:length(selChans)
%     selChanName = ['.ch' num2str(selChans(j))]
%     GlmPartialModel04(analProgName,analRoutine,nameNote,files,fileExt,['cohSpec.yo' selChanName],nchan,1)
% end