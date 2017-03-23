function GlmWholeAnalysisBatch05_2(analProgName,analRoutine,nameNote,fileExt,depVarCell,varargin)
%function GlmWholeAnalysisBatch05(analProgName,analRoutine,nameNote,fileExt,varargin)
% GlmWholeAnalysisBatch05('CalcRunningSpectra9_noExp','Alter','secondRun',LoadVar('AlterFiles'),'_LinNear.eeg',{'speed.p0','accel.p0'})
% analProgName = 'CalcRunningSpectra9_noExp';
% analRoutine = 'Alter_Vs_Circle_CompSimRegions'
% nameNote = 'Test';
% files = LoadVar('AlterFiles');
% files = [LoadVar('AlterFiles');LoadVar('CircleFiles')];
% fileExt = '_LinNear.eeg';
% indepVarCell = {'speed.p0','accel.p0'};
% varargin = DefaultArgs(varargin,{[]});

chanDir = 'ChanInfo/';
chanMat = LoadVar([chanDir 'ChanMat' fileExt '.mat']);
selChans = load([chanDir 'SelectedChannels' fileExt '.txt']);
nchan = max(max(chanMat));

if ~isempty(intersect(depVarCell,'powSpec.yo'))
    GlmWholeModel05(analProgName,analRoutine,nameNote,fileExt,'powSpec.yo',[{0,nchan,1},varargin])
end
intersectCell = {...
                'thetaPowPeak6-12Hz',...
                 'thetaPowIntg6-12Hz',...
                 'gammaPowIntg40-100Hz',...
                 'gammaPowIntg40-120Hz',...
                 'gammaPowIntg50-100Hz',...
                 'gammaPowIntg50-120Hz',...
                 'gammaPowIntg60-120Hz',...
};
for j=1:length(depVarCell)
    if ~isempty(intersect(depVarCell{j},intersectCell))
        GlmWholeModel05(analProgName,analRoutine,nameNote,fileExt,depVarCell{j},[{0,nchan,0},varargin])
    end
end

for j=1:length(selChans)
    selChanName = ['.ch' num2str(selChans(j))]
    if ~isempty(intersect(depVarCell,'cohSpec.yo'))
        GlmWholeModel05(analProgName,analRoutine,nameNote,fileExt,['cohSpec.yo' selChanName],[{0,nchan,1},varargin])
    end
    
    intersectCell = {...
        'thetaCohMean6-12Hz',...
        'gammaCohMean60-120Hz',...
        'gammaCohMean40-100Hz',...
        'gammaCohMean40-120Hz',...
        'gammaCohMean50-100Hz',...
        'gammaCohMean50-120Hz',...
    };
    for k=1:length(depVarCell)
        if ~isempty(intersect(depVarCell{k},intersectCell))
            GlmWholeModel05(analProgName,analRoutine,nameNote,fileExt,[depVarCell{k} selChanName],[{0,nchan,0},varargin])
        end
    end
    
    intersectCell = {...
        'thetaPhaseMean6-12Hz',...
        'gammaPhaseMean60-120Hz',...
    };
    for k=1:length(depVarCell)
        if ~isempty(intersect(depVarCell{k},intersectCell))
            GlmWholeModel05(analProgName,analRoutine,nameNote,fileExt,[depVarCell{k} selChanName],[{1,nchan,0},varargin])
        end
    end
end

% for j=1:length(selChans)
%     for k=1:length(selChans)
%         selChanName = ['.ch' num2str(selChans(j))]
%         GlmWholeModel05(analProgName,analRoutine,nameNote,fileExt,['partThetaCohPeakLMF6-12HzCh' num2str(selChans(k)) selChanName],[{0,nchan,0},varargin])
%         GlmWholeModel05(analProgName,analRoutine,nameNote,fileExt,['partThetaCohPeakSelChF6-12HzCh' num2str(selChans(k)) selChanName],[{0,nchan,0},varargin])
%         GlmWholeModel05(analProgName,analRoutine,nameNote,fileExt,['partGammaCohMean60-120HzCh' num2str(selChans(k)) selChanName],[{0,nchan,0},varargin])
%     end
% end

% GlmWholeModel05(analProgName,analRoutine,nameNote,fileExt,'powSpec.yo',[{0,nchan,1},varargin])
% for j=1:length(selChans)
%     selChanName = ['.ch' num2str(selChans(j))]
%     GlmWholeModel05(analProgName,analRoutine,nameNote,fileExt,['cohSpec.yo' selChanName],[{0,nchan,1},varargin])
% end



% GlmWholeModel05(analProgName,analRoutine,nameNote,fileExt,'thetaPowPeak4-12Hz',[{0,nchan,0},varargin])
% GlmWholeModel05(analProgName,analRoutine,nameNote,fileExt,'gammaPowIntg60-120Hz',[{0,nchan,0},varargin])
%GlmWholeModel05(analProgName,analRoutine,nameNote,fileExt,'thetaPowIntg4-12Hz',[{1,nchan,0},varargin])
%GlmWholeModel05(analProgName,analRoutine,nameNote,fileExt,'gammaPowPeak60-120Hz',[{1,nchan,0},varargin])
% for j=1:length(selChans)
%     selChanName = ['.ch' num2str(selChans(j))]
%      GlmWholeModel05(analProgName,analRoutine,nameNote,fileExt,['thetaCohPeakLMF4-12Hz' selChanName],[{0,nchan,0},varargin])
%      GlmWholeModel05(analProgName,analRoutine,nameNote,fileExt,['thetaCohPeakSelChF4-12Hz' selChanName],[{0,nchan,0},varargin])
%      GlmWholeModel05(analProgName,analRoutine,nameNote,fileExt,['gammaCohMean60-120Hz' selChanName],[{0,nchan,0},varargin])
%    GlmWholeModel05(analProgName,analRoutine,nameNote,fileExt,['thetaCohMedian4-12Hz' selChanName],[{0,nchan,0},varargin])
%    GlmWholeModel05(analProgName,analRoutine,nameNote,fileExt,['gammaCohMedian60-120Hz' selChanName],[{0,nchan,0},varargin])
%    GlmWholeModel05(analProgName,analRoutine,nameNote,fileExt,['thetaPhaseMean4-12Hz' selChanName],[{1,nchan,0},varargin])
%    GlmWholeModel05(analProgName,analRoutine,nameNote,fileExt,['gammaPhaseMean60-120Hz' selChanName],[{1,nchan,0},varargin])
% end
% for j=1:length(selChans)
%     for k=1:length(selChans)
%         selChanName = ['.ch' num2str(selChans(j))]
%         GlmWholeModel05(analProgName,analRoutine,nameNote,fileExt,['partThetaCohPeakLMF4-12HzCh' num2str(selChans(k)) selChanName],[{0,nchan,0},varargin])
%         GlmWholeModel05(analProgName,analRoutine,nameNote,fileExt,['partThetaCohPeakSelChF4-12HzCh' num2str(selChans(k)) selChanName],[{0,nchan,0},varargin])
%         GlmWholeModel05(analProgName,analRoutine,nameNote,fileExt,['partGammaCohMean60-120HzCh' num2str(selChans(k)) selChanName],[{0,nchan,0},varargin])
%     end
% end

% GlmWholeModel05(analProgName,analRoutine,nameNote,fileExt,'powSpec.yo',[{0,nchan,1},varargin])
% for j=1:length(selChans)
%     selChanName = ['.ch' num2str(selChans(j))]
%     GlmWholeModel05(analProgName,analRoutine,nameNote,fileExt,['cohSpec.yo' selChanName],[{0,nchan,1},varargin])
% end