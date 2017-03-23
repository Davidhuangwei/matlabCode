function GlmPlotBatch(analProgName,nameNote,fileExt,interpFunc)
%function GlmPlotBatch(analProgName,nameNote,fileExt,interpFunc)
%GlmPlotBatch('GlmWholeModel01','Alter_secondRun_','_LinNearCSD121.csd','linear')
%GlmPlotBatch('GlmWholeModel01','Alter_secondRun_','_LinNearCSD121.csd',[])
%GlmPlotBatch('GlmWholeModel01','Alter_secondRun_','.eeg',[])
% analProgName = 'GlmWholeModel01';
% analProgName = 'GlmWholeModel03';
% nameNote = 'Alter_secondRun_';
% fileExt = '_LinNear.eeg';
% fileExt = '_LinNearCSD121.csd';
% interpFunc = 'linear';
% interpFunc = [];

chanDir = 'ChanInfo/';
chanMat = LoadVar([chanDir 'ChanMat' fileExt '.mat']);
nchan = max(max(chanMat));
selChans = load([chanDir 'SelectedChannels' fileExt '.txt']);

% PlotGLMResults01(analProgName,nameNote,'thetaPowPeak6-12Hz',fileExt,0,interpFunc,1,[-1.5 1.5])
% close all
% PlotGLMResults01(analProgName,nameNote,'thetaPowIntg6-12Hz',fileExt,0,interpFunc,1,[-1.5 1.5])
% close all
% PlotGLMResults01(analProgName,nameNote,'gammaPowIntg60-120Hz',fileExt,0,interpFunc,1,[-1.2 1.2])
% close all
% PlotGLMResults01(analProgName,nameNote,'gammaPowPeak60-120Hz',fileExt,0,interpFunc,1,[-1.2 1.2])
% close all
% for j=1:length(selChans)
%     selChanName = ['.ch' num2str(selChans(j))]
%     PlotGLMResults01(analProgName,nameNote,['thetaCohMedian6-12Hz' selChanName],fileExt,0,interpFunc,1,[-.3 .3])
%     close all
%     PlotGLMResults01(analProgName,nameNote,['gammaCohMedian60-120Hz' selChanName],fileExt,0,interpFunc,1,[-.3 .3])
%     close all
% end
PlotGLMResults01(analProgName,nameNote,'powSpec.yo',fileExt,1,interpFunc,1,[-1.5 1.5])
close all
% for j=1:length(selChans)
%     selChanName = ['.ch' num2str(selChans(j))]
%     PlotGLMResults01(analProgName,nameNote,['cohSpec.yo' selChanName],fileExt,1,interpFunc,1,[-.5 .5])
%     close all
% end
