function CalcRunningSpectra11(description,fileBaseCell,fileExt,nChan,winLength,midPointsBool,thetaFreqRange,gammaFreqRange,varargin)
%function CalcRunningSpectra11(description,fileBaseCell,fileExt,nChan,winLength,midPointsBool,thetaFreqRange,gammaFreqRange,varargin)
%[trialTypesBool,excludeLocations,minSpeed,selectedChannels] = ...
%    DefaultArgs(varargin,{[1 1 1 1 1 1 1 1 1 1 1 1 0],[1 1 1 0 0 0 0 0 0],0,load(['SelectedChannels' fileExt '.txt'])});
chanInfoDir = 'ChanInfo/';

[trialTypesBool,excludeLocations,minSpeed,selChansStruct,batchModeBool] = ...
    DefaultArgs(varargin,{[1 1 1 1 1 1 1 1 1 1 1 1 0],[1 1 1 0 0 0 0 0 0],0,LoadVar([chanInfoDir 'SelChan' fileExt '.mat']),1});

try

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

    saveDir = [mfilename '_' description midPtext '_MinSpeed' num2str(minSpeed) 'Win' num2str(winLength) fileExt];
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
                                isempty(find(speedData(whlIndexStart:whlIndexEnd)<minSpeed & ...
                                speedData(whlIndexStart:whlIndexEnd)~=-1)) &...
                                whlIndexEnd>firstWhlPoint & whlIndexStart<lastWhlPoint))

                            eegData = bload([fileBase fileExt],[nChan winLength],to(i)*nChan*bps,'int16');
                            rawTrace = cat(1,rawTrace,permute(eegData,[3,1,2]));
                            keyboard
                            
                            %%% testing %%%
                            N = winLength;
                            DJ = 1/18;
                            S0 = 4;
                            J1 = round(log2(N/S0)/(DJ)-1.3/DJ);
                            [temp period junk coi] = xwt(eegData(m,:),eegData(m,:),'Pad',1,'DJ',DJ,'S0',S0,'J1',J1,'Param',6);
                            fo = 1./period.*eegSamp;
                            figure
                            pcolor(1:winLength,fo,10*log10(temp))
                            shading interp
                            set(gca,'ylim',[0 20])
                            colorbar
                            hold on
                            plot(1:winLength,1./coi.*eegSamp,'k')
                            hannWin = hanning(winLength)./sum(hanning(winLength));
                            desFreq = thetaFreqRange(1):thetaFreqRange(2);
                            figure
                            for k=1:length(desFreq)
                                winInd = find(abs(desFreq(k)-1./coi.*eegSamp) == min(abs(desFreq(k)-1./coi.*eegSamp)));
                                percArea = 1-sum(hannWin(winInd(1):winInd(end)))
                                plot(desFreq(k),percArea,'o');
                                set(gca,'ylim',[0,1]);
                                hold on
                            end
                            %%% end testing %%%
                            
                            pcolor(temp)
                            for m=1:nChan
                                [temp period] = xwt(eegData(m,:),eegData(m,:),'Pad',1,'DJ',DJ,'S0',S0,'J1',J1);
                                pow(1,m,:) = mean(temp'.*[repmat([hanning(winLength)./mean(hanning(winLength))],1,size(temp,1))],1);
                            end
                            for k=1:length(selectedChannels)
                                for m=1:nChan
                                    [temp xSpecPeriod]= xwt(eegData(selectedChannels(k),:),eegData(m,:),'Pad',1,'DJ',DJ,'S0',S0,'J1',J1);
                                    xSpec(1,k,m,:) = mean(temp'.*[repmat([hanning(winLength)./mean(hanning(winLength))],1,size(temp,1))],1);
                                    coh(1,k,m,:) = atanh((sqrt(squeeze(xSpec(1,k,m,:).*conj(xSpec(1,k,m,:)))./...
                                        squeeze(pow(1,selectedChannels(k),:).*pow(1,m,:)))-0.5)*1.999);
                                    phase(1,k,m,:) = complex(cos(angle(xSpec(1,k,m,:))),sin(angle(xSpec(1,k,m,:))));
                                end
                            end

                            fo = 1./period.*eegSamp;
                            fo = flipdim(fo,2);

                            if period ~= xSpecPeriod
                                ERROR_period_not_equal_to_cohPeriod
                            end
                            if exist('pSpec','var') & fo ~= pSpec.fo
                                ERROR_pSpec.fo_is_changing
                            end

                            wavePow = cat(1,wavePow,flipdim(pow,3));
                            waveXspec = cat(1,waveXspec,flipdim(xSpec,4));
                            waveCoh = cat(1,waveCoh,flipdim(coh,4));
                            wavePhase = cat(1,wavePhase,flipdim(phase,4));

                            %[wave,fo,t,s,wb] = Wavelet(eegData',[],eegSamp,w0);
                            %clear wb
                            %wave = permute(mean(abs(wave).^2,1),[1,3,2]);
                            %wavePow = cat(1,wavePow,wave);

                            %% calculate theta frequency: try LocalMinima then max
                            fRangeInd = find(fo>=thetaFreqRange(1) & fo<=thetaFreqRange(2));
                            for k=1:size(wavePow,2)
                                temp = LocalMinima(-wavePow(end,k,fRangeInd),length(fRangeInd));
                                if isempty(temp)
                                    [peakThetaPow, temp] = max(wavePow(end,k,fRangeInd),[],3);
                                end
                                peakThetaInd(:,k) = temp;
                            end
                            thetaFreq = cat(1,thetaFreq,fo(fRangeInd(1)+squeeze(peakThetaInd(:))-1));

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
                    size(wavePow)
                end
            catch
                errorText = ['WARNING:  ' date '  ' mfilename '  call=('...
                    description ',' fileBase ',' fileExt ',' num2str(nChan) ',' ...
                    num2str(winLength) ',' num2str(midPointsBool) '\n'];
                ReportError(errorText,~batchModeBool)
            end
            %%% Calculate fo bin sizes for integration %%%
            if fo(1) > fo(end)
                diffSign = -1;
            else
                diffSign = 1;
            end
            diff1 = diffSign*diff([fo(1) fo]);
            diff2 = diffSign*diff([fo fo(end)]);
            diffsum = diff1 + diff2;
            diffdiv = [1 2*ones(1,length(diffsum)-2) 1];
            binSize = permute(diffsum./diffdiv,[3 1 2]);

            %%% peak/intg/mean theta/gamma power spectrum estimates %%%
            thetaPowPeak = squeeze(10.*log10(max(wavePow(:,:,fo>=thetaFreqRange(1) & fo<=thetaFreqRange(2)),[],3)));
            thetaPowIntg = squeeze(10.*log10(sum(wavePow(:,:,fo>=thetaFreqRange(1) & fo<=thetaFreqRange(2))...
                .*repmat(binSize(fo>=thetaFreqRange(1) & fo<=thetaFreqRange(2)),[size(wavePow,1),size(wavePow,2),1]),3)));
            thetaPowMean = squeeze(10.*log10(sum(wavePow(:,:,fo>=thetaFreqRange(1) & fo<=thetaFreqRange(2))...
                .*repmat(binSize(fo>=thetaFreqRange(1) & fo<=thetaFreqRange(2)),[size(wavePow,1),size(wavePow,2),1]),3)...
                /sum(binSize(fo>=thetaFreqRange(1) & fo<=thetaFreqRange(2)))));

            gammaPowPeak = squeeze(10.*log10(max(wavePow(:,:,fo>=gammaFreqRange(1) & fo<=gammaFreqRange(2)),[],3)));
            gammaPowIntg = squeeze(10.*log10(sum(wavePow(:,:,fo>=gammaFreqRange(1) & fo<=gammaFreqRange(2))...
                .*repmat(binSize(fo>=gammaFreqRange(1) & fo<=gammaFreqRange(2)),[size(wavePow,1),size(wavePow,2),1]),3)));
            gammaPowMean = squeeze(10.*log10(sum(wavePow(:,:,fo>=gammaFreqRange(1) & fo<=gammaFreqRange(2))...
                .*repmat(binSize(fo>=gammaFreqRange(1) & fo<=gammaFreqRange(2)),[size(wavePow,1),size(wavePow,2),1]),3)...
                /sum(binSize(fo>=gammaFreqRange(1) & fo<=gammaFreqRange(2)))));

            powSpec.yo = 10.*log10(wavePow);
            powSpec.fo = fo;

            %%% mean/median theta/gamma coh/phase estimates %%%
            for k=1:length(selectedChannels)
                crossSpec.yo.(selChanNames{k}) = squeeze(waveXspec(:,k,:,:));
                cohSpec.yo.(selChanNames{k}) = squeeze(waveCoh(:,k,:,:));
                phaseSpec.yo.(selChanNames{k}) = squeeze(wavePhase(:,k,:,:));

                thetaCohMedian.(selChanNames{k}) = squeeze(median(cohSpec.yo.(selChanNames{k})(:,:,fo>=thetaFreqRange(1) & fo<=thetaFreqRange(2)),3));
                thetaCohMean.(selChanNames{k}) = squeeze(sum(cohSpec.yo.(selChanNames{k})(:,:,fo>=thetaFreqRange(1) & fo<=thetaFreqRange(2))...
                    .*repmat(binSize(fo>=thetaFreqRange(1) & fo<=thetaFreqRange(2)),[size(cohSpec.yo.(selChanNames{k}),1),size(cohSpec.yo.(selChanNames{k}),2),1]),3)...
                    /sum(binSize(fo>=thetaFreqRange(1) & fo<=thetaFreqRange(2))));
                thetaPhaseMean.(selChanNames{k}) = squeeze(sum(phaseSpec.yo.(selChanNames{k})(:,:,fo>=thetaFreqRange(1) & fo<=thetaFreqRange(2))...
                    .*repmat(binSize(fo>=thetaFreqRange(1) & fo<=thetaFreqRange(2)),[size(phaseSpec.yo.(selChanNames{k}),1),size(phaseSpec.yo.(selChanNames{k}),2),1]),3)...
                    /sum(binSize(fo>=thetaFreqRange(1) & fo<=thetaFreqRange(2))));

                gammaCohMedian.(selChanNames{k}) = squeeze(median(cohSpec.yo.(selChanNames{k})(:,:,fo>=gammaFreqRange(1) & fo<=gammaFreqRange(2)),3));
                gammaCohMean.(selChanNames{k}) = squeeze(sum(cohSpec.yo.(selChanNames{k})(:,:,fo>=gammaFreqRange(1) & fo<=gammaFreqRange(2))...
                    .*repmat(binSize(fo>=gammaFreqRange(1) & fo<=gammaFreqRange(2)),[size(cohSpec.yo.(selChanNames{k}),1),size(cohSpec.yo.(selChanNames{k}),2),1]),3)...
                    /sum(binSize(fo>=gammaFreqRange(1) & fo<=gammaFreqRange(2))));
                gammaPhaseMean.(selChanNames{k}) = squeeze(sum(phaseSpec.yo.(selChanNames{k})(:,:,fo>=gammaFreqRange(1) & fo<=gammaFreqRange(2))...
                    .*repmat(binSize(fo>=gammaFreqRange(1) & fo<=gammaFreqRange(2)),[size(phaseSpec.yo.(selChanNames{k}),1),size(phaseSpec.yo.(selChanNames{k}),2),1]),3)...
                    /sum(binSize(fo>=gammaFreqRange(1) & fo<=gammaFreqRange(2))));
            end
            crossSpec.fo = fo;
            cohSpec.fo = fo;
            phaseSpec.fo = fo;


            subplot(2,2,2);
            hold on
            pcolor(1:length(time),powSpec.fo,squeeze(powSpec.yo(:,selectedChannels(1),:))');
            shading 'flat'
            set(gca,'clim',[35 75],'ylim',[0,100]);
            colorbar
            plot(1:length(time),thetaFreq(:,selectedChannels(1)),'k')

            subplot(2,2,3);
            pcolor(1:length(time),cohSpec.fo,squeeze(cohSpec.yo.(selChanNames{1})(:,selectedChannels(2),:))');
            shading 'flat'
            set(gca,'clim',[0 1],'ylim',[0,100]);
            colorbar

            subplot(2,2,4);
            pcolor(1:length(time),phaseSpec.fo,angle(squeeze(phaseSpec.yo.(selChanNames{1})(:,selectedChannels(2),:)))');
            shading 'flat'
            set(gca,'clim',[-pi pi],'ylim',[0,100]);
            colorbar

            if ~exist(saveDir,'dir')
                eval(['mkdir ' saveDir])
            end
            infoStruct = setfield(infoStruct,'saveDir',saveDir);
            fprintf('Saving: %s\n',saveDir)
            set(gcf,'name',[fileBase ': ' saveDir]);

            save([saveDir '/infoStruct.mat'],SaveAsV6,'infoStruct');
            save([saveDir '/rawTrace.mat'],SaveAsV6,'rawTrace');
            save([saveDir '/thetaFreq' num2str(thetaFreqRange(1)) '-' num2str(thetaFreqRange(2)) 'Hz.mat'],SaveAsV6,'thetaFreq');
            save([saveDir '/powSpec.mat'],SaveAsV6,'powSpec');
            save([saveDir '/crossSpec.mat'],SaveAsV6,'crossSpec');
            save([saveDir '/cohSpec.mat'],SaveAsV6,'cohSpec');
            save([saveDir '/phaseSpec.mat'],SaveAsV6,'phaseSpec');
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
            save([saveDir '/thetaPowPeak' num2str(thetaFreqRange(1)) '-' num2str(thetaFreqRange(2)) 'Hz.mat'],SaveAsV6,'thetaPowPeak');
            save([saveDir '/thetaPowIntg' num2str(thetaFreqRange(1)) '-' num2str(thetaFreqRange(2)) 'Hz.mat'],SaveAsV6,'thetaPowIntg');
            save([saveDir '/thetaPowMean' num2str(thetaFreqRange(1)) '-' num2str(thetaFreqRange(2)) 'Hz.mat'],SaveAsV6,'thetaPowMean');
            save([saveDir '/gammaPowPeak' num2str(gammaFreqRange(1)) '-' num2str(gammaFreqRange(2)) 'Hz.mat'],SaveAsV6,'gammaPowPeak');
            save([saveDir '/gammaPowIntg' num2str(gammaFreqRange(1)) '-' num2str(gammaFreqRange(2)) 'Hz.mat'],SaveAsV6,'gammaPowIntg');
            save([saveDir '/gammaPowMean' num2str(gammaFreqRange(1)) '-' num2str(gammaFreqRange(2)) 'Hz.mat'],SaveAsV6,'gammaPowMean');
            save([saveDir '/thetaCohMedian' num2str(thetaFreqRange(1)) '-' num2str(thetaFreqRange(2)) 'Hz.mat'],SaveAsV6,'thetaCohMedian');
            save([saveDir '/thetaCohMean' num2str(thetaFreqRange(1)) '-' num2str(thetaFreqRange(2)) 'Hz.mat'],SaveAsV6,'thetaCohMean');
            save([saveDir '/gammaCohMedian' num2str(gammaFreqRange(1)) '-' num2str(gammaFreqRange(2)) 'Hz.mat'],SaveAsV6,'gammaCohMedian');
            save([saveDir '/gammaCohMean' num2str(gammaFreqRange(1)) '-' num2str(gammaFreqRange(2)) 'Hz.mat'],SaveAsV6,'gammaCohMean');
            save([saveDir '/thetaPhaseMean' num2str(thetaFreqRange(1)) '-' num2str(thetaFreqRange(2)) 'Hz.mat'],SaveAsV6,'thetaPhaseMean');
            save([saveDir '/gammaPhaseMean' num2str(gammaFreqRange(1)) '-' num2str(gammaFreqRange(2)) 'Hz.mat'],SaveAsV6,'gammaPhaseMean');

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

