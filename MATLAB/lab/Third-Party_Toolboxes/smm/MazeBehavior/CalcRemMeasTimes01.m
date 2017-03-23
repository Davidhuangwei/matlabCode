function CalcRemMeasTimes01(spectAnalName,description,fileBaseCell,fileExt,nChan,winLength,wavParam,varargin)
%function CalcRemMeasTimes01(description,fileBaseCell,fileExt,nChan,winLength,thetaFreqRange,gammaFreqRange,varargin)
%[selectedChannels] = ...
%    DefaultArgs(varargin,{load(['SelectedChannels' fileExt '.txt'])});
chanInfoDir = 'ChanInfo/';
[selChansStruct,batchModeBool] = ...
    DefaultArgs(varargin,{LoadVar([chanInfoDir 'SelChan' fileExt '.mat']),1});

try
    anatFields = fieldnames(selChansStruct);
    for j=1:length(anatFields)
        selectedChannels(j) = selChansStruct.(anatFields{j});
    end
    for k=1:length(selectedChannels)
        selChanNames{k} = ['ch' num2str(selectedChannels(k))];
    end

    saveDir = [spectAnalName '_' description '_Win' num2str(winLength) 'wavParam' num2str(wavParam) fileExt];
%saveDir = [mfilename '_' description '_Win' num2str(winLength) fileExt];
    currDir = pwd;
    %addpath /u12/antsiro/matlab/General
    addpath ~/matlab/sm_Copies

    %%%% parameters optimized for winLength = 626 %%%%
 
    eegSamp = 1250;
    bps = 2;

    %yoFreqRange = [0 500];

    infoStruct = [];
    infoStruct = setfield(infoStruct,'wavParam',wavParam);
    infoStruct = setfield(infoStruct,'nChan',nChan);
    infoStruct = setfield(infoStruct,'winLength',winLength);
    infoStruct = setfield(infoStruct,'eegSamp',eegSamp);
    infoStruct = setfield(infoStruct,'fileExt',fileExt);
    infoStruct = setfield(infoStruct,'description',description);
    infoStruct = setfield(infoStruct,'program',mfilename);

    for j=1:length(fileBaseCell)
        try
            c1 = clock;
            fileBase = fileBaseCell{j};
            infoStruct = setfield(infoStruct,'fileBase',fileBase);
            fprintf('Processing: %s%s\n',fileBase,fileExt);
            cd(currDir)
            eval(['cd ' fileBase]);

            figure;
            subplot(2,2,1);
            hold on;

            time = [];
            taskType = {};
            eegSegTime = [];
            %     trialType = []; % for similarity to maze analysis
            %     mazeLocation = []; % for similarity to maze analysis
            %
            if exist([saveDir '/eegSegTime.mat'],'file')
                fprintf('Loading: %s/eegSegTime.mat\n',saveDir)
                to = LoadVar([saveDir '/eegSegTime.mat']);
            else
                remTimes = LoadVar('RemTimes.mat');
                to = [];
                %to = remTimes(1,1)*eegSamp:winLength:remTimes(1,1)*eegSamp+winLength;
                for k=1:size(remTimes,1)
                    to = [to remTimes(k,1)*eegSamp:winLength:remTimes(k,2)*eegSamp-winLength];
                end
            end
            try
                if ~isempty(to)
                    for i=1:length(to)
                        
                        time = cat(1, time, (to(i)+winLength/2)/eegSamp); % in seconds
                        taskType = cat(1,taskType,{'REM'});
                        eegSegTime = cat(1,eegSegTime,to(i));

                    end
                    size(time)
                end
            catch
                errorText = ['WARNING:  ' date '  ' mfilename '  call=('...
                    description ',' fileBase ',' fileExt ',' num2str(nChan) ',' ...
                    num2str(winLength) ')\n'];
                ReportError(errorText,~batchModeBool)
            end

            if ~exist(saveDir,'dir')
                eval(['mkdir ' saveDir])
            end
            infoStruct = setfield(infoStruct,'saveDir',saveDir);
            fprintf('Saving: %s\n',saveDir)
            set(gcf,'name',[fileBase ': ' saveDir]);

            save([saveDir '/infoStruct.mat'],SaveAsV6,'infoStruct');
            save([saveDir '/time.mat'],SaveAsV6,'time');
            save([saveDir '/eegSegTime.mat'],SaveAsV6,'eegSegTime');
            save([saveDir '/taskType.mat'],SaveAsV6,'taskType');
            c2 = clock-c1;
            disp(num2str(c2))
            cd(currDir)
        catch
            errorText = ['ERROR:  ' date '  ' mfilename '  call=('...
                description ',' fileBase ',' fileExt ',' num2str(nChan) ',' ...
                num2str(winLength) ')\n'];
            ReportError(errorText,~batchModeBool)
            cd(currDir)
        end
    end
catch
    errorText = ['ERROR:  ' date '  ' mfilename '  call=('...
        description ',' fileExt ',' num2str(nChan) ',' ...
        num2str(winLength) ')\n'];
    ReportError(errorText,~batchModeBool)
end
return

