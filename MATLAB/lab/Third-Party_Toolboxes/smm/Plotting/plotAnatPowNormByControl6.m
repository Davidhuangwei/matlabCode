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

% exp calculations
expReturnAnatPowMat = mean(expReturnarmPowMat,1);
expCenterAnatPowMat = mean(expCenterarmPowMat,1);
expRewardAnatPowMat = mean(expChoicearmPowMat,1);
expChoiceAnatPowmat = mean(expChoicepointPowMat,1);
        
expAvePowPerTrial = mean(cat(3,expReturnarmPowMat, expCenterarmPowMat, expChoicearmPowMat, expChoicepointPowMat),3);
expAvePowPerChan = mean(expAvePowPerTrial,1);
sdExpPowerPerChan = mean([std(expReturnarmPowMat,1); std(expCenterarmPowMat,1); std(expChoicearmPowMat,1); std(expChoicepointPowMat,1)],1);

sdExpCenterAnatPowMat = std(expCenterarmPowMat,1);
sdExpRewardAnatPowMat = std(expChoicearmPowMat,1);
sdExpReturnAnatPowMat = std(expReturnarmPowMat,1);
sdExpChoiceAnatPowMat = std(expChoicepointPowMat,1);

if dbscale
    normExpCenterAnatPowMat = expCenterAnatPowMat - expAvePowPerChan;
    normExpRewardAnatPowMat = expRewardAnatPowMat - expAvePowPerChan;
    normExpReturnAnatPowMat = expReturnAnatPowMat - expAvePowPerChan;
    normExpChoiceAnatPowmat = expChoiceAnatPowmat - expAvePowPerChan;
else
    normExpCenterAnatPowMat = expCenterAnatPowMat ./ expAvePowPerChan;
    normExpRewardAnatPowMat = expRewardAnatPowMat ./ expAvePowPerChan;
    normExpReturnAnatPowMat = expReturnAnatPowMat ./ expAvePowPerChan;
    normExpChoiceAnatPowmat = expChoiceAnatPowmat ./ expAvePowPerChan;    
end

zExpCenterAnatPowMat = (expCenterAnatPowMat - expAvePowPerChan)./sdExpPowerPerChan;
zExpRewardAnatPowMat = (expRewardAnatPowMat - expAvePowPerChan)./sdExpPowerPerChan;
zExpReturnAnatPowMat = (expReturnAnatPowMat - expAvePowPerChan)./sdExpPowerPerChan;
zExpChoiceAnatPowmat = (expChoiceAnatPowmat - expAvePowPerChan)./sdExpPowerPerChan;

normExpCenterAnatPowMat = Make2DPlotMat(normExpCenterAnatPowMat,chanMat,badchan);
normExpRewardAnatPowMat = Make2DPlotMat(normExpRewardAnatPowMat,chanMat,badchan);
normExpReturnAnatPowMat = Make2DPlotMat(normExpReturnAnatPowMat,chanMat,badchan);
normExpChoiceAnatPowmat = Make2DPlotMat(normExpChoiceAnatPowmat,chanMat,badchan);

zExpCenterAnatPowMat = Make2DPlotMat(zExpCenterAnatPowMat,chanMat,badchan);
zExpRewardAnatPowMat = Make2DPlotMat(zExpRewardAnatPowMat,chanMat,badchan);
zExpReturnAnatPowMat = Make2DPlotMat(zExpReturnAnatPowMat,chanMat,badchan);
zExpChoiceAnatPowmat = Make2DPlotMat(zExpChoiceAnatPowmat,chanMat,badchan);


% control calculations
controlReturnAnatPowMat = mean(controlReturnarmPowMat,1);
controlCenterAnatPowMat = mean(controlCenterarmPowMat,1);
controlRewardAnatPowMat = mean(controlChoicearmPowMat,1);
controlChoiceAnatPowmat = mean(controlChoicepointPowMat,1);
        
controlAvePowPerTrial = mean(cat(3,controlReturnarmPowMat, controlCenterarmPowMat, controlChoicearmPowMat, controlChoicepointPowMat),3);
controlAvePowPerChan = mean(controlAvePowPerTrial,1);
sdControlPowerPerChan = mean([std(controlReturnarmPowMat,1); std(controlCenterarmPowMat,1); std(controlChoicearmPowMat,1); std(controlChoicepointPowMat,1)],1);

sdControlCenterAnatPowMat = std(controlCenterarmPowMat,1);
sdControlRewardAnatPowMat = std(controlChoicearmPowMat,1);
sdControlReturnAnatPowMat = std(controlReturnarmPowMat,1);
sdControlChoiceAnatPowMat = std(controlChoicepointPowMat,1);

if dbscale
    normControlCenterAnatPowMat = controlCenterAnatPowMat - controlAvePowPerChan;
    normControlRewardAnatPowMat = controlRewardAnatPowMat - controlAvePowPerChan;
    normControlReturnAnatPowMat = controlReturnAnatPowMat - controlAvePowPerChan;
    normControlChoiceAnatPowmat = controlChoiceAnatPowmat - controlAvePowPerChan;
else
    normControlCenterAnatPowMat = controlCenterAnatPowMat ./ controlAvePowPerChan;
    normControlRewardAnatPowMat = controlRewardAnatPowMat ./ controlAvePowPerChan;
    normControlReturnAnatPowMat = controlReturnAnatPowMat ./ controlAvePowPerChan;
    normControlChoiceAnatPowmat = controlChoiceAnatPowmat ./ controlAvePowPerChan;    
end

zControlCenterAnatPowMat = (controlCenterAnatPowMat - controlAvePowPerChan)./sdControlPowerPerChan;
zControlRewardAnatPowMat = (controlRewardAnatPowMat - controlAvePowPerChan)./sdControlPowerPerChan;
zControlReturnAnatPowMat = (controlReturnAnatPowMat - controlAvePowPerChan)./sdControlPowerPerChan;
zControlChoiceAnatPowmat = (controlChoiceAnatPowmat - controlAvePowPerChan)./sdControlPowerPerChan;

normControlCenterAnatPowMat = Make2DPlotMat(normControlCenterAnatPowMat,chanMat,badchan);
normControlRewardAnatPowMat = Make2DPlotMat(normControlRewardAnatPowMat,chanMat,badchan);
normControlReturnAnatPowMat = Make2DPlotMat(normControlReturnAnatPowMat,chanMat,badchan);
normControlChoiceAnatPowmat = Make2DPlotMat(normControlChoiceAnatPowmat,chanMat,badchan);

zControlCenterAnatPowMat = Make2DPlotMat(zControlCenterAnatPowMat,chanMat,badchan);
zControlRewardAnatPowMat = Make2DPlotMat(zControlRewardAnatPowMat,chanMat,badchan);
zControlReturnAnatPowMat = Make2DPlotMat(zControlReturnAnatPowMat,chanMat,badchan);
zControlChoiceAnatPowmat = Make2DPlotMat(zControlChoiceAnatPowmat,chanMat,badchan);

%calculate normByControl
if dbscale
    expNormControlCenterAnatPowMat = expCenterAnatPowMat - controlCenterAnatPowMat;
    expNormControlRewardAnatPowMat = expRewardAnatPowMat - controlRewardAnatPowMat;
    expNormControlReturnAnatPowMat = expReturnAnatPowMat - controlReturnAnatPowMat;
    expNormControlChoiceAnatPowmat = expChoiceAnatPowmat - controlChoiceAnatPowmat;
    
    sdExpNormContPowerPerChan = sdExpPowerPerChan - sdControlPowerPerChan;
    
    sdExpNormContCenterAnatPowMat = sdExpCenterAnatPowMat - sdControlCenterAnatPowMat;
    sdExpNormContRewardAnatPowMat = sdExpRewardAnatPowMat - sdControlRewardAnatPowMat;
    sdExpNormContReturnAnatPowMat = sdExpReturnAnatPowMat - sdControlReturnAnatPowMat;
    sdExpNormContChoiceAnatPowMat = sdExpChoiceAnatPowMat - sdControlChoiceAnatPowMat;
else
    expNormControlCenterAnatPowMat = expCenterAnatPowMat ./ controlCenterAnatPowMat;
    expNormControlRewardAnatPowMat = expRewardAnatPowMat ./ controlRewardAnatPowMat;
    expNormControlReturnAnatPowMat = expReturnAnatPowMat ./ controlReturnAnatPowMat;
    expNormControlChoiceAnatPowmat = expChoiceAnatPowmat ./ controlChoiceAnatPowmat;  
    
    sdExpNormContPowerPerChan = sdExpPowerPerChan ./ sdControlPowerPerChan;
    
    sdExpNormContCenterAnatPowMat = sdExpCenterAnatPowMat ./ sdControlCenterAnatPowMat;
    sdExpNormContRewardAnatPowMat = sdExpRewardAnatPowMat ./ sdControlRewardAnatPowMat;
    sdExpNormContReturnAnatPowMat = sdExpReturnAnatPowMat ./ sdControlReturnAnatPowMat;
    sdExpNormContChoiceAnatPowMat = sdExpChoiceAnatPowMat ./ sdControlChoiceAnatPowMat;

end

expNormControlCenterAnatPowMat = Make2DPlotMat(expNormControlCenterAnatPowMat,chanMat,badchan);
expNormControlRewardAnatPowMat = Make2DPlotMat(expNormControlRewardAnatPowMat,chanMat,badchan);
expNormControlReturnAnatPowMat = Make2DPlotMat(expNormControlReturnAnatPowMat,chanMat,badchan);
expNormBYControlChoiceAnatPowmat = Make2DPlotMat(expNormControlChoiceAnatPowmat,chanMat,badchan);

sdExpNormContCenterAnatPowMat = Make2DPlotMat(sdExpNormContCenterAnatPowMat,chanMat,badchan);
sdExpNormContRewardAnatPowMat = Make2DPlotMat(sdExpNormContRewardAnatPowMat,chanMat,badchan);
sdExpNormContReturnAnatPowMat = Make2DPlotMat(sdExpNormContReturnAnatPowMat,chanMat,badchan);
sdExpNormContChoiceAnatPowMat = Make2DPlotMat(sdExpNormContChoiceAnatPowMat,chanMat,badchan);

sdExpNormContPowerPerChan = Make2DPlotMat(sdExpNormContPowerPerChan,chanMat,badchan);

% calculate t-tests
[m n] = size(expCenterarmPowMat);

hCenterAnatPowMat = NaN*zeros(n);
hRewardAnatPowMat = NaN*zeros(n);
hReturnAnatPowMat = NaN*zeros(n);
hChoiceAnatPowmat = NaN*zeros(n);

pCenterAnatPowMat = NaN*zeros(n);
pRewardAnatPowMat = NaN*zeros(n);
pReturnAnatPowMat = NaN*zeros(n);
pChoiceAnatPowmat = NaN*zeros(n);

for i = 1:n
    [hCenterAnatPowMat(i), pCenterAnatPowMat(i)] = ttest(expCenterarmPowMat(:,i),mean(controlCenterarmPowMat(:,i)),alpha,'both');
    [hRewardAnatPowMat(i), pRewardAnatPowMat(i)] = ttest(expChoicearmPowMat(:,i),mean(controlChoicearmPowMat(:,i)),alpha,'both');
    [hReturnAnatPowMat(i), pReturnAnatPowMat(i)] = ttest(expReturnarmPowMat(:,i),mean(controlReturnarmPowMat(:,i)),alpha,'both');
    [hChoiceAnatPowmat(i), pChoiceAnatPowmat(i)] = ttest(expChoicepointPowMat(:,i),mean(controlChoicepointPowMat(:,i)),alpha,'both');
end
pCenterAnatPowMat = log10(pCenterAnatPowMat);
pRewardAnatPowMat = log10(pRewardAnatPowMat);
pReturnAnatPowMat = log10(pReturnAnatPowMat);
pChoiceAnatPowmat = log10(pChoiceAnatPowmat);

hCenterAnatPowMat = Make2DPlotMat(hCenterAnatPowMat,chanMat,badchan);
hRewardAnatPowMat = Make2DPlotMat(hRewardAnatPowMat,chanMat,badchan);
hReturnAnatPowMat = Make2DPlotMat(hReturnAnatPowMat,chanMat,badchan);
hChoiceAnatPowmat = Make2DPlotMat(hChoiceAnatPowmat,chanMat,badchan);

pCenterAnatPowMat = Make2DPlotMat(pCenterAnatPowMat,chanMat,badchan);
pRewardAnatPowMat = Make2DPlotMat(pRewardAnatPowMat,chanMat,badchan);
pReturnAnatPowMat = Make2DPlotMat(pReturnAnatPowMat,chanMat,badchan);
pChoiceAnatPowmat = Make2DPlotMat(pChoiceAnatPowmat,chanMat,badchan);


figureMats = {{normExpReturnAnatPowMat,'normExp Return'},{normExpChoiceAnatPowmat,'normExp Choice'};...
    {normExpCenterAnatPowMat,'normExp Center'},{normExpRewardAnatPowMat,'normExp Reward'}};
[colorLimits, figureNum] = nimagesc(figureMats,1,[],1);

figureMats = {{normControlReturnAnatPowMat,'normControl Return'},{normControlChoiceAnatPowmat,'normControl Choice'};...
    {normControlCenterAnatPowMat,'normControl Center'},{normControlRewardAnatPowMat,'normControl Reward'}};
nimagesc(figureMats,1,colorLimits,2);

figureMats = {{zExpReturnAnatPowMat,'zExp Return'},{zExpChoiceAnatPowmat,'zExp Choice'};...
    {zExpCenterAnatPowMat,'zExp Center'},{zExpRewardAnatPowMat,'zExp Reward'}};
[colorLimits, figureNum] = nimagesc(figureMats,1,[],3);

figureMats = {{zControlReturnAnatPowMat,'zControl Return'},{zControlChoiceAnatPowmat,'zControl Choice'};...
    {zControlCenterAnatPowMat,'zControl Center'},{zControlRewardAnatPowMat,'zControl Reward'}};
nimagesc(figureMats,1,colorLimits,4);

figureMats = {{expNormControlReturnAnatPowMat,'expNormControl Return'},{expNormBYControlChoiceAnatPowmat, 'expNormControl Choice'};...
    {expNormControlCenterAnatPowMat, 'expNormControl Center'},{expNormControlRewardAnatPowMat, 'expNormControl Reward'}};
nimagesc(figureMats,1,[],5);

figureMats = {{sdExpNormContReturnAnatPowMat,'sdExpNormCont Return'},{sdExpNormContChoiceAnatPowMat,'sdExpNormCont Choice'};...
    {sdExpNormContCenterAnatPowMat,'sdExpNormCont Center'},{sdExpNormContRewardAnatPowMat,'sdExpNormCont Reward'}};
nimagesc(figureMats,1,[],6);

figureMats = {{sdExpNormContPowerPerChan,'sdExpNormCont'}};
nimagesc(figureMats,1,[],7);

figureMats = {{hReturnAnatPowMat,'h return'},{hChoiceAnatPowmat,'h choice'};...
    {hCenterAnatPowMat,'h center'},{hRewardAnatPowMat,'h reward'}};
nimagesc(figureMats,1,[-1 1],8);

figureMats = {{pReturnAnatPowMat,'p return'},{pChoiceAnatPowmat,'p choice'};...
    {pCenterAnatPowMat,'p center'},{pRewardAnatPowMat,'p reward'}};
nimagesc(figureMats,1,[-9 -1],9);

return

figureMats = {{,' Return'},{,' Choice'};...
    {,' Center'},{,' Reward'}};
nimagesc(figureMats,1,[]);


keyboard
outputMatCell = Make2DPlotMat(expCenterarmPowMat,chanMat,badchan);

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

figureMats = {{,' Return'},{,' Choice'};...
    {,' Center'},{,' Reward'}};
nimagesc(figureMats,1,[]);


