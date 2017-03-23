function plotAnatPowNormByControl9(expTaskType,expFileBaseMat,controlTaskType,controlFileBaseMat,fileNameFormat,fileExt,chanMat,badchan,lowCut,highCut,onePointBool,samescale,dbscale,plotAnatBool,textBool)

if ~exist('samescale','var')
    samescale = 0;
end
if ~exist('badchan','var')
    badchan = 0;
end
if ~exist('dbscale','var')
    dbscale = 1;
end
if ~exist('textBool','var')
    textBool = 0;
end
if ~exist('plotAnatBool','var')
    plotAnatBool = 1;
end


alpha = .01;


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
if exist('returnArmPowMat','var') % new nomeclature
    expReturnArm = returnArmPowMat;
    expCenterArm = centerArmPowMat;
    expGoalArm = goalArmPowMat;
    expTjunction = TjunctionPowMat;
    clear  returnArmPowMat;
    clear centerArmPowMat;
    clear goalAarmPowMat;
    clear TjunctionPowMat;
else
    expReturnArm = returnarmPowMat;
    expCenterArm = centerarmPowMat;
    expGoalArm = choicearmPowMat;
    expTjunction = choicepointPowMat;
    clear  returnarmPowMat;
    clear centerarmPowMat;
    clear choicearmPowMat;
    clear choicepointPowMat;
end

fprintf('loading %s\n',controlFileName)
if exist(controlFileName,'file')
    load(controlFileName);
else
    ERROR_RUN_CalcAnatMazeRegionPow
end

if exist('returnArmPowMat','var') % new nomeclature
    controlReturnArm = returnArmPowMat;
    controlCenterArm = centerArmPowMat;
    controlGoalArm = goalArmPowMat;
    controlTjunction = TjunctionPowMat;
    clear  returnArmPowMat;
    clear centerArmPowMat;
    clear goalAarmPowMat;
    clear TjunctionPowMat;
else
    controlReturnArm = returnarmPowMat;
    controlCenterArm = centerarmPowMat;
    controlGoalArm = choicearmPowMat;
    controlTjunction = choicepointPowMat;
    clear  returnarmPowMat;
    clear centerarmPowMat;
    clear choicearmPowMat;
    clear choicepointPowMat;
end

if 0 % adjust for unequal n
    nExpTrials = size(expReturnArm,1);
    controlReturnArm = controlReturnArm(1:nExpTrials,:);
    controlCenterArm = controlCenterArm(1:nExpTrials,:);
    controlGoalArm = controlGoalArm(1:nExpTrials,:);
    controlTjunction = controlTjunction(1:nExpTrials,:);
end
shiftChan = 'NoChanShift'
if strcmp(shiftChan,'ChanShift') % shift control channels up 1
    for i=0:5
        fprintf('\n\n!!!!!!!! SHIFTING EXP CHANNELS UP ONE !!!!!!\n\n')
        expReturnArm(:,i*16+1:i*16+15) = expReturnArm(:,i*16+2:i*16+16);
        expCenterArm(:,i*16+1:i*16+15) = expCenterArm(:,i*16+2:i*16+16);
        expGoalArm(:,i*16+1:i*16+15) = expGoalArm(:,i*16+2:i*16+16);
        expTjunction(:,i*16+1:i*16+15) = expTjunction(:,i*16+2:i*16+16);
    end
end

if strcmp(controlTaskType,'circle')
    tmp = controlCenterArm;
    controlCenterArm = controlReturnArm;
    controlReturnArm = tmp;
    expMazeRegions = {'Return','Center','Tjunction','Goal'};
    controlMazeRegions = {'Quad2','Quad1','Quad3','Quad4'};
    vsMazeRegions = {'Return vs. Quad2','center vs. Quad1','choice vs. Quad3','Goal vs. Quad4'};
else
    expMazeRegions = {'Return','Center','Tjunction','Goal'};
    controlMazeRegions = {'Return','Center','Tjunction','Goal'};
    vsMazeRegions = {'Return','Center','Tjunction','Goal'};
end

if dbscale
    expReturnArm = 10.*log10(expReturnArm);
    expCenterArm = 10.*log10(expCenterArm);
    expGoalArm = 10.*log10(expGoalArm);
    expTjunction = 10.*log10(expTjunction);

    controlReturnArm = 10.*log10(controlReturnArm);
    controlCenterArm = 10.*log10(controlCenterArm);
    controlGoalArm = 10.*log10(controlGoalArm);
    controlTjunction = 10.*log10(controlTjunction);
end

% exp calculations
meanExpReturnArm = mean(expReturnArm,1);
meanExpCenterArm = mean(expCenterArm,1);
meanExpGoalArm = mean(expGoalArm,1);
meanExpTjunction = mean(expTjunction,1);
        
expAvePowPerTrial = mean(cat(3,expReturnArm, expCenterArm, expGoalArm, expTjunction),3);
expAvePowPerChan = mean(expAvePowPerTrial,1);

sdExpCenterArm = std(expCenterArm,1);
sdExpGoalArm = std(expGoalArm,1);
sdExpReturnArm = std(expReturnArm,1);
sdExpTjunction = std(expTjunction,1);
sdExpPowerPerChan = mean([sdExpReturnArm; sdExpCenterArm; sdExpTjunction; sdExpGoalArm],1);

if dbscale
    normExpCenterArm = meanExpCenterArm - expAvePowPerChan;
    normExpGoalArm = meanExpGoalArm - expAvePowPerChan;
    normExpReturnArm = meanExpReturnArm - expAvePowPerChan;
    normExpTjunction = meanExpTjunction - expAvePowPerChan;
else
    normExpCenterArm = meanExpCenterArm ./ expAvePowPerChan;
    normExpGoalArm = meanExpGoalArm ./ expAvePowPerChan;
    normExpReturnArm = meanExpReturnArm ./ expAvePowPerChan;
    normExpTjunction = meanExpTjunction ./ expAvePowPerChan;    
end

zExpCenterArm = (meanExpCenterArm - expAvePowPerChan)./sdExpPowerPerChan;
zExpGoalArm = (meanExpGoalArm - expAvePowPerChan)./sdExpPowerPerChan;
zExpReturnArm = (meanExpReturnArm - expAvePowPerChan)./sdExpPowerPerChan;
zExpTjunction = (meanExpTjunction - expAvePowPerChan)./sdExpPowerPerChan;

normExpCenterArm = Make2DPlotMat(normExpCenterArm,chanMat,badchan);
normExpGoalArm = Make2DPlotMat(normExpGoalArm,chanMat,badchan);
normExpReturnArm = Make2DPlotMat(normExpReturnArm,chanMat,badchan);
normExpTjunction = Make2DPlotMat(normExpTjunction,chanMat,badchan);

zExpCenterArm = Make2DPlotMat(zExpCenterArm,chanMat,badchan);
zExpGoalArm = Make2DPlotMat(zExpGoalArm,chanMat,badchan);
zExpReturnArm = Make2DPlotMat(zExpReturnArm,chanMat,badchan);
zExpTjunction = Make2DPlotMat(zExpTjunction,chanMat,badchan);


% control calculations
meanControlReturnArm = mean(controlReturnArm,1);
meanControlCenterArm = mean(controlCenterArm,1);
meanControlGoalArm = mean(controlGoalArm,1);
meanControlTjunction = mean(controlTjunction,1);
       
controlAvePowPerTrial = mean(cat(3,controlReturnArm, controlCenterArm, controlGoalArm, controlTjunction),3);
controlAvePowPerChan = mean(controlAvePowPerTrial,1);

sdControlCenterArm = std(controlCenterArm,1);
sdControlGoalArm = std(controlGoalArm,1);
sdControlReturnArm = std(controlReturnArm,1);
sdControlTjunction = std(controlTjunction,1);
sdControlPowerPerChan = mean([sdControlReturnArm; sdControlCenterArm; sdControlTjunction; sdControlGoalArm],1);

if dbscale
    normControlCenterArm = meanControlCenterArm - controlAvePowPerChan;
    normControlGoalArm = meanControlGoalArm - controlAvePowPerChan;
    normControlReturnArm = meanControlReturnArm - controlAvePowPerChan;
    normControlTjunction = meanControlTjunction - controlAvePowPerChan;
else
    normControlCenterArm = meanControlCenterArm ./ controlAvePowPerChan;
    normControlGoalArm = meanControlGoalArm ./ controlAvePowPerChan;
    normControlReturnArm = meanControlReturnArm ./ controlAvePowPerChan;
    normControlTjunction = meanControlTjunction ./ controlAvePowPerChan;    
end

zControlCenterArm = (meanControlCenterArm - controlAvePowPerChan)./sdControlPowerPerChan;
zControlGoalArm = (meanControlGoalArm - controlAvePowPerChan)./sdControlPowerPerChan;
zControlReturnArm = (meanControlReturnArm - controlAvePowPerChan)./sdControlPowerPerChan;
zControlTjunction = (meanControlTjunction - controlAvePowPerChan)./sdControlPowerPerChan;

normControlCenterArm = Make2DPlotMat(normControlCenterArm,chanMat,badchan);
normControlGoalArm = Make2DPlotMat(normControlGoalArm,chanMat,badchan);
normControlReturnArm = Make2DPlotMat(normControlReturnArm,chanMat,badchan);
normControlTjunction = Make2DPlotMat(normControlTjunction,chanMat,badchan);

zControlCenterArm = Make2DPlotMat(zControlCenterArm,chanMat,badchan);
zControlGoalArm = Make2DPlotMat(zControlGoalArm,chanMat,badchan);
zControlReturnArm = Make2DPlotMat(zControlReturnArm,chanMat,badchan);
zControlTjunction = Make2DPlotMat(zControlTjunction,chanMat,badchan);

%calculate normByControl
if dbscale
    expNormControlCenterArm = meanExpCenterArm - meanControlCenterArm;
    expNormControlGoalArm = meanExpGoalArm - meanControlGoalArm;
    expNormControlReturnArm = meanExpReturnArm - meanControlReturnArm;
    expNormControlTjunction = meanExpTjunction - meanControlTjunction;
    
    sdExpNormContPowerPerChan = sdExpPowerPerChan - sdControlPowerPerChan;
    
    sdExpNormContCenterArm = sdExpCenterArm - sdControlCenterArm;
    sdExpNormContGoalArm = sdExpGoalArm - sdControlGoalArm;
    sdExpNormContReturnArm = sdExpReturnArm - sdControlReturnArm;
    sdExpNormContTjunction = sdExpTjunction - sdControlTjunction;
    
    expNormControlAvePowPerChan = expAvePowPerChan - controlAvePowPerChan;
else
    expNormControlCenterArm = meanExpCenterArm ./ meanControlCenterArm;
    expNormControlGoalArm = meanExpGoalArm ./ meanControlGoalArm;
    expNormControlReturnArm = meanExpReturnArm ./ meanControlReturnArm;
    expNormControlTjunction = meanExpTjunction ./ meanControlTjunction;  
    
    sdExpNormContPowerPerChan = sdExpPowerPerChan ./ sdControlPowerPerChan;
    
    sdExpNormContCenterArm = sdExpCenterArm ./ sdControlCenterArm;
    sdExpNormContGoalArm = sdExpGoalArm ./ sdControlGoalArm;
    sdExpNormContReturnArm = sdExpReturnArm ./ sdControlReturnArm;
    sdExpNormContTjunction = sdExpTjunction ./ sdControlTjunction;
    
    expNormControlAvePowPerChan = expAvePowPerChan./controlAvePowPerChan;
end

expNormControlAvePowPerChan = Make2DPlotMat(expNormControlAvePowPerChan,chanMat,badchan);

avePowPerChan = mean(cat(1,expReturnArm, expCenterArm, expGoalArm, expTjunction, controlReturnArm, controlCenterArm, controlGoalArm, controlTjunction),1);
sdPowerPerChan = mean([sdExpReturnArm; sdExpCenterArm; sdExpTjunction; sdExpGoalArm; sdControlReturnArm; sdControlCenterArm; sdControlTjunction; sdControlGoalArm],1);
sdReturnArm = mean([sdExpReturnArm; sdControlReturnArm],1);
sdCenterArm = mean([sdExpCenterArm; sdControlCenterArm],1);
sdTjunction = mean([sdExpTjunction; sdControlTjunction],1);
sdGoalArm = mean([sdExpGoalArm; sdControlGoalArm],1);


expNormControlCenterArm = Make2DPlotMat(expNormControlCenterArm,chanMat,badchan);
expNormControlGoalArm = Make2DPlotMat(expNormControlGoalArm,chanMat,badchan);
expNormControlReturnArm = Make2DPlotMat(expNormControlReturnArm,chanMat,badchan);
expNormControlTjunction = Make2DPlotMat(expNormControlTjunction,chanMat,badchan);

sdExpNormContCenterArm = Make2DPlotMat(sdExpNormContCenterArm,chanMat,badchan);
sdExpNormContGoalArm = Make2DPlotMat(sdExpNormContGoalArm,chanMat,badchan);
sdExpNormContReturnArm = Make2DPlotMat(sdExpNormContReturnArm,chanMat,badchan);
sdExpNormContTjunction = Make2DPlotMat(sdExpNormContTjunction,chanMat,badchan);

sdPowerPerChan = Make2DPlotMat(sdPowerPerChan,chanMat,badchan);

sdReturnArm = Make2DPlotMat(sdReturnArm,chanMat,badchan);
sdCenterArm = Make2DPlotMat(sdCenterArm,chanMat,badchan);
sdTjunction = Make2DPlotMat(sdTjunction,chanMat,badchan);
sdGoalArm = Make2DPlotMat(sdGoalArm,chanMat,badchan);

% calculate t-tests
[m n] = size(expCenterArm);

hCenterArm = NaN*zeros(n);
hGoalArm = NaN*zeros(n);
hReturnArm = NaN*zeros(n);
hTjunction = NaN*zeros(n);

pCenterArm = NaN*zeros(n);
pGoalArm = NaN*zeros(n);
pReturnArm = NaN*zeros(n);
pTjunction = NaN*zeros(n);

for i = 1:n
    [hCenterArm(i), pCenterArm(i)] = ttest2(expCenterArm(:,i),controlCenterArm(:,i),alpha,'both');
    [hGoalArm(i), pGoalArm(i)] = ttest2(expGoalArm(:,i),controlGoalArm(:,i),alpha,'both');
    [hReturnArm(i), pReturnArm(i)] = ttest2(expReturnArm(:,i),controlReturnArm(:,i),alpha,'both');
    [hTjunction(i), pTjunction(i)] = ttest2(expTjunction(:,i),controlTjunction(:,i),alpha,'both');
end
pCenterArm = log10(pCenterArm);
pGoalArm = log10(pGoalArm);
pReturnArm = log10(pReturnArm);
pTjunction = log10(pTjunction);

hCenterArm = Make2DPlotMat(hCenterArm,chanMat,badchan);
hGoalArm = Make2DPlotMat(hGoalArm,chanMat,badchan);
hReturnArm = Make2DPlotMat(hReturnArm,chanMat,badchan);
hTjunction = Make2DPlotMat(hTjunction,chanMat,badchan);

pCenterArm = Make2DPlotMat(pCenterArm,chanMat,badchan);
pGoalArm = Make2DPlotMat(pGoalArm,chanMat,badchan);
pReturnArm = Make2DPlotMat(pReturnArm,chanMat,badchan);
pTjunction = Make2DPlotMat(pTjunction,chanMat,badchan);


if plotAnatBool
    anatFileName = [expFileBaseMat(1,1:6) 'AnatCurvScaled.mat'];
else
    anatFileName = [];
end

if dbscale
    colorLimits = [-2.5 2.5];
else
    colorLimits = [0.5 1.6];
end
figureMats = {{normExpReturnArm,['norm ' expTaskType ': ' expMazeRegions{1}]},{normExpCenterArm,['norm ' expTaskType ': ' expMazeRegions{2}]};...
              {normExpTjunction,['norm ' expTaskType ': ' expMazeRegions{3}]},{normExpGoalArm,['norm ' expTaskType ': ' expMazeRegions{4}]}};
[colorLimits, figureNum] = MNImageSc(figureMats,1,colorLimits,1,anatFileName);

figureMats = {{normControlReturnArm,['norm ' controlTaskType ': ' controlMazeRegions{1}]},{normControlCenterArm,['norm ' controlTaskType ': ' controlMazeRegions{2}]};...
              {normControlTjunction,['norm ' controlTaskType ': ' controlMazeRegions{3}]},{normControlGoalArm,['norm ' controlTaskType ': ' controlMazeRegions{4}]}};
MNImageSc(figureMats,1,colorLimits,2,anatFileName);

colorLimits = [-3.01 3.01];
figureMats = {{zExpReturnArm,['z ' expTaskType ': ' expMazeRegions{1}]},{zExpCenterArm,['z ' expTaskType ': ' expMazeRegions{2}]};...
              {zExpTjunction,['z ' expTaskType ': ' expMazeRegions{3}]},{zExpGoalArm,['z ' expTaskType ': ' expMazeRegions{4}]}};
[colorLimits, figureNum] = MNImageSc(figureMats,1,colorLimits,3,anatFileName);

figureMats = {{zControlReturnArm,['z ' controlTaskType ': ' controlMazeRegions{1}]},{zControlCenterArm,['z ' controlTaskType ': ' controlMazeRegions{2}]};...
              {zControlTjunction,['z ' controlTaskType ': ' controlMazeRegions{3}]},{zControlGoalArm,['z ' controlTaskType ': ' controlMazeRegions{4}]}};
MNImageSc(figureMats,1,colorLimits,4,anatFileName);

if dbscale
    colorLimits = [-1 1.01];
else
    colorLimits = [0.75 1.25];
end

figureMats = {{expNormControlAvePowPerChan,[expTaskType ' norm ' controlTaskType]}}
MNImageSc(figureMats,1,[-0.01 2],5,anatFileName);

figureMats = {{expNormControlReturnArm,[expTaskType ' norm ' controlTaskType ': ' vsMazeRegions{1}]},{expNormControlCenterArm, [expTaskType ' norm ' controlTaskType ': ' vsMazeRegions{2}]};...
              {expNormControlTjunction, [expTaskType ' norm ' controlTaskType ': ' vsMazeRegions{3}]},{expNormControlGoalArm, [expTaskType ' norm ' controlTaskType ': ' vsMazeRegions{4}]}};
MNImageSc(figureMats,1,[colorLimits],6,anatFileName);

colorLimits = [-1 1.01];
figureMats = {{sdReturnArm, 'sdReturnArm'},{sdCenterArm, 'sdCenterArm'};...
              {sdTjunction, 'sdTjunction'},{sdGoalArm, 'sdGoalArm'}};
MNImageSc(figureMats,1,[],7,anatFileName);

figureMats = {{sdPowerPerChan,'sdPowerPerChan'}};
MNImageSc(figureMats,1,[],8,anatFileName);

figureMats = {{sdExpNormContReturnArm,['sd ' expTaskType ' norm ' controlTaskType ': ' vsMazeRegions{1}]},{sdExpNormContCenterArm,['sd ' expTaskType ' norm ' controlTaskType ': ' vsMazeRegions{2}]};...
              {sdExpNormContTjunction,['sd ' expTaskType ' norm ' controlTaskType ': ' vsMazeRegions{3}]},{sdExpNormContGoalArm,['sd ' expTaskType ' norm ' controlTaskType ': ' vsMazeRegions{4}]}};
MNImageSc(figureMats,1,[colorLimits],9,anatFileName);

figureMats = {{hReturnArm,['h ' expTaskType ' vs. ' controlTaskType ': ' vsMazeRegions{1}]},{hCenterArm,['h ' expTaskType ' vs. ' controlTaskType ': ' vsMazeRegions{2}]};...
              {hTjunction,['h ' expTaskType ' vs. ' controlTaskType ': ' vsMazeRegions{3}]},{hGoalArm,['h ' expTaskType ' vs. ' controlTaskType ': ' vsMazeRegions{4}]}};
MNImageSc(figureMats,1,[-1 1],10,anatFileName);

colorLimits = [-14 0];
figureMats = {{pReturnArm,['p ' expTaskType ' vs. ' controlTaskType ': ' vsMazeRegions{1}]},{pCenterArm,['p ' expTaskType ' vs. ' controlTaskType ': ' vsMazeRegions{2}]};...
              {pTjunction,['p ' expTaskType ' vs. ' controlTaskType ': ' vsMazeRegions{3}]},{pGoalArm,['p ' expTaskType ' vs. ' controlTaskType ': ' vsMazeRegions{4}]}};
MNImageSc(figureMats,0,[],11,anatFileName);

if textBool
    if 1
        for i=1:10
            figure(i);
            if fileNameFormat == 0
                text(0,0,{[num2str(lowCut) '-' num2str(highCut) 'Hz Power'],fileExt,'',...
                    expTaskType, 'vs.', controlTaskType,' ',...
                    expFileBaseMat(1,1:6),[expFileBaseMat(1,[7 10:12 14 17:19]) '-'],expFileBaseMat(end,[7 10:12 14 17:19]),...
                    controlFileBaseMat(1,1:6),[controlFileBaseMat(1,[7 10:12 14 17:19]) '-'],controlFileBaseMat(end,[7 10:12 14 17:19]),...
                    ['alpha=' num2str(alpha)],['dbscale=' num2str(dbscale)],shiftChan})
            end
            if fileNameFormat == 2
                text(0,0,{[num2str(lowCut) '-' num2str(highCut) 'Hz Power'],fileExt,'',...
                    expTaskType, 'vs.', controlTaskType,' ',...
                    expFileBaseMat(1,1:6),[expFileBaseMat(1,[8:10]) '-'],expFileBaseMat(end,[8:10]),...
                    controlFileBaseMat(1,1:6),[controlFileBaseMat(1,[8:10]) '-'],controlFileBaseMat(end,[8:10]),...
                    ['alpha=' num2str(alpha)],['dbscale=' num2str(dbscale)],shiftChan})
            end

        end
    end
end

return





figureMats = {{,' Return'},{,' Tjunction'};...
    {,' Center'},{,' Goal'}};
nimagesc(figureMats,1,[]);


keyboard
outputMatCell = Make2DPlotMat(expCenterArm,chanMat,badchan);

if expFileBaseMat(1,1:6) == 'sm9601'
    zeromat = ones(16,1)*NaN;
    
    centerArm = [centerArm(:,1) zeromat centerArm(:,2:5)];
    rewardArm = [rewardArm(:,1) zeromat rewardArm(:,2:5)];
    returnArm = [returnArm(:,1) zeromat returnArm(:,2:5)];
    choiceArm = [choiceArm(:,1) zeromat choiceArm(:,2:5)];

    avecenterArm = [avecenterArm(:,1) zeromat avecenterArm(:,2:5)];
    averewardArm = [averewardArm(:,1) zeromat averewardArm(:,2:5)];
    avereturnArm = [avereturnArm(:,1) zeromat avereturnArm(:,2:5)];
    avechoiceArm = [avechoiceArm(:,1) zeromat avechoiceArm(:,2:5)];
end


%figureMats = {{meanExpReturnArm,'exp mean return'},{meanExpTjunction,'exp mean choice'};...
%    {meanExpCenterArm,'exp mean center'},{meanExpGoalArm,'exp mean reward'}};
%nimagesc(figureMats,1,[]);

%figureMats = {{controlReturnArm,'control mean return'},{controlTjunction,'control mean choice'};...
%    {controlCenterArm,'control mean center'},{controlRewardArm,'control mean reward'}};
%nimagesc(figureMats,1,[]);

%figureMats = {{expSdReturnArm,'exp sd return'},{expSdTjunction,'exp sd choice'};...
%    {expSdCenterArm,'exp sd center'},{expSdRewardArm,'exp sd reward'}};
%nimagesc(figureMats,1,[]);

%figureMats = {{controlSdReturnArm,'control sd return'},{controlSdTjunction,'control sd choice'};...
%    {controlSdCenterArm,'control sd center'},{controlSdRewardArm,'control sd reward'}};
%nimagesc(figureMats,1,[]);
           
figureMats = {{diffReturnArm,'norm by control return'},{diffTjunction,'norm by control choice'};...
    {diffCenterArm,'norm by control center'},{diffRewardArm,'norm by control reward'}};
nimagesc(figureMats,1,[-2 2]);

figureMats = {{hReturnArm,'h return'},{hTjunction,'h choice'};...
    {hCenterArm,'h center'},{hRewardArm,'h reward'}};
nimagesc(figureMats,1,[-1 1]);

figureMats = {{pReturnArm,'p return'},{pTjunction,'p choice'};...
    {pCenterArm,'p center'},{pRewardArm,'p reward'}};
nimagesc(figureMats,1,[]);

figureMats = {{,' Return'},{,' Tjunction'};...
    {,' Center'},{,' Reward'}};
nimagesc(figureMats,1,[]);

if 0
    zExpNormControlCenterArm = (meanExpCenterArm - meanControlCenterArm)./sdCenterArm;
    zExpNormControlGoalArm = (meanExpGoalArm - meanControlGoalArm)./sdGoalArm;
    zExpNormControlReturnArm = (meanExpReturnArm - meanControlReturnArm)./sdReturnArm;
    zExpNormControlTjunction = (meanExpTjunction - meanControlTjunction)./sdTjunction;
end
if 0
    zExpNormControlCenterArm = (meanExpCenterArm - avePowPerChan)./sdPowerPerChan;
    zExpNormControlGoalArm = (meanExpGoalArm - avePowPerChan)./sdPowerPerChan;
    zExpNormControlReturnArm = (meanExpReturnArm - avePowPerChan)./sdPowerPerChan;
    zExpNormControlTjunction = (meanExpTjunction - avePowPerChan)./sdPowerPerChan;
    
    zExpNormControlCenterArm = Make2DPlotMat(zExpNormControlCenterArm,chanMat,badchan);
    zExpNormControlGoalArm = Make2DPlotMat(zExpNormControlGoalArm,chanMat,badchan);
    zExpNormControlReturnArm = Make2DPlotMat(zExpNormControlReturnArm,chanMat,badchan);
    zExpNormControlTjunction = Make2DPlotMat(zExpNormControlTjunction,chanMat,badchan);
end
