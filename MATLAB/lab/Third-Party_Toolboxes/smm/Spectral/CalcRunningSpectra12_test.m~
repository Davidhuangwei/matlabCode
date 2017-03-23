% function CalcRunningSpectra12c(description,fileBaseCell,fileExt,nChan,winLength,midPointsBool,thetaFreqRange,gammaFreqRange,varargin)
% chanInfoDir = 'ChanInfo/';
% [trialTypesBool,excludeLocations,minSpeed,selChansStruct,batchModeBool] = ...
%     DefaultArgs(varargin,{[1 1 1 1 1 1 1 1 1 1 1 1 0],[1 1 1 0 0 0 0 0 0],0,LoadVar([chanInfoDir 'SelChan' fileExt '.mat']),1});
function CalcRunningSpectra12_test(description,fileBaseCell,fileExt,nChan,winLength,midPointsBool,thetaFreqRange,gammaFreqRange,varargin)
chanInfoDir = 'ChanInfo/';
[trialTypesBool,excludeLocations,minSpeed,selChansStruct,batchModeBool] = ...
    DefaultArgs(varargin,{[1 1 1 1 1 1 1 1 1 1 1 1 0],[1 1 1 0 0 0 0 0 0],0,LoadVar([chanInfoDir 'SelChan' fileExt '.mat']),1});

wavParam = 6; % do not change... not sure how coherence calc depends on this parameter
try

    selChanNames = fieldnames(selChansStruct);
    for j=1:length(selChanNames)
        selectedChannels(j) = selChansStruct.(selChanNames{j});
    end

    if midPointsBool
        midPtext = '_MidPoints';
    else
        midPtext = [];
    end

    saveDir = [mfilename '_' description midPtext '_MinSpeed' num2str(minSpeed)...
        'wavParam' num2str(wavParam) 'Win' num2str(winLength) fileExt];
    currDir = pwd;

    %addpath /u12/antsiro/matlab/General
    addpath ~/matlab/sm_Copies

    %%%% parameters optimized for winLength = 626 %%%%
    N = winLength;
    DJ = 1/18;
    S0 = 4;
    J1 = round(log2(N/S0)/(DJ)-1.3/DJ);

    lags = -1500:50:1500;
    whlSamp = 39.065;
    eegSamp = 1250;
    bps = 2;
    whlWinLen = winLength*whlSamp/eegSamp;
    hanFilter = hanning(floor(whlWinLen));

    %yoFreqRange = [0 500];

    infoStruct = [];
    infoStruct = setfield(infoStruct,'nChan',nChan);
    infoStruct = setfield(infoStruct,'winLength',winLength);
    infoStruct = setfield(infoStruct,'wavParam',wavParam);
    infoStruct = setfield(infoStruct,'S0',S0);
    infoStruct = setfield(infoStruct,'DJ',DJ);
    infoStruct = setfield(infoStruct,'J1',J1);
    infoStruct = setfield(infoStruct,'whlSamp',whlSamp);
    infoStruct = setfield(infoStruct,'eegSamp',eegSamp);
    infoStruct = setfield(infoStruct,'minSpeed',minSpeed);
    infoStruct = setfield(infoStruct,'lags',lags);
    infoStruct = setfield(infoStruct,'trialTypesBool',trialTypesBool);
    infoStruct = setfield(infoStruct,'excludeLocations',excludeLocations);
    infoStruct = setfield(infoStruct,'fileExt',fileExt);
    infoStruct = setfield(infoStruct,'thetaFreqRange',thetaFreqRange);
    infoStruct = setfield(infoStruct,'gammaFreqRange',gammaFreqRange);
    infoStruct = setfield(infoStruct,'description',description);
    infoStruct = setfield(infoStruct,'program',mfilename);
    infoStruct = setfield(infoStruct,'selChan',selChansStruct);

    %dayStruct = LoadVar('DayStruct.mat');

    for j=1:length(fileBaseCell)
        try
            c1 = clock;
            fileBase = fileBaseCell{j};
            infoStruct = setfield(infoStruct,'fileBase',fileBase);
            fprintf('Processing: %s%s\n',fileBase,fileExt);
            cd(currDir)
            cd(fileBase);

            figure;
            subplot(2,2,1);
            hold on;

            wavePow = [];
            waveXspec = [];
            waveCoh = [];
            wavePhase = [];
            thetaFreq = [];
            speed = [];
            accel = [];
            time = [];
            taskType = {};
            %day = {};
            trialType = [];
            mazeLocation = [];
            position = [];
            rawTrace = [];
            mazeLocName = {};
            eegSegTime = [];
            mazeLocNames = {};
            to = [];
count = 0;

            fileInfo = dir([fileBase fileExt]);
            numSamples = fileInfo.bytes/nChan/bps;

            drinking = LoadMazeTrialTypes(fileBase, [1 1 1 1 1 1 1 1 1 1 1 1 1],excludeLocations);
            whlData = LoadMazeTrialTypes(fileBase, trialTypesBool,[1 1 1 1 1 1 1 1 1]);
            plot(whlData(find(whlData(:,1)~=-1),1),whlData(find(whlData(:,1)~=-1),2),':y')
            [speedData accelData] = MazeSpeedAccel(whlData);
            firstWhlPoint = find(whlData(:,1)~=-1,1,'first');
            lastWhlPoint = find(whlData(:,1)~=-1,1,'last');

            if exist([saveDir '/eegSegTime.mat'],'file')
                fprintf('Loading: %s/eegSegTime.mat\n',saveDir)
                to = LoadVar([saveDir '/eegSegTime.mat']);
                if midPointsBool
                    mazeLocNames = LoadVar([saveDir '/mazeLocName.mat']);
                end
            else
                if midPointsBool
                    trialMidsStruct = CalcFileMidPoints02(fileBase,0,trialTypesBool);
                    mazeRegionNames = fieldnames(getfield(trialMidsStruct,fileBase));
                    to = [];
                    mazeLocNames = {};
                    for i=1:size(mazeRegionNames,1)
                        to = [to; getfield(trialMidsStruct,fileBase,mazeRegionNames{i})'];
                        mazeLocNames = cat(2,mazeLocNames,repmat(mazeRegionNames(i),...
                            size(getfield(trialMidsStruct,fileBase,mazeRegionNames{i})')));
                    end
                    [to ind] = sort(to);
                    to = round((to-1)*eegSamp/whlSamp-winLength/2); % in eeg samples starting with 0
                    mazeLocNames = mazeLocNames(ind);
                else
                    to = [0:winLength:numSamples-winLength]'; % in in eeg samples starting with 0
                    %to = [0:winLength:winLength]'; % in in eeg samples starting with 0
                end
            end
            try
                if ~isempty(to)
                    for i=1:length(to)
                        whlIndexStart = round(to(i)*whlSamp/eegSamp+1); % in whl samples starting with 1
                        whlIndexEnd = min(size(whlData,1),whlIndexStart+size(hanFilter,1)-1);
                        % if:
                        % we calculated midpoints or:
                        % he's not in the excluded areas and
                        % he's above the minSpeed and
                        % the video tracking is up and running
                        if whlIndexStart>0 & ...
                                whlIndexStart<whlIndexEnd & ...
                                (midPointsBool | ...
                                (isempty(find(drinking(whlIndexStart:whlIndexEnd,1) > -1)) & ...
                                mean(speedData(whlIndexStart:whlIndexEnd).*hanFilter/mean(hanFilter))>minSpeed & ...%abs(accelData(whlIndexStart:whlIndexEnd))<minSpeed & ...
                                length(find(speedData(whlIndexStart:whlIndexEnd)==-1)) < ...
                                length(speedData(whlIndexStart:whlIndexEnd))/2 & ...                        
                                whlIndexEnd>firstWhlPoint & whlIndexStart<lastWhlPoint))
%                         if whlIndexStart>0 & ...
%                                 whlIndexStart<whlIndexEnd & ...
%                                 (midPointsBool | ...
%                                 (isempty(find(drinking(whlIndexStart:whlIndexEnd,1) > -1)) & ...
%                                 isempty(find(speedData(whlIndexStart:whlIndexEnd)~=-1)) &...
%                                 length(find(speedData(whlIndexStart:whlIndexEnd)==-1)) < ...
%                                 length(speedData(whlIndexStart:whlIndexEnd))/2 & ...                        
%                                 whlIndexEnd>firstWhlPoint & whlIndexStart<lastWhlPoint))
%                         if whlIndexStart>0 & ...
%                                 whlIndexStart<whlIndexEnd & ...
%                                 (midPointsBool | whlIndexEnd>firstWhlPoint & whlIndexStart<lastWhlPoint)
%                             if isempty(find(drinking(whlIndexStart:whlIndexEnd,1) > -1)) & ...
%                                 isempty(find(speedData(whlIndexStart:whlIndexEnd)<minSpeed & ...
%                                 abs(accelData(whlIndexStart:whlIndexEnd))<minSpeed & ...
%                                 speedData(whlIndexStart:whlIndexEnd)~=-1)) & ...
%                                 length(find(speedData(whlIndexStart:whlIndexEnd)==-1)) < ...
%                                 length(speedData(whlIndexStart:whlIndexEnd))/2
% keyboard
%                             end
count = count +1;
%fprintf('%3.1f,%3.1f\n',mean(speedData(whlIndexStart:whlIndexEnd)),mean(accelData(whlIndexStart:whlIndexEnd)))

                        end
                    end
                   count
                end
            catch
                errorText = ['WARNING:  ' date '  ' mfilename '  call=('...
                    description ',' fileBase ',' fileExt ',' num2str(nChan) ',' ...
                    num2str(winLength) ',' num2str(midPointsBool) '\n'];
                ReportError(errorText,~batchModeBool)
            end

            c2 = clock-c1;
            disp(num2str(c2))
            cd(currDir)
        catch
            errorText = ['ERROR:  ' date '  ' mfilename '  call=('...
                description ',' fileBase ',' fileExt ',' num2str(nChan) ',' ...
                num2str(winLength) ',' num2str(midPointsBool) '\n'];
            ReportError(errorText,~batchModeBool)
            cd(currDir)
        end
    end
catch
    errorText = ['ERROR:  ' date '  ' mfilename '  call=('...
        description ',' fileExt ',' num2str(nChan) ',' ...
        num2str(winLength) ',' num2str(midPointsBool) '\n'];
    ReportError(errorText,~batchModeBool)
end
return

