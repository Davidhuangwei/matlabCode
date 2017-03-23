function FixRunningInfoStructBat(mfilename,description,fileBaseCell,fileExt,nChan,wavParam,winLength,midPointsBool,...
    thetaFreqRange,gammaFreqRange,varargin)
[trialTypesBool,excludeLocations,minSpeed,maxNTimes,batchModeBool] = ...
    DefaultArgs(varargin,{[1 1 1 1 1 1 1 1 1 1 1 1 0],[1 1 1 0 0 0 0 0 0],0,NaN,1});
   
currDir = pwd;

if midPointsBool
    midPtext = '_MidPoints';
else
    midPtext = [];
end

saveDir = [mfilename '_' description midPtext '_MinSpeed' num2str(minSpeed)...
    'wavParam' num2str(wavParam) 'Win' num2str(winLength) fileExt];

mother = 'MORLET'; % do not change... not sure how coherence calc depends on this parameter
if wavParam~=6% do not change... not sure how coherence calc depends on this parameter
    ERROR_WAVPARAM_MUST_BE_6
end

N = winLength;
DJ = 1/18;
S0 = 4;
J1 = round(log2(N/S0)/(DJ)-1.3/DJ);
dt = 1;
pad = 1;

eegSamp = 1250;
bps = 2;
lags = [-1500:50:1500];
whlSamp = 39.065;
selChansStruct = LoadVar(['ChanInfo/SelChan' fileExt '.mat']);

infoStruct = [];
infoStruct = setfield(infoStruct,'nChan',nChan);
infoStruct = setfield(infoStruct,'winLength',winLength);
infoStruct = setfield(infoStruct,'wavParam',wavParam);
% infoStruct = setfield(infoStruct,'maxNTimes',maxNTimes);
infoStruct = setfield(infoStruct,'minSpeed',minSpeed);
infoStruct = setfield(infoStruct,'midPointsBool',midPointsBool);
infoStruct = setfield(infoStruct,'trialTypesBool',trialTypesBool);
infoStruct = setfield(infoStruct,'excludeLocations',excludeLocations);
infoStruct = setfield(infoStruct,'fileExt',fileExt);
infoStruct = setfield(infoStruct,'thetaFreqRange',thetaFreqRange);
infoStruct = setfield(infoStruct,'gammaFreqRange',gammaFreqRange);
infoStruct = setfield(infoStruct,'description',description);
infoStruct = setfield(infoStruct,'saveDir',saveDir);

infoStruct = setfield(infoStruct,'winLength',winLength);
infoStruct = setfield(infoStruct,'whlSamp',whlSamp);
infoStruct = setfield(infoStruct,'eegSamp',eegSamp);
infoStruct = setfield(infoStruct,'lags',lags);
infoStruct = setfield(infoStruct,'fileExt',fileExt);
infoStruct = setfield(infoStruct,'saveDir',saveDir);


infoStruct = setfield(infoStruct,'nChan',nChan);
infoStruct = setfield(infoStruct,'whlSamp',whlSamp);
infoStruct = setfield(infoStruct,'eegSamp',eegSamp);
infoStruct = setfield(infoStruct,'minSpeed',minSpeed);
infoStruct = setfield(infoStruct,'winLength',winLength);
infoStruct = setfield(infoStruct,'midPointsBool',midPointsBool);
infoStruct = setfield(infoStruct,'trialTypesBool',trialTypesBool);
infoStruct = setfield(infoStruct,'excludeLocations',excludeLocations);
infoStruct = setfield(infoStruct,'fileExt',fileExt);
% infoStruct = setfield(infoStruct,'maxNTimes',maxNTimes);
infoStruct = setfield(infoStruct,'saveDir',saveDir);


infoStruct = setfield(infoStruct,'nChan',nChan);
infoStruct = setfield(infoStruct,'winLength',winLength);
infoStruct = setfield(infoStruct,'mother',mother);
infoStruct = setfield(infoStruct,'wavParam',wavParam);
infoStruct = setfield(infoStruct,'S0',S0);
infoStruct = setfield(infoStruct,'DJ',DJ);
infoStruct = setfield(infoStruct,'J1',J1);
infoStruct = setfield(infoStruct,'dt',dt);
infoStruct = setfield(infoStruct,'pad',pad);
infoStruct = setfield(infoStruct,'eegSamp',eegSamp);
infoStruct = setfield(infoStruct,'fileExt',fileExt);
infoStruct = setfield(infoStruct,'selChan',selChansStruct);
infoStruct = setfield(infoStruct,'saveDir',saveDir);

for j=1:length(fileBaseCell)
    fileBase = fileBaseCell{j};
    infoStruct = setfield(infoStruct,'fileBase',fileBase);

    dirName = [fileBase '/' saveDir '/'];
    
    if exist([dirName '/infoStruct.mat'],'file')
        infoStruct = MergeStructs(LoadVar([dirName '/infoStruct.mat']),infoStruct);
    end
    fprintf('Saving: %s\n',[dirName '/infoStruct.mat'])
    save([dirName '/infoStruct.mat'],SaveAsV6,'infoStruct');
end
    return
    %rem
      infoStruct = [];
infoStruct = setfield(infoStruct,'nChan',nChan);
infoStruct = setfield(infoStruct,'winLength',winLength);
infoStruct = setfield(infoStruct,'wavParam',wavParam);
infoStruct = setfield(infoStruct,'maxNTimes',maxNTimes);
infoStruct = setfield(infoStruct,'fileExt',fileExt);
infoStruct = setfield(infoStruct,'thetaFreqRange',thetaFreqRange);
infoStruct = setfield(infoStruct,'gammaFreqRange',gammaFreqRange);
infoStruct = setfield(infoStruct,'description',description);
infoStruct = setfield(infoStruct,mfilename,mfilename);
infoStruct = setfield(infoStruct,'saveDir',saveDir);

 infoStruct = setfield(infoStruct,'eegSamp',eegSamp);
    infoStruct = setfield(infoStruct,'winLength',winLength);
    infoStruct = setfield(infoStruct,'fileExt',fileExt);
    infoStruct = setfield(infoStruct,'maxNTimes',maxNTimes);
    infoStruct = setfield(infoStruct,mfilename,mfilename);
    infoStruct = setfield(infoStruct,'saveDir',saveDir);
            
 
    infoStruct = [];
    infoStruct = setfield(infoStruct,'nChan',nChan);
    infoStruct = setfield(infoStruct,'winLength',winLength);
    infoStruct = setfield(infoStruct,'mother',mother);
    infoStruct = setfield(infoStruct,'wavParam',wavParam);
    infoStruct = setfield(infoStruct,'S0',S0);
    infoStruct = setfield(infoStruct,'DJ',DJ);
    infoStruct = setfield(infoStruct,'J1',J1);
    infoStruct = setfield(infoStruct,'dt',dt);
    infoStruct = setfield(infoStruct,'pad',pad);
    infoStruct = setfield(infoStruct,'eegSamp',eegSamp);
    infoStruct = setfield(infoStruct,'fileExt',fileExt);
    infoStruct = setfield(infoStruct,mfilename,mfilename);
    infoStruct = setfield(infoStruct,'selChan',selChansStruct);
    infoStruct = setfield(infoStruct,'saveDir',saveDir);

    infoStruct = [];
infoStruct = setfield(infoStruct,'fileExt',fileExt);
infoStruct = setfield(infoStruct,mfilename,mfilename);
infoStruct = setfield(infoStruct,'saveDir',saveDir);
