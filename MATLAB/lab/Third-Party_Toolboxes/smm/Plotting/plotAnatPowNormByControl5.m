function plotAnatPowNormByControl4(expTaskType,expFileBaseMat,controlTaskType,controlFileBaseMat,fileNameFormat,fileExt,chanMat,badchan,lowCut,highCut,onePointBool,samescale,dbscale,subtractBool)

if ~exist('samescale','var')
    samescale = 0;
end
if ~exist('badchan','var')
    badchan = 0;
end
if ~exist('dbscale','var')
    dbscale = 1;
end
alpha = .001;

PlotAnatMazeRegionZ(expTaskType,expFileBaseMat,fileNameFormat,fileExt,chanMat,badchan,lowCut,highCut,onePointBool,samescale,dbscale)
PlotAnatMazeRegionZ(controlTaskType,controlFileBaseMat,fileNameFormat,fileExt,chanMat,badchan,lowCut,highCut,onePointBool,samescale,dbscale)

if fileNameFormat == 0,
    if onePointBool
        expFileName = [expTaskType '_' expFileBaseMat(1,[1:7 10:12 14 17:19]) '-' expFileBaseMat(end,[7 10:12 14 17:19]) ...
            fileExt '_' num2str(lowCut) '-' num2str(highCut) 'Hz_point_AnatMazeRegionPow.mat'];
        controlFileName = [controlTaskType '_' controlFileBaseMat(1,[1:7 10:12 14 17:19]) '-' controlFileBaseMat(end,[7 10:12 14 17:19]) ...
            fileExt '_' num2str(lowCut) '-' num2str(highCut) 'Hz_point_AnatMazeRegionPow.mat'];
    else
        expFileName = [expTaskType '_' expFileBaseMat(1,[1:7 10:12 14 17:19]) '-' expFileBaseMat(end,[7 10:12 14 17:19]) ...
            fileExt '_' num2str(lowCut) '-' num2str(highCut) 'Hz_mean_AnatMazeRegionPow.mat'];
        controlFileName = [controlTtaskType '_' controlFileBaseMat(1,[1:7 10:12 14 17:19]) '-' controlFileBaseMat(end,[7 10:12 14 17:19]) ...
            fileExt '_' num2str(lowCut) '-' num2str(highCut) 'Hz_mean_AnatMazeRegionPow.mat'];
    end

end
if fileNameFormat == 2,
    if onePointBool
        expFileName = [expTaskType '_' expFileBaseMat(1,[1:10]) '-' expFileBaseMat(end,[8:10]) ...
            fileExt '_' num2str(lowCut) '-' num2str(highCut) 'Hz_point_AnatMazeRegionPow.mat'];
        controlFileName = [controlTaskType '_' controlFileBaseMat(1,[1:10]) '-' controlFileBaseMat(end,[8:10]) ...
            fileExt '_' num2str(lowCut) '-' num2str(highCut) 'Hz_point_AnatMazeRegionPow.mat'];
    else
        expFileName = [expTaskType '_' expFileBaseMat(1,[1:10]) '-' expFileBaseMat(end,[8:10]) ...
            fileExt '_' num2str(lowCut) '-' num2str(highCut) 'Hz_mean_AnatMazeRegionPow.mat'];
        controlFileName = [controlTtaskType '_' controlFileBaseMat(1,[1:10]) '-' controlFileBaseMat(end,[8:10]) ...
            fileExt '_' num2str(lowCut) '-' num2str(highCut) 'Hz_mean_AnatMazeRegionPow.mat'];
    end
end

fprintf('loading %s\n',expFileName)
if exist(expFileName,'file')
    load(expFileName);
else
    ERROR_RUN_CalcAnatMazeRegionPow
end
expReturnarmPowMat = returnarmPowMat;
expCenterarmPowMat = centerarmPowMat;
expChoicearmPowMat = choicearmPowMat;
expChoicepointPowMat = choicepointPowMat;
 
fprintf('loading %s\n',controlFileName)
if exist(controlFileName,'file')
    load(controlFileName);
else
    ERROR_RUN_CalcAnatMazeRegionPow
end
controlReturnarmPowMat = returnarmPowMat;
controlCenterarmPowMat = centerarmPowMat;
controlChoicearmPowMat = choicearmPowMat;
controlChoicepointPowMat = choicepointPowMat;

if dbscale
    expReturnarmPowMat = 10.*log10(expReturnarmPowMat);
    expCenterarmPowMat = 10.*log10(expCenterarmPowMat);
    expChoicearmPowMat = 10.*log10(expChoicearmPowMat);
    expChoicepointPowMat = 10.*log10(expChoicepointPowMat);

    controlReturnarmPowMat = 10.*log10(controlReturnarmPowMat);
    controlCenterarmPowMat = 10.*log10(controlCenterarmPowMat);
    controlChoicearmPowMat = 10.*log10(controlChoicearmPowMat);
    controlChoicepointPowMat = 10.*log10(controlChoicepointPowMat);
end

expCenterAnatPowMat = zeros(size(chanMat))*NaN;
expRewardAnatPowMat = zeros(size(chanMat))*NaN;
expReturnAnatPowMat = zeros(size(chanMat))*NaN;
expChoiceAnatPowmat = zeros(size(chanMat))*NaN;

controlCenterAnatPowMat = zeros(size(chanMat))*NaN;
controlRewardAnatPowMat = zeros(size(chanMat))*NaN;
controlReturnAnatPowMat = zeros(size(chanMat))*NaN;
controlChoiceAnatPowmat = zeros(size(chanMat))*NaN;

expSdCenterAnatPowMat = zeros(size(chanMat))*NaN;
expSdRewardAnatPowMat = zeros(size(chanMat))*NaN;
expSdReturnAnatPowMat = zeros(size(chanMat))*NaN;
expSdChoiceAnatPowmat = zeros(size(chanMat))*NaN;

controlSdCenterAnatPowMat = zeros(size(chanMat))*NaN;
controlSdRewardAnatPowMat = zeros(size(chanMat))*NaN;
controlSdReturnAnatPowMat = zeros(size(chanMat))*NaN;
controlSdChoiceAnatPowmat = zeros(size(chanMat))*NaN;

diffCenterAnatPowMat = zeros(size(chanMat))*NaN;
diffRewardAnatPowMat = zeros(size(chanMat))*NaN;
diffReturnAnatPowMat = zeros(size(chanMat))*NaN;
diffChoiceAnatPowmat = zeros(size(chanMat))*NaN;

normCenterAnatPowMat = zeros(size(chanMat))*NaN;
normRewardAnatPowMat = zeros(size(chanMat))*NaN;
normReturnAnatPowMat = zeros(size(chanMat))*NaN;
normChoiceAnatPowmat = zeros(size(chanMat))*NaN;

pCenterAnatPowMat = zeros(size(chanMat))*NaN;
pRewardAnatPowMat = zeros(size(chanMat))*NaN;
pReturnAnatPowMat = zeros(size(chanMat))*NaN;
pChoiceAnatPowmat = zeros(size(chanMat))*NaN;

hCenterAnatPowMat = zeros(size(chanMat))*NaN;
hRewardAnatPowMat = zeros(size(chanMat))*NaN;
hReturnAnatPowMat = zeros(size(chanMat))*NaN;
hChoiceAnatPowmat = zeros(size(chanMat))*NaN;


if 0
    normMeanCenter = mean(expCenterarmPowMat,1) - mean(controlCenterarmPowMat,1);
    normMeanReward = mean(expChoicearmPowMat,1) - mean(controlChoicearmPowMat,1);
    normMeanCP = mean(expChoicepointPowMat,1) - mean(controlChoicepointPowMat,1);
    normMeanReturn = mean(expReturnarmPowMat,1) - mean(controlReturnarmPowMat,1);
end
if 0
    normMeanCenter = mean(expCenterarmPowMat,1) ./ mean(controlCenterarmPowMat,1);
    normMeanReward = mean(expChoicearmPowMat,1) ./ mean(controlChoicearmPowMat,1);
    normMeanCP = mean(expChoicepointPowMat,1) ./ mean(controlChoicepointPowMat,1);
    normMeanReturn = mean(expReturnarmPowMat,1) ./ mean(controlReturnarmPowMat,1);
end



centerAnatPowMat = zeros(size(chanMat))*NaN;
rewardAnatPowMat = zeros(size(chanMat))*NaN;
returnAnatPowMat = zeros(size(chanMat))*NaN;
choiceAnatPowmat = zeros(size(chanMat))*NaN;

[nChanY nChanX] = size(chanMat);
for x=1:nChanX
    for y=1:nChanY
        if isempty(find(badchan==chanMat(y,x))), % if the channel isn't bad

            expCenterAnatPowMat(chanMat(y,x)) = mean(expCenterarmPowMat(:,chanMat(y,x)));
            expRewardAnatPowMat(chanMat(y,x)) = mean(expChoicearmPowMat(:,chanMat(y,x)));
            expReturnAnatPowMat(chanMat(y,x)) = mean(expReturnarmPowMat(:,chanMat(y,x)));
            expChoiceAnatPowmat(chanMat(y,x)) = mean(expChoicepointPowMat(:,chanMat(y,x)));
keyboard
            controlCenterAnatPowMat(chanMat(y,x)) = mean(controlCenterarmPowMat(:,chanMat(y,x)));
            controlRewardAnatPowMat(chanMat(y,x)) = mean(controlChoicearmPowMat(:,chanMat(y,x)));
            controlReturnAnatPowMat(chanMat(y,x)) = mean(controlReturnarmPowMat(:,chanMat(y,x)));
            controlChoiceAnatPowmat(chanMat(y,x)) = mean(controlChoicepointPowMat(:,chanMat(y,x)));
            
            expSdCenterAnatPowMat(chanMat(y,x)) = std(expCenterarmPowMat(:,chanMat(y,x)));
            expSdRewardAnatPowMat(chanMat(y,x)) = std(expChoicearmPowMat(:,chanMat(y,x)));
            expSdReturnAnatPowMat(chanMat(y,x)) = std(expReturnarmPowMat(:,chanMat(y,x)));
            expSdChoiceAnatPowmat(chanMat(y,x)) = std(expChoicepointPowMat(:,chanMat(y,x)));
            
            controlSdCenterAnatPowMat(chanMat(y,x)) = std(controlCenterarmPowMat(:,chanMat(y,x)));
            controlSdRewardAnatPowMat(chanMat(y,x)) = std(controlChoicearmPowMat(:,chanMat(y,x)));
            controlSdReturnAnatPowMat(chanMat(y,x)) = std(controlReturnarmPowMat(:,chanMat(y,x)));
            controlSdChoiceAnatPowmat(chanMat(y,x)) = std(controlChoicepointPowMat(:,chanMat(y,x)));
            
            if dbscale==1
                diffCenterAnatPowMat(chanMat(y,x)) = mean(expCenterarmPowMat(:,chanMat(y,x)),1) - mean(controlCenterarmPowMat(:,chanMat(y,x)),1);
                diffRewardAnatPowMat(chanMat(y,x)) = mean(expChoicearmPowMat(:,chanMat(y,x)),1) - mean(controlChoicearmPowMat(:,chanMat(y,x)),1);
                diffReturnAnatPowMat(chanMat(y,x)) = mean(expReturnarmPowMat(:,chanMat(y,x)),1) - mean(controlReturnarmPowMat(:,chanMat(y,x)),1);
                diffChoiceAnatPowmat(chanMat(y,x)) = mean(expChoicepointPowMat(:,chanMat(y,x)),1) - mean(controlChoicepointPowMat(:,chanMat(y,x)),1);
            else
                diffCenterAnatPowMat(chanMat(y,x)) = mean(expCenterarmPowMat(:,chanMat(y,x)),1)./mean(controlCenterarmPowMat(:,chanMat(y,x)),1);
                diffRewardAnatPowMat(chanMat(y,x)) = mean(expChoicearmPowMat(:,chanMat(y,x)),1)./mean(controlChoicearmPowMat(:,chanMat(y,x)),1);
                diffReturnAnatPowMat(chanMat(y,x)) = mean(expReturnarmPowMat(:,chanMat(y,x)),1)./mean(controlReturnarmPowMat(:,chanMat(y,x)),1);
                diffChoiceAnatPowmat(chanMat(y,x)) = mean(expChoicepointPowMat(:,chanMat(y,x)),1)./mean(controlChoicepointPowMat(:,chanMat(y,x)),1);
            end

            [hCenterAnatPowMat(chanMat(y,x)), pCenterAnatPowMat(chanMat(y,x))] = ttest(expCenterarmPowMat(:,chanMat(y,x)),mean(controlCenterarmPowMat(:,chanMat(y,x)),1),alpha,'both');
            [hRewardAnatPowMat(chanMat(y,x)), pRewardAnatPowMat(chanMat(y,x))] = ttest(expChoicearmPowMat(:,chanMat(y,x)),mean(controlChoicearmPowMat(:,chanMat(y,x)),1),alpha,'both');
            [hReturnAnatPowMat(chanMat(y,x)), pReturnAnatPowMat(chanMat(y,x))] = ttest(expReturnarmPowMat(:,chanMat(y,x)),mean(controlReturnarmPowMat(:,chanMat(y,x)),1),alpha,'both');
            [hChoiceAnatPowmat(chanMat(y,x)), pChoiceAnatPowmat(chanMat(y,x))] = ttest(expChoicepointPowMat(:,chanMat(y,x)),mean(controlChoicepointPowMat(:,chanMat(y,x)),1),alpha,'both');

            pCenterAnatPowMat(chanMat(y,x)) = log10(pCenterAnatPowMat(chanMat(y,x)));
            pRewardAnatPowMat(chanMat(y,x)) = log10(pRewardAnatPowMat(chanMat(y,x)));
            pReturnAnatPowMat(chanMat(y,x)) = log10(pReturnAnatPowMat(chanMat(y,x)));
            pChoiceAnatPowmat(chanMat(y,x)) = log10(pChoiceAnatPowmat(chanMat(y,x)));

%            centerAnatPowMat(y,x) = normMeanCenter(chanMat(y,x));
%            rewardAnatPowMat(y,x) = normMeanReward(chanMat(y,x));
 %           returnAnatPowMat(y,x) = normMeanReturn(chanMat(y,x));
 %           choiceAnatPowmat(y,x) = normMeanCP(chanMat(y,x));
        end
    end
end


if expFileBaseMat(1,1:6) == 'sm9601'
    zeromat = ones(16,1)*NaN;
    
    centerAnatPowMat = [centerAnatPowMat(:,1) zeromat centerAnatPowMat(:,2:5)];
    rewardAnatPowMat = [rewardAnatPowMat(:,1) zeromat rewardAnatPowMat(:,2:5)];
    returnAnatPowMat = [returnAnatPowMat(:,1) zeromat returnAnatPowMat(:,2:5)];
    choiceAnatPowmat = [choiceAnatPowmat(:,1) zeromat choiceAnatPowmat(:,2:5)];

    avecenterAnatPowMat = [avecenterAnatPowMat(:,1) zeromat avecenterAnatPowMat(:,2:5)];
    averewardAnatPowMat = [averewardAnatPowMat(:,1) zeromat averewardAnatPowMat(:,2:5)];
    avereturnAnatPowMat = [avereturnAnatPowMat(:,1) zeromat avereturnAnatPowMat(:,2:5)];
    avechoiceAnatPowmat = [avechoiceAnatPowmat(:,1) zeromat avechoiceAnatPowmat(:,2:5)];
end


%figureMats = {{expReturnAnatPowMat,'exp mean return'},{expChoiceAnatPowmat,'exp mean choice'};...
%    {expCenterAnatPowMat,'exp mean center'},{expRewardAnatPowMat,'exp mean reward'}};
%nimagesc(figureMats,1,[]);

%figureMats = {{controlReturnAnatPowMat,'control mean return'},{controlChoiceAnatPowmat,'control mean choice'};...
%    {controlCenterAnatPowMat,'control mean center'},{controlRewardAnatPowMat,'control mean reward'}};
%nimagesc(figureMats,1,[]);

%figureMats = {{expSdReturnAnatPowMat,'exp sd return'},{expSdChoiceAnatPowmat,'exp sd choice'};...
%    {expSdCenterAnatPowMat,'exp sd center'},{expSdRewardAnatPowMat,'exp sd reward'}};
%nimagesc(figureMats,1,[]);

%figureMats = {{controlSdReturnAnatPowMat,'control sd return'},{controlSdChoiceAnatPowmat,'control sd choice'};...
%    {controlSdCenterAnatPowMat,'control sd center'},{controlSdRewardAnatPowMat,'control sd reward'}};
%nimagesc(figureMats,1,[]);
           
figureMats = {{diffReturnAnatPowMat,'norm by control return'},{diffChoiceAnatPowmat,'norm by control choice'};...
    {diffCenterAnatPowMat,'norm by control center'},{diffRewardAnatPowMat,'norm by control reward'}};
nimagesc(figureMats,1,[-2 2]);

figureMats = {{hReturnAnatPowMat,'h return'},{hChoiceAnatPowmat,'h choice'};...
    {hCenterAnatPowMat,'h center'},{hRewardAnatPowMat,'h reward'}};
nimagesc(figureMats,1,[-1 1]);

figureMats = {{pReturnAnatPowMat,'p return'},{pChoiceAnatPowmat,'p choice'};...
    {pCenterAnatPowMat,'p center'},{pRewardAnatPowMat,'p reward'}};
nimagesc(figureMats,1,[]);

