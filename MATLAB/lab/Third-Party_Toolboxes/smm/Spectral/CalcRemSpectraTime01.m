% function CalcRemSpectraTime01(saveDir,fileBaseCell,fileExt,winLength,varargin)
% [maxNTimes,batchModeBool] = ...
%     DefaultArgs(varargin,{NaN,1});
function CalcRemSpectraTime01(saveDir,fileBaseCell,fileExt,winLength,varargin)
[maxNTimes,batchModeBool] = ...
    DefaultArgs(varargin,{NaN,1});

% try
    currDir = pwd;
    eegSamp = 1250;
    infoStruct = [];
    infoStruct = setfield(infoStruct,'eegSamp',eegSamp);
    infoStruct = setfield(infoStruct,'winLength',winLength);
    infoStruct = setfield(infoStruct,'fileExt',fileExt);
    infoStruct = setfield(infoStruct,'maxNTimes',maxNTimes);
    infoStruct = setfield(infoStruct,mfilename,mfilename);
    infoStruct = setfield(infoStruct,'saveDir',saveDir);
    
    for j=1:length(fileBaseCell)
%         try
            fileBase = fileBaseCell{j};
           cd(currDir)
            cd(fileBase);
            infoStruct = setfield(infoStruct,'fileBase',fileBase);
            
            if exist([saveDir '/infoStruct.mat'],'file')
                infoStruct = MergeStructs(LoadVar([saveDir '/infoStruct.mat']),infoStruct);
            end

            fprintf('Processing: %s; %s%s\n',mfilename,fileBase,fileExt);
             
            time = [];
            eegSegTime = [];
            
            remTimes = LoadVar('RemTimes.mat');
            for k=1:size(remTimes,1)
                eegSegTime = [eegSegTime; remTimes(k,1)*eegSamp:winLength:remTimes(k,2)*eegSamp-winLength];
            end

            %              try
            if ~isempty(eegSegTime)
                allEegSegTime = eegSegTime;
                if ~isnan(maxNTimes) & (length(eegSegTime) > maxNTimes)
                    keptTime = logical(zeros(size(eegSegTime)));
                    keptTime(randsample(length(eegSegTime),maxNTimes)) = 1;
                    eegSegTime = eegSegTime(keptTime);
                else
                    keptTime = logical(ones(size(eegSegTime)));
                end

                time = (eegSegTime+winLength/2)/eegSamp; % in seconds at middle of eegSeg
            end
%             catch
%                 errorText = ['WARNING:  ' date '  ' mfilename '  call=('...
%                     saveDir '\n'];
%                 ReportError(errorText,~batchModeBool)
%             end

            fprintf('Saving: %s, %i trials\n',saveDir,length(time))
            
            if ~exist(saveDir,'dir')
                mkdir(saveDir)
            end

            save([saveDir '/infoStruct.mat'],SaveAsV6,'infoStruct');
            save([saveDir '/time.mat'],SaveAsV6,'time');
            save([saveDir '/eegSegTime.mat'],SaveAsV6,'eegSegTime');
            save([saveDir '/allEegSegTime.mat'],SaveAsV6,'allEegSegTime');
            save([saveDir '/keptTime.mat'],SaveAsV6,'keptTime');

            cd(currDir)
            
%         catch
%             errorText = ['ERROR:  ' date '  ' mfilename '  call=('...
%                 saveDir  '\n'];
%             ReportError(errorText,~batchModeBool)
%             cd(currDir)
%         end
    end
% catch
%     errorText = ['ERROR:  ' date '  ' mfilename '  saveDir=('...
%         saveDir '\n'];
%     ReportError(errorText,~batchModeBool)
% end
cd(currDir)
return

