function GlmWholeAnalysisBatch01(analProgName,nameNote,files,fileExt,indepVarCell,varargin)
%function GlmWholeAnalysisBatch(analProgName,nameNote,files,fileExt,indepVarCell)
% GlmWholeAnalysisBatch01('CalcRunningSpectra9_noExp','secondRun',LoadVar('AlterFiles'),'_LinNear.eeg',{'speed.p0','accel.p0'})
%analProgName = 'CalcRunningSpectra9_noExp';
%nameNote = 'firstRun';
%files = LoadVar('AlterFiles');
%fileExt = '_LinNear.eeg';
%indepVarCell = {'speed.p0','accel.p0'};
varargin = DefaultArgs(varargin,{[]});

chanDir = 'ChanInfo/';
chanMat = LoadVar([chanDir 'ChanMat' fileExt '.mat']);
selChans = load([chanDir 'SelectedChannels' fileExt '.txt']);
nchan = max(max(chanMat));

GlmWholeModel01(analProgName,nameNote,files,fileExt,'thetaPowPeak6-12Hz',indepVarCell,nchan,0,varargin)
GlmWholeModel01(analProgName,nameNote,files,fileExt,'thetaPowIntg6-12Hz',indepVarCell,nchan,0,varargin)
GlmWholeModel01(analProgName,nameNote,files,fileExt,'gammaPowPeak60-120Hz',indepVarCell,nchan,0,varargin)
GlmWholeModel01(analProgName,nameNote,files,fileExt,'gammaPowIntg60-120Hz',indepVarCell,nchan,0,varargin)
for j=1:length(selChans)
    selChanName = ['.ch' num2str(selChans(j))]
    GlmWholeModel01(analProgName,nameNote,files,fileExt,['thetaCohMedian6-12Hz' selChanName],indepVarCell,nchan,0,varargin)
    GlmWholeModel01(analProgName,nameNote,files,fileExt,['gammaCohMedian60-120Hz' selChanName],indepVarCell,nchan,0,varargin)
end
% GlmWholeModel01(analProgName,nameNote,files,fileExt,'powSpec.yo',indepVarCell,nchan,1,varargin)
% for j=1:length(selChans)
%     selChanName = ['.ch' num2str(selChans(j))]
%     GlmWholeModel01(analProgName,nameNote,files,fileExt,['cohSpec.yo' selChanName],indepVarCell,nchan,1,varargin)
% end