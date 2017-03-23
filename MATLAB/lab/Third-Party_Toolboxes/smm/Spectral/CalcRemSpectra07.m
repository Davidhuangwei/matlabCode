% function CalcRemSpectra06(description,fileBaseCell,fileExt,nChan,wavParam,winLength,...
%     thetaFreqRange,gammaFreqRange,funcs2run,varargin)
% [maxNTimes,batchModeBool,overwriteSpecBool] = DefaultArgs(varargin,{NaN,1,0});
% tag:rem
% tag:spectral

function CalcRemSpectra06(description,fileBaseCell,fileExt,nChan,wavParam,winLength,...
    thetaFreqRange,gammaFreqRange,funcs2run,varargin)
[maxNTimes,batchModeBool,overwriteSpecBool,calcCohBool] = DefaultArgs(varargin,{NaN,1,0,1});
disp(funcs2run')
currDir = pwd;

saveDir = [description '_wavParam' num2str(wavParam) 'Win' num2str(winLength) fileExt];

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
%     try
        c1 = clock;

        figure(j)
        clf
        fileBase = fileBaseCell{j};
        infoStruct = setfield(infoStruct,'fileBase',fileBase);

        if ~exist([fileBase '/' saveDir],'dir')
            mkdir([fileBase '/' saveDir])
        end
try
        dirName = [fileBase '/' saveDir '/'];
        if exist([dirName '/infoStruct.mat'],'file')
            infoStruct = MergeStructs(LoadVar([dirName '/infoStruct.mat']),infoStruct,1);
        end
catch
    keyboard
end
        save([fileBase '/' saveDir '/infoStruct.mat'],SaveAsV6,'infoStruct');
        
        subPlotHandles = {[]};
        for k=1:length(funcs2run)
            switch funcs2run{k}
                case 'CalcSpectraTime01'
                    CalcSpectraTime01(saveDir,fileBaseCell(j),fileExt,winLength,'.sts.REM',maxNTimes,batchModeBool)
                case 'CalcWaveletSpectra03'
                    subPlotHandles = CalcWaveletSpectra03(saveDir,fileBaseCell(j),fileExt,nChan,winLength,wavParam,...
                        [],calcCohBool,1,{gcf},[],batchModeBool,overwriteSpecBool);
                case 'CalcThetaFreq03'
                    CalcThetaFreq03(saveDir,fileBaseCell(j),fileExt,thetaFreqRange,...
                        [],1,{gcf},subPlotHandles{1},batchModeBool)
                case 'CalcThetaGammaRange01'
                    CalcThetaGammaRange01(saveDir,fileBaseCell(j),fileExt,thetaFreqRange,gammaFreqRange)
                case  'CalcThetaPowCohLMPeak01'
                    CalcThetaPowCohLMPeak01(saveDir,fileBaseCell(j),fileExt,thetaFreqRange);
                    
                otherwise
                    fprintf('\nFunction %s unknown\n',funcs2run{k})
            end
        end

        c2 = clock-c1;
        disp(num2str(c2))
        cd(currDir)
%     catch
%         errorText = ['ERROR:  ' date '  ' mfilename '  call=('...
%             saveDir  '\n'];
%         ReportError(errorText,~batchModeBool)
%         cd(currDir)
%     end
end

cd(currDir)
