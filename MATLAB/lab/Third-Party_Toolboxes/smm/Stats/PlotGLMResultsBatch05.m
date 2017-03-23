
function PlotGLMResultsBatch05(junk)
%inNameNote = 'RemVsRun_01';
inNameNote = 'MazeCenter_S0_A0_TT_01';
inNameNote = 'AlterGood_S0_A0_MR_01';
dirname = 'GlmWholeModel05';
%fileExt = '.eeg';
fileExt = '_LinNearCSD121.csd';
chanInfoDir = 'ChanInfo/';
multiFreqBool = 0;
interpFunc = 'linear';
reportFigBool = 1;

for analBattery=[1 2]
    switch analBattery
        case 1
            depVar = 'thetaPowPeak6-12Hz'; selChan = 0;
        case 2
            depVar = 'gammaPowIntg60-120Hz'; selChan = 0;
         case 3
             depVar = 'thetaCohPeakLMF6-12Hz'; selChan = 1;
         case 4
             depVar = 'thetaCohPeakLMF6-12Hz'; selChan = 2;
%         case 5
%             depVar = 'thetaCohPeakLMF6-12Hz'; selChan = 3;
%         case 6
%             depVar = 'thetaCohPeakLMF6-12Hz'; selChan = 4;
%         case 7
%             depVar = 'thetaCohPeakLMF6-12Hz'; selChan = 5;
         case 8
             depVar = 'thetaCohPeakLMF6-12Hz'; selChan = 6;
         case 9
             depVar = 'gammaCohMean60-120Hz'; selChan = 1;
         case 10
             depVar = 'gammaCohMean60-120Hz'; selChan = 2;
%         case 11
%             depVar = 'gammaCohMean60-120Hz'; selChan = 3;
%         case 12
%             depVar = 'gammaCohMean60-120Hz'; selChan = 4;
%         case 13
%             depVar = 'gammaCohMean60-120Hz'; selChan = 5;
         case 14
             depVar = 'gammaCohMean60-120Hz'; selChan = 6;
%         case 15
%             depVar = 'thetaPhaseMean4-12Hz'; selChan = 1;
%         case 16
%             depVar = 'thetaPhaseMean4-12Hz'; selChan = 2;
%         case 17
%             depVar = 'thetaPhaseMean4-12Hz'; selChan = 3;
%         case 18
%             depVar = 'thetaPhaseMean4-12Hz'; selChan = 4;
%         case 19
%             depVar = 'thetaPhaseMean4-12Hz'; selChan = 5;
%         case 20
%             depVar = 'thetaPhaseMean4-12Hz'; selChan = 6;
%         case 21
%             depVar = 'gammaPhaseMean60-120Hz'; selChan = 1;
%         case 22
%             depVar = 'gammaPhaseMean60-120Hz'; selChan = 2;
%         case 23
%             depVar = 'gammaPhaseMean60-120Hz'; selChan = 3;
%         case 24
%             depVar = 'gammaPhaseMean60-120Hz'; selChan = 4;
%         case 25
%             depVar = 'gammaPhaseMean60-120Hz'; selChan = 5;
%         case 26
%             depVar = 'gammaPhaseMean60-120Hz'; selChan = 6;
    end
    if selChan ~= 0
        selChans = load([chanInfoDir 'SelectedChannels' fileExt '.txt']);
        selChanName = ['.ch' num2str(selChans(selChan))];
    else
        selChanName = '';
    end

    PlotGLMResults05(dirname,inNameNote,[depVar selChanName],fileExt,multiFreqBool,interpFunc,reportFigBool)
end



