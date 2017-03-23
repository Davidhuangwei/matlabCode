% function CalcRunningSpectraTime01(saveDir,fileBaseCell,fileExt,nChan,winLength,midPointsBool,varargin)
% chanInfoDir = 'ChanInfo/';
% [trialTypesBool,excludeLocations,minSpeed,batchModeBool,plotAxis] = ...
%     DefaultArgs(varargin,{[1 1 1 1 1 1 1 1 1 1 1 1 0],[1 1 1 0 0 0 0 0 0],10,1,subplot(2,2,1)});
function CalcRunningSpectraTime01(saveDir,fileBaseCell,fileExt,nChan,winLength,midPointsBool,varargin)
[trialTypesBool,excludeLocations,minSpeed,maxNTimes,plotBool,figHandleCell,subPlotLoc,batchModeBool] = ...
    DefaultArgs(varargin,{[1 1 1 1 1 1 1 1 1 1 1 1 0],[1 1 1 0 0 0 0 0 0],0,NaN,1,{},{2,2,1},1});

% try
    currDir = pwd;
    whlSamp = 39.065;
    eegSamp = 1250;
    bps = 2;
    whlWinLen = winLength*whlSamp/eegSamp;
    hanFilter = hanning(floor(whlWinLen));
    infoStruct = [];
    infoStruct = setfield(infoStruct,'nChan',nChan);
    infoStruct = setfield(infoStruct,'whlSamp',whlSamp);
    infoStruct = setfield(infoStruct,'eegSamp',eegSamp);
    infoStruct = setfield(infoStruct,'minSpeed',minSpeed);
    infoStruct = setfield(infoStruct,'winLength',winLength);
    infoStruct = setfield(infoStruct,'midPointsBool',midPointsBool);
    infoStruct = setfield(infoStruct,'trialTypesBool',trialTypesBool);
    infoStruct = setfield(infoStruct,'excludeLocations',excludeLocations);
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
            
             if plotBool
                if ~isempty(figHandleCell)
                    figure(figHandleCell{j})
                end
                subplot(subPlotLoc{:});
                hold on;
            end

            time = [];
            mazeLocName = {};
            mazeLocNames = {};
            to = [];
            eegSegTime = [];

            fileInfo = dir([fileBase fileExt]);
            numSamples = fileInfo.bytes/nChan/bps;

            drinking = LoadMazeTrialTypes(fileBase, [1 1 1 1 1 1 1 1 1 1 1 1 1],excludeLocations);
            whlData = LoadMazeTrialTypes(fileBase, trialTypesBool,[1 1 1 1 1 1 1 1 1]);
            if plotBool
                plot(whlData(find(whlData(:,1)~=-1),1),whlData(find(whlData(:,1)~=-1),2),':y')
            end
            [speedData accelData] = MazeSpeedAccel(whlData);
            firstWhlPoint = find(whlData(:,1)~=-1,1,'first');
            lastWhlPoint = find(whlData(:,1)~=-1,1,'last');

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
%              try
                if ~isempty(to)
                    for i=1:length(to)
                        whlIndexStart = round(to(i)*whlSamp/eegSamp+1); % in whl samples starting with 1
                        whlIndexEnd = min(size(whlData,1),whlIndexStart+size(hanFilter,1)-1);
                        % if:
                        % we calculated midpoints or:
                        % he's not in the excluded areas and
                        % he's above the minSpeed and
                        % video tracking is up and running
                        % he was tracked for more than half the points

                        if whlIndexStart>0 & ...
                                whlIndexStart<whlIndexEnd & ...
                                whlIndexEnd-whlIndexStart+1==length(hanFilter) & ...
                                (midPointsBool | ...
                                (isempty(find(drinking(whlIndexStart:whlIndexEnd,1) > -1)) & ...
                                mean(speedData(whlIndexStart:whlIndexEnd).*hanFilter/mean(hanFilter))>minSpeed & ...
                                whlIndexEnd>firstWhlPoint & whlIndexStart<lastWhlPoint & ...
                                length(find(speedData(whlIndexStart:whlIndexEnd)==-1)) < ...
                                length(speedData(whlIndexStart:whlIndexEnd))/2))

                            eegSegTime = cat(1,eegSegTime,to(i));
                            if midPointsBool
                                mazeLocName = cat(1,mazeLocName,mazeLocNames(i));
                            end

                        end
                    end
                end
                allEegSegTime = eegSegTime;
                if ~isnan(maxNTimes) & (length(eegSegTime) > maxNTimes)
                    keptTime = logical(zeros(size(eegSegTime)));
                    keptTime(randsample(length(eegSegTime),maxNTimes)) = 1;
                    eegSegTime = eegSegTime(keptTime);
                    if midPointsBool
                        mazeLocName = mazeLocName(keptTime);
                    end
                else
                    keptTime = logical(ones(size(eegSegTime)));
                end
                    
                time = (eegSegTime+winLength/2)/eegSamp; % in seconds at middle of eegSeg
                
                to = eegSegTime;
                for i=1:length(to)
                    whlIndexStart = round(to(i)*whlSamp/eegSamp+1); % in whl samples starting with 1
                    whlIndexEnd = min(size(whlData,1),whlIndexStart+size(hanFilter,1)-1);

                    if plotBool
                        plot(whlData(whlIndexStart:whlIndexEnd,1),whlData(whlIndexStart:whlIndexEnd,2),'k');
                    end

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
            if midPointsBool
                save([saveDir '/mazeLocName.mat'],SaveAsV6,'mazeLocName');
            end

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

