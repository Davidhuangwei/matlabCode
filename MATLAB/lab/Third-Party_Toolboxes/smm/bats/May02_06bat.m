analDirs = {...
            '/BEEF02/smm/sm9614_Analysis/analysis02/',...
             '/BEEF02/smm/sm9608_Analysis/analysis02',...
             '/BEEF01/smm/sm9601_Analysis/analysis03/',...
            '/BEEF01/smm/sm9603_Analysis/analysis04/',...
            }
 fileExtCell = {...
                  '.eeg',...
                 '_LinNearCSD121.csd',...
%                   '_NearAveCSD1.csd',...
                }
            
depVarCell = {...
%                  'powSpec.yo',...
%                  'cohSpec.yo',...
%                  'thetaPowIntg6-12Hz',...
                'gammaPowIntg40-120Hz',...
%                  'thetaCohMean6-12Hz',...
%                  'gammaCohMean40-120Hz',...
%                  'gammaPowIntg40-100Hz',...
%                  'gammaPowIntg50-100Hz',...
%                  'gammaPowIntg50-120Hz',...
%                  'gammaPowIntg60-120Hz',...
%                   'gammaCohMean40-100Hz',...
%                  'gammaCohMean50-100Hz',...
%                  'gammaCohMean50-120Hz',...
%                  'gammaCohMean60-120Hz',...
%                   'thetaPhaseMean6-12Hz',...

%                 'thetaPowPeak6-12Hz',...
%                  'gammaPowIntg60-120Hz',...
%                   'gammaCohMean60-120Hz',...
%                 'thetaPowIntg6-12Hz',...
%                 'thetaCohMean6-12Hz',...
%                   'thetaPhaseMean6-12Hz',...
%                  'gammaPhaseMean60-120Hz',...
                 
%                 'thetaCohPeakLMF6-12Hz',...
                %'gammaPowPeak60-120Hz',...
                %'thetaCohPeakSelChF6-12Hz',...
                %'thetaCohMedian6-12Hz',...
                %'gammaCohMedian60-120Hz',...
                };
            
analRoutine = {...
                %'RemVsRun_thetaFreqSelCh3_allTrials',...
                %'RemVsRun_thetaFreqSelCh3',...
                %'RemVsThetaFreqSelCh1',...
                %'MazeVsThetaFreqSelCh1',...
                %'MazeVsThetaFreqSelCh1_allTrials',...
                %'RemVsThetaFreqSelCh2',...
                %'MazeVsThetaFreqSelCh2',...
                %'MazeVsThetaFreqSelCh2_allTrials',...
                %'RemVsThetaFreqSelCh3',...
                %'MazeVsThetaFreqSelCh3',...
                %'RemVsRun',...
                %'RemVsRun_allTrials',...
                %'RemVsRun_thetaFreqSelCh1',...
                %'RemVsRun_thetaFreqSelCh1_allTrials',...
                %'RemVsRunXthetaFreqSelCh1',...
                %'RemVsRunXthetaFreqSelCh1_allTrials',...
                %'RemVsRun_thetaFreqSelCh1_X',...
                %'RemVsRun_thetaFreqSelCh1_X_allTrials',...
%                 'AlterGood_MRcVo'
%                  'AlterGood_S0_A0_MRcVo'
%                  'MazeCenter_TT',...
%                 'AlterGood_MR',...
%                'AlterGood_S0_A0_MR',...
                 'MazeCenter_S0_A0_TT',...
%                    'AlterGood_S0_A0_MR_trialMean',...
%                  'MazeGood_S0_A0_TT',...
%                  'MazeGood_S0_A0_TT_MR_TTxMR',...
%                    'MazeGood_S0_A0_TT_MR_TTxMR_allControl',...
%                       'ControlGood_S0_A0_MR',...
%                  'AlterGood_S0_A0_RL_MR',...
%                  'AlterGood_S0_A0_RL_MR_RLxMR',...
%                  'MazeGood_S1000by500_A1000by500',...
%                   'AlterAll_S0_A0_E_MR',...
%                   'AlterAll_S0_A0_E_MR_ExMR',...
%                   'MazeGood_S500by250_A500by250',... 
%                'MazeAll_S1000by250e_A1000by250e',...
                %'MazeGood_S0_A0_TT_TTxMR',...
                   %'AlterGood_S0_A0_MR_RLxMR',...
                 %'AlterAll_S0_A0_MR_ExMR',...
            };
            
for m=1:length(analRoutine)
    for j=1:length(fileExtCell)
        for k=1:length(analDirs)
            cd(analDirs{k})
            try
             GlmWholeAnalysisBatch05_2('CalcRunningSpectra9_noExp',analRoutine{m},'01',fileExtCell{j},depVarCell)
                %GlmWholeAnalysisBatch05('RemVsRun_noExp',analRoutine{m},'01',fileExtCell{j},[],0,[],1250)
            catch
                ReportError(['/u12/smm/BatchLogs/MatlabLog.txt'],...
                    ['ERROR:  ' date '  May02_06bat  ' analDirs{k} '  ' fileExtCell{j} '  ' analRoutine{m} '\n']);
            end
        end
    end
end

for m=1:length(analRoutine)
    for j=1:length(fileExtCell)
%         try
              PlotGlmScat08('Min',depVarCell,fileExtCell{j},[analRoutine{m} '_01'],analDirs,'GlmWholeModel05/','MazePaper/new/',0)
%         catch end
%            try
%                  PlotGlmBarh02('Min',depVarCell,fileExtCell{j},[analRoutine{m} '_01'],analDirs,'GlmWholeModel05/','MazePaper/new/')
%           catch end
%         try
%             PlotGlmCoh07('Min',depVarCell,fileExtCell{j},[analRoutine{m} '_01'],analDirs,'GlmWholeModel05/','MazePaper/new/')
%         catch end
%        try
%              PlotGlmPhase06('Perp',depVarCell,fileExtCell{j},[analRoutine{m} '_01'],analDirs)
%        catch end
     end
end

GlmWholeModel05(dataDescription,analRoutine,outNameNote,fileExt,depVar,varargin)
GlmWholeModel05(analProgName,analRoutine,nameNote,fileExt,'thetaPowPeak4-12Hz',nchan,0,varargin)

GlmWholeModel05(analProgName,analRoutine,nameNote,files,fileExt,['thetaCohMedian4-12Hz' selChanName],nchan,0,varargin)
GlmWholeModel05(dataDescription,analRoutine,outNameNote,fileExt,depVar,varargin)
[nChan,freqBool,maxFreq,midPointsBool,minSpeed,winLength] ...
    = DefaultArgs(varargin,{96,0,150,1,0,626});


PlotGLMResults05('GlmWholeModel05',[analRoutine{1} '_01'],depVarCell{2},'.eeg',0,'linear',1)

analRoutine = {...
                %'RemVsRun_thetaFreqSelCh3_allTrials'...
                %'RemVsRun_thetaFreqSelCh3'...
                %'RemVsThetaFreqSelCh1'...
                %'MazeVsThetaFreqSelCh1'...
                %'MazeVsThetaFreqSelCh1_allTrials'...
                %'RemVsThetaFreqSelCh2'...
                %'MazeVsThetaFreqSelCh2'...
                %'MazeVsThetaFreqSelCh2_allTrials'...
                %'RemVsThetaFreqSelCh3'...
                %'MazeVsThetaFreqSelCh3'...
                %'RemVsRun'...
                %'RemVsRun_allTrials'...
                %'RemVsRun_thetaFreqSelCh1'...
                %'RemVsRun_thetaFreqSelCh1_allTrials'...
                %'RemVsRunXthetaFreqSelCh1'...
                %'RemVsRunXthetaFreqSelCh1_allTrials'...
                %'RemVsRun_thetaFreqSelCh1_X'...
                %'RemVsRun_thetaFreqSelCh1_X_allTrials'...
%                 'AlterGood_S0_A0_RL_MR'...
%                 'AlterGood_S0_A0_MR_RLxMR'...
%                 'AlterGood_S0_A0_RL_MR_RLxMR'...
%                 'AlterAll_S0_A0_E_MR'...
%                 'AlterAll_S0_A0_MR_ExMR'...
%                 'AlterAll_S0_A0_E_MR_ExMR'...
%                 'MazeGood_S0_A0_TT'...
%                  'MazeCenter_TT',...
%                  'AlterGood_MR',...
%                  'AlterGood',...
%                   'MazeCenter_S0_A0_TT'...
%                  'AlterGood_S0_A0_MR'...
%                  'AlterGood_S0_A0_MRcVo'
                 'AlterGood_MRcVo'
%                  'ControlGood_S0_A0_MR'
%                  'MazeGood_S0_A0_TT_MR_TTxMR'...
%                  'MazeGood_S0_A0_TT_MR_TTxMR_allControl'...
%                 'MazeGood_S0_A0_TT_TTxMR'...
%                 'MazeCenter_S0_A0_TT'...
%                 'MazeGood_S1000by500_A1000by500'...
%                'AlterGood_S0_A0_MR_trialMean'...
                };
TrialDesigLists03(analRoutine)

analRoutine = {...
                'RemVsThetaFreqSelCh1_01'...
                'RemVsRun_01'...
                'RemVsRun_allTrials_01'...
                'RemVsRun_thetaFreqSelCh1_01'...
                'RemVsRun_thetaFreqSelCh1_allTrials_01'...
                'RemVsRunXthetaFreqSelCh1_01'...
                'RemVsRunXthetaFreqSelCh1_allTrials_01'...
                'RemVsRun_thetaFreqSelCh1_X_01'...
                'RemVsRun_thetaFreqSelCh1_X_allTrials_01'...
                };
for j=1:length(analRoutine)
    PlotGlmScat03('Min',analRoutine{j});
end



analDirs = {...
            '/BEEF02/smm/sm9614_Analysis/analysis02/',...
            '/BEEF02/smm/sm9608_Analysis/analysis02',...
            '/BEEF01/smm/sm9601_Analysis/analysis03/'...
            '/BEEF01/smm/sm9603_Analysis/analysis04/'...
            }
for k=1:length(analDirs)
    cd(analDirs{k});
    CalcPartCoh01([LoadVar('MazeFiles');LoadVar('RemFiles')],{'.eeg'},[4 12],[60 120]);
end


for j=1:length(analDirs)
    cd(analDirs{j})
    RecalcThetaGammaRange02(LoadVar('MazeFiles'),fileExtCell,[6 12],[]);
    RecalcThetaGammaRange02(LoadVar('MazeFiles'),fileExtCell,[],[40 60]);
    RecalcThetaGammaRange02(LoadVar('MazeFiles'),fileExtCell,[],[40 100]);
    RecalcThetaGammaRange02(LoadVar('MazeFiles'),fileExtCell,[],[40 120]);
    RecalcThetaGammaRange02(LoadVar('MazeFiles'),fileExtCell,[],[50 100]);
    RecalcThetaGammaRange02(LoadVar('MazeFiles'),fileExtCell,[],[50 120]);
    RecalcThetaGammaRange02(LoadVar('MazeFiles'),fileExtCell,[],[60 120]);
end




