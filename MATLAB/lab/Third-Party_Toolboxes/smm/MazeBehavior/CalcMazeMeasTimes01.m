function CalcMazeMeasTimes01(spectAnalName,description,fileBaseCell,fileExt,nChan,winLength,wavParam,midPointsBool,varargin)
%function CalcRunningSpectra12(description,fileBaseCell,fileExt,nChan,winLength,midPointsBool,thetaFreqRange,gammaFreqRange,varargin)
%[trialTypesBool,excludeLocations,minSpeed,selectedChannels] = ...
%    DefaultArgs(varargin,{[1 1 1 1 1 1 1 1 1 1 1 1 0],[1 1 1 0 0 0 0 0 0],0,load(['SelectedChannels' fileExt '.txt'])});
chanInfoDir = 'ChanInfo/';

[trialTypesBool,excludeLocations,minSpeed,selChansStruct,batchModeBool] = ...
    DefaultArgs(varargin,{[1 1 1 1 1 1 1 1 1 1 1 1 0],[1 1 1 0 0 0 0 0 0],0,LoadVar([chanInfoDir 'SelChan' fileExt '.mat']),1});


anatFields = fieldnames(selChansStruct);
for j=1:length(anatFields)
    selectedChannels(j) = selChansStruct.(anatFields{j});
end
for k=1:length(selectedChannels)
    selChanNames{k} = ['ch' num2str(selectedChannels(k))];
end

if midPointsBool
    midPtext = '_MidPoints';
else
    midPtext = [];
end

saveDir = [spectAnalName '_' description midPtext '_MinSpeed' num2str(minSpeed) 'Win' num2str(winLength) 'wavParam' num2str(wavParam) fileExt];
currDir = pwd;

%addpath /u12/antsiro/matlab/General
addpath ~/matlab/sm_Copies

%%%% parameters optimized for winLength = 626 %%%%

lags = -1500:50:1500;
whlSamp = 39.065;
eegSamp = 1250;
bps = 2;
whlWinLen = winLength*whlSamp/eegSamp;
hanFilter = hanning(floor(whlWinLen));

%yoFreqRange = [0 500];

infoStruct = [];
infoStruct = setfield(infoStruct,'wavParam',wavParam);
infoStruct = setfield(infoStruct,'nChan',nChan);
infoStruct = setfield(infoStruct,'winLength',winLength);
infoStruct = setfield(infoStruct,'whlSamp',whlSamp);
infoStruct = setfield(infoStruct,'eegSamp',eegSamp);
infoStruct = setfield(infoStruct,'minSpeed',minSpeed);
infoStruct = setfield(infoStruct,'lags',lags);
infoStruct = setfield(infoStruct,'trialTypesBool',trialTypesBool);
infoStruct = setfield(infoStruct,'excludeLocations',excludeLocations);
infoStruct = setfield(infoStruct,'fileExt',fileExt);
infoStruct = setfield(infoStruct,'description',description);
infoStruct = setfield(infoStruct,'program',mfilename);

%dayStruct = LoadVar('DayStruct.mat');

for j=1:length(fileBaseCell)
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
            trialMidsStruct = CalcFileMidPoints02(fileBase,0,trialTypesBool)
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
        %     end
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
                        isempty(find(speedData(whlIndexStart:whlIndexEnd)<minSpeed & ...
                        speedData(whlIndexStart:whlIndexEnd)~=-1)) &...
                        whlIndexEnd>firstWhlPoint & whlIndexStart<lastWhlPoint))

                    time = cat(1, time, (to(i)+winLength/2)/eegSamp); % in seconds
                    [thisTaskType, thisTrialType, thisMazeLoc] = GetTrialInfo(fileBase,whlIndexStart:whlIndexEnd);
                    taskType = cat(1,taskType,{thisTaskType});
                    trialType = cat(1,trialType,thisTrialType);
                    mazeLocation = cat(1,mazeLocation,thisMazeLoc);
                    if midPointsBool
                        mazeLocName = cat(1,mazeLocName,mazeLocNames(i));
                    end
                    eegSegTime = cat(1,eegSegTime,to(i));

                    plot(whlData(whlIndexStart:whlIndexEnd,1),whlData(whlIndexStart:whlIndexEnd,2),'k');

                    for k=1:length(lags)
                        lag = lags(k);
                        whlIndexStart = round(whlSamp*(to(i)/eegSamp+lag/1000)+1);
                        whlIndexEnd = whlIndexStart+size(hanFilter,1)-1;
                        % if indexes run off the end of the file
                        % or not enough whl points to reliably calc speed
                        if  whlIndexStart<1 | whlIndexEnd>size(speedData,1) | ...
                                size(find(speedData(whlIndexStart:whlIndexEnd) > -1),1) < 1/2*size(hanFilter,1)
                            %fprintf('error_not_enough_position_measurements: time=%i, interval=%i\n',to(i)/eegSamp,lag);
                            aveSpeed = NaN;
                            aveAccel = NaN;
                            positionData = [NaN NaN NaN NaN];
                        else
                            speedSeg = speedData(whlIndexStart:whlIndexEnd);
                            accelSeg = accelData(whlIndexStart:whlIndexEnd);
                            indexes = speedSeg >= 0;


                            if isempty(find(indexes>0))
                                %fprintf('error_speed_cant_be_reliably_measured: time=%i, interval=%i\n',to(i)/eegSamp,lag);
                                aveSpeed = NaN;
                                aveAccel = NaN;
                                positionData = [NaN NaN NaN NaN];
                            else
                                normHanFilter = hanFilter./mean(hanFilter(indexes)); % normalize the hanning filter
                                speedSeg = normHanFilter.*speedSeg;
                                accelSeg = normHanFilter.*accelSeg;

                                aveSpeed = mean(speedSeg(indexes));
                                aveAccel = mean(accelSeg(indexes));

                                positionData = whlData(floor(whlIndexStart+size(hanFilter,1)/2),:);
                            end
                        end
                        %keyboard
                        if lag<0
                            speed = setfield(speed,['n' num2str(abs(lag))],{length(time),1},aveSpeed);
                            accel = setfield(accel,['n' num2str(abs(lag))],{length(time),1},aveAccel);
                            position = setfield(position,['n' num2str(abs(lag))],{length(time),1:4},positionData);
                        else
                            speed = setfield(speed,['p' num2str(abs(lag))],{length(time),1},aveSpeed);
                            accel = setfield(accel,['p' num2str(abs(lag))],{length(time),1},aveAccel);
                            position = setfield(position,['p' num2str(abs(lag))],{length(time),1:4},positionData);
                        end
                        if lag==0
                            plot(positionData(1),positionData(2),'r.');
                        end

                    end
                end
            end
            size(time)
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
        save([saveDir '/speed.mat'],SaveAsV6,'speed');
        save([saveDir '/accel.mat'],SaveAsV6,'accel');
        save([saveDir '/position.mat'],SaveAsV6,'position');
        save([saveDir '/taskType.mat'],SaveAsV6,'taskType');
        save([saveDir '/trialType.mat'],SaveAsV6,'trialType');
        save([saveDir '/mazeLocation.mat'],SaveAsV6,'mazeLocation');
        if midPointsBool
            save([saveDir '/mazeLocName.mat'],SaveAsV6,'mazeLocName');
        end

        c2 = clock-c1;
        disp(num2str(c2))
        cd(currDir)
    end
end
return

