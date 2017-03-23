function GlmWholeAnalysisBatch03(analProgName,analRoutine,nameNote,filesDesig,fileExt,indepVarCell,varargin)
%function GlmWholeAnalysisBatch03(analProgName,'Alter',nameNote,files,fileExt,indepVarCell)
% GlmWholeAnalysisBatch03('CalcRunningSpectra9_noExp','Alter','secondRun',LoadVar('AlterFiles'),'_LinNear.eeg',{'speed.p0','accel.p0'})
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

GlmWholeModel03(analProgName,analRoutine,nameNote,files,fileExt,'thetaPowPeak6-12Hz',indepVarCell,nchan,0,varargin)
GlmWholeModel03(analProgName,analRoutine,nameNote,files,fileExt,'thetaPowIntg6-12Hz',indepVarCell,nchan,0,varargin)
GlmWholeModel03(analProgName,analRoutine,nameNote,files,fileExt,'gammaPowPeak60-120Hz',indepVarCell,nchan,0,varargin)
GlmWholeModel03(analProgName,analRoutine,nameNote,files,fileExt,'gammaPowIntg60-120Hz',indepVarCell,nchan,0,varargin)
for j=1:length(selChans)
    selChanName = ['.ch' num2str(selChans(j))]
    GlmWholeModel03(analProgName,analRoutine,nameNote,files,fileExt,['thetaCohMedian6-12Hz' selChanName],indepVarCell,nchan,0,varargin)
    GlmWholeModel03(analProgName,analRoutine,nameNote,files,fileExt,['gammaCohMedian60-120Hz' selChanName],indepVarCell,nchan,0,varargin)
end
% GlmWholeModel03(analProgName,analRoutine,nameNote,files,fileExt,'powSpec.yo',indepVarCell,nchan,1,varargin)
% for j=1:length(selChans)
%     selChanName = ['.ch' num2str(selChans(j))]
%     GlmWholeModel03(analProgName,analRoutine,nameNote,files,fileExt,['cohSpec.yo' selChanName],indepVarCell,nchan,1,varargin)
% end