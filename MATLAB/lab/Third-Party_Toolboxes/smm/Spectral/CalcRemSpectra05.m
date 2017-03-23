% function CalcRemSpectra05(description,fileBaseCell,fileExt,nChan,wavParam,winLength,thetaFreqRange,gammaFreqRange,varargin)
% [maxNTimes,batchModeBool] = ...
%     DefaultArgs(varargin,{NaN,1});
% 

function CalcRemSpectra05(description,fileBaseCell,fileExt,nChan,wavParam,winLength,thetaFreqRange,gammaFreqRange,varargin)
[maxNTimes,batchModeBool] = DefaultArgs(varargin,{NaN,1});


currDir = pwd;

saveDir = [mfilename '_' description '_wavParam' num2str(wavParam) 'Win' num2str(winLength) fileExt];

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

for j=1:length(fileBaseCell)
    try
        c1 = clock;

        figure(j)
        clf
        fileBase = fileBaseCell{j};
        infoStruct = setfield(infoStruct,'fileBase',fileBase);

        if ~exist([fileBase '/' saveDir],'dir')
            mkdir([fileBase '/' saveDir])
        end

        save([fileBase '/' saveDir '/infoStruct.mat'],SaveAsV6,'infoStruct');

        CalcRemSpectraTime01(saveDir,fileBaseCell(j),fileExt,winLength,maxNTimes,batchModeBool)

        subPlotHandles = CalcWaveletSpectra01(saveDir,fileBaseCell(j),fileExt,nChan,winLength,wavParam,...
            [],1,{gcf},[],batchModeBool);

        CalcThetaFreq03(saveDir,fileBaseCell(j),fileExt,thetaFreqRange,...
            [],1,{gcf},subPlotHandles{1},batchModeBool)

        CalcThetaGammaRange01(saveDir,fileBaseCell(j),fileExt,thetaFreqRange,gammaFreqRange)

        c2 = clock-c1;
        disp(num2str(c2))
        cd(currDir)
    catch
        errorText = ['ERROR:  ' date '  ' mfilename '  call=('...
            saveDir  '\n'];
        ReportError(errorText,~batchModeBool)
        cd(currDir)
    end
end

cd(currDir)
