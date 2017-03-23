% function CalcRunningSpectra12c(description,fileBaseCell,fileExt,nChan,winLength,midPointsBool,thetaFreqRange,gammaFreqRange,varargin)
% funcs2run = {...
%     'CalcRunningSpectraTime01',...
%     'CalcRunningSpectraBehav01',...
%     'CalcWaveletSpectra01',...
%     'CalcThetaFreq03',...
%     'CalcThetaGammaRange01',...
%     }
% [funcs2run,trialTypesBool,excludeLocations,minSpeed,maxNTimes,batchModeBool] = ...
%     DefaultArgs(varargin,{funcs2run,[1 1 1 1 1 1 1 1 1 1 1 1 0],[1 1 1 0 0 0 0 0 0],0,NaN,1});
function CalcRunningSpectra15(description,fileBaseCell,fileExt,nChan,wavParam,winLength,midPointsBool,thetaFreqRange,gammaFreqRange,varargin)
funcs2run = {...
    'CalcRunningSpectraTime02',...
    'CalcRunningSpectraBehav01',...
    'CalcWaveletSpectra01',...
    'CalcThetaFreq03',...
    'CalcThetaGammaRange01',...
    };
[funcs2run,trialTypesBool,excludeLocations,minSpeed,maxNTimes,batchModeBool,overwriteSpecBool] = ...
    DefaultArgs(varargin,{funcs2run,[1 1 1 1 1 1 1 1 1 1 1 1 0],[1 1 1 0 0 0 0 0 0],0,NaN,1,0});

currDir = pwd;

if midPointsBool
    midPtext = '_MidPoints';
else
    midPtext = [];
end

saveDir = [mfilename '_' description midPtext '_MinSpeed' num2str(minSpeed)...
    'wavParam' num2str(wavParam) 'Win' num2str(winLength) fileExt];

infoStruct = [];
infoStruct = setfield(infoStruct,'nChan',nChan);
infoStruct = setfield(infoStruct,'winLength',winLength);
infoStruct = setfield(infoStruct,'wavParam',wavParam);
infoStruct = setfield(infoStruct,'maxNTimes',maxNTimes);
infoStruct = setfield(infoStruct,'minSpeed',minSpeed);
infoStruct = setfield(infoStruct,'midPointsBool',midPointsBool);
infoStruct = setfield(infoStruct,'trialTypesBool',trialTypesBool);
infoStruct = setfield(infoStruct,'excludeLocations',excludeLocations);
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
        
        for k=1:length(funcs2run)
            pwd
            switch funcs2run{k}
                case 'CalcSpectraTime01'
                    CalcSpectraTime01(saveDir,fileBaseCell(j),fileExt,winLength,'.sts.RUN',maxNTimes,batchModeBool)
                case 'CalcRunningSpectraTime02'
                    CalcRunningSpectraTime02(saveDir,fileBaseCell(j),fileExt,nChan,winLength,midPointsBool,...
                        trialTypesBool,excludeLocations,minSpeed,maxNTimes,1,{gcf},[],batchModeBool)
                case 'CalcRunningSpectraSpeedAccel02'
                    CalcRunningSpectraSpeedAccel02(saveDir,fileBaseCell(j),fileExt,winLength,...
                        [],1,{gcf},[],batchModeBool)
                case 'CalcRunningSpectraBehav01'
                    CalcRunningSpectraBehav01(saveDir,fileBaseCell(j),fileExt,winLength,...
                        [],1,{gcf},[],batchModeBool)
                case 'CalcWaveletSpectra02'
                    subPlotHandles = CalcWaveletSpectra02(saveDir,fileBaseCell(j),fileExt,nChan,winLength,wavParam,...
                        [],1,{gcf},[],batchModeBool,overwriteSpecBool);
                case 'CalcThetaFreq03'
                    CalcThetaFreq03(saveDir,fileBaseCell(j),fileExt,thetaFreqRange,...
                        [],1,{gcf},subPlotHandles{1},batchModeBool)
                case 'CalcThetaGammaRange01'
                    CalcThetaGammaRange01(saveDir,fileBaseCell(j),fileExt,thetaFreqRange,gammaFreqRange)
                otherwise
                    fprintf('\nFunction %s unknown\n',funcs2run{k})
            end
        end
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
