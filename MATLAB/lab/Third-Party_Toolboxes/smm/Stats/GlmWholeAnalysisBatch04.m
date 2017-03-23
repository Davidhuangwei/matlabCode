function GlmWholeAnalysisBatch04(analProgName,analRoutine,nameNote,filesDesig,fileExt,indepVarCell,varargin)
%function GlmWholeAnalysisBatch04(analProgName,'Alter',nameNote,files,fileExt,indepVarCell)
% GlmWholeAnalysisBatch04('CalcRunningSpectra9_noExp','Alter','secondRun',LoadVar('AlterFiles'),'_LinNear.eeg',{'speed.p0','accel.p0'})
% analProgName = 'CalcRunningSpectra9_noExp';
% analRoutine = 'Alter_Vs_Circle_CompSimRegions'
% nameNote = 'Test';
% files = LoadVar('AlterFiles');
% files = [LoadVar('AlterFiles');LoadVar('CircleFiles')];
% fileExt = '_LinNear.eeg';
% indepVarCell = {'speed.p0','accel.p0'};
% varargin = DefaultArgs(varargin,{[]});
files = [];
for m=1:size(filesDesig,2)
    files = [files; LoadVar(filesDesig{m})];
end

chanDir = 'ChanInfo/';
chanMat = LoadVar([chanDir 'ChanMat' fileExt '.mat']);
selChans = load([chanDir 'SelectedChannels' fileExt '.txt']);
nchan = max(max(chanMat));

GlmWholeModel04(analProgName,analRoutine,nameNote,files,fileExt,'thetaPowPeak6-12Hz',nchan,0,varargin)
GlmWholeModel04(analProgName,analRoutine,nameNote,files,fileExt,'thetaPowIntg6-12Hz',nchan,0,varargin)
GlmWholeModel04(analProgName,analRoutine,nameNote,files,fileExt,'gammaPowPeak60-120Hz',nchan,0,varargin)
GlmWholeModel04(analProgName,analRoutine,nameNote,files,fileExt,'gammaPowIntg60-120Hz',nchan,0,varargin)
for j=1:length(selChans)
    selChanName = ['.ch' num2str(selChans(j))]
    GlmWholeModel04(analProgName,analRoutine,nameNote,files,fileExt,['thetaCohMedian6-12Hz' selChanName],nchan,0,varargin)
    GlmWholeModel04(analProgName,analRoutine,nameNote,files,fileExt,['gammaCohMedian60-120Hz' selChanName],nchan,0,varargin)
end
% GlmWholeModel04(analProgName,analRoutine,nameNote,files,fileExt,'powSpec.yo',nchan,1,varargin)
% for j=1:length(selChans)
%     selChanName = ['.ch' num2str(selChans(j))]
%     GlmWholeModel04(analProgName,analRoutine,nameNote,files,fileExt,['cohSpec.yo' selChanName],nchan,1,varargin)
% end