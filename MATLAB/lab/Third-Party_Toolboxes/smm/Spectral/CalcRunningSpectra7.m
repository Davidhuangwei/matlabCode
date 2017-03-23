function CalcRunningSpectra7(description,fileBaseMat,fileExt,nChan,winLength,midPointsBool,thetaFreqRange,gammaFreqRange,varargin)
%function CalcRunningSpectra7(description,fileBaseMat,fileExt,nChan,winLength,midPointsBool,thetaFreqRange,gammaFreqRange,varargin)
%[trialTypesBool,excludeLocations,minSpeed,selectedChannels] = ...
%    DefaultArgs(varargin,{[1 1 1 1 1 1 1 1 1 1 1 1 0],[1 1 1 0 0 0 0 0 0],0,load(['SelectedChannels' fileExt '.txt'])});

chanInfoDir = 'ChanInfo/';
w0 = 6;

[trialTypesBool,excludeLocations,minSpeed,selectedChannels] = ...
    DefaultArgs(varargin,{[1 1 1 1 1 1 1 1 1 1 1 1 0],[1 1 1 0 0 0 0 0 0],0,load([chanInfoDir 'SelectedChannels' fileExt '.txt'])});

if midPointsBool
    midPtext = '_MidPoints';
else
    midPtext = [];
end

for k=1:length(selectedChannels)
    selChanNames{k} = ['ch' num2str(selectedChannels(k))];
end

saveDir = [mfilename '_' description midPtext '_MinSpeed' num2str(minSpeed) 'Win' num2str(winLength) ...
    'W0' num2str(w0) fileExt];

%addpath /u12/antsiro/matlab/General
addpath /u12/smm/matlab/sm_Copies
lags = -1500:50:1500;
whlSamp = 39.065;
eegSamp = 1250;
bps = 2;
whlWinLen = winLength*whlSamp/eegSamp;
hanFilter = hanning(floor(whlWinLen));

%yoFreqRange = [0 500];

infoStruct = [];
infoStruct = setfield(infoStruct,'winLength',winLength);
infoStruct = setfield(infoStruct,'w0',w0);
infoStruct = setfield(infoStruct,'minSpeed',minSpeed);
infoStruct = setfield(infoStruct,'trialTypesBool',trialTypesBool);
infoStruct = setfield(infoStruct,'excludeLocations',excludeLocations);
infoStruct = setfield(infoStruct,'fileExt',fileExt);
infoStruct = setfield(infoStruct,'thetaFreqRange',thetaFreqRange);
infoStruct = setfield(infoStruct,'gammaFreqRange',gammaFreqRange);
infoStruct = setfield(infoStruct,'description',description);
infoStruct = setfield(infoStruct,'program',mfilename);

dayStruct = LoadVar('DayStruct.mat');

for j=1:size(fileBaseMat,1)
    fileBase = fileBaseMat(j,:);
    infoStruct = setfield(infoStruct,'fileBase',fileBase);
    fprintf('Processing: %s%s\n',fileBase,fileExt);
    eval(['cd ' fileBase]);
   
    figure;
    subplot(3,1,1);
    hold on;
    
    wavePow = [];
    waveCoh = [];
    thetaFreq = [];
    speed = [];
    accel = [];
    time = [];
    taskType = {};
    day = {};
    trialType = [];
    mazeLocation = [];
    position = [];
    rawTrace = [];
          
    fileInfo = dir([fileBase fileExt]);
    numSamples = fileInfo.bytes/nChan/bps;
   
    drinking = LoadMazeTrialTypes(fileBase, [1 1 1 1 1 1 1 1 1 1 1 1 1],excludeLocations);
    whlData = LoadMazeTrialTypes(fileBase, trialTypesBool,[1 1 1 1 1 1 1 1 1]);
    plot(whlData(find(whlData(:,1)~=-1),1),whlData(find(whlData(:,1)~=-1),2),':y')
    [speedData accelData] = MazeSpeedAccel(whlData);
    
    if exist([saveDir '/eegSegTime.mat'],'file')
        fprintf('Loading: %s/eegSegTime.mat\n',saveDir)
        to = LoadVar([saveDir '/eegSegTime.mat']);
    else
        if midPointsBool
            trialMidsStruct = CalcFileMidPoints(fileBase,0,trialTypesBool);
            mazeRegionNames = fieldnames(getfield(trialMidsStruct,fileBase));
            to = [];
            for i=1:size(mazeRegionNames,1)
                to = [to; getfield(trialMidsStruct,fileBase,mazeRegionNames{i})'];
            end
            to = round(sort(to-1)*eegSamp/whlSamp-winLength/2); % in eeg samples starting with 0
        else
            to = [0:winLength:numSamples]'; % in in eeg samples starting with 0
        end
    end
    if ~isempty(to)
        for i=1:length(to)
            whlIndexStart = round(to(i)*whlSamp/eegSamp+1); % in whl samples starting with 1
            whlIndexEnd = min(size(whlData,1),whlIndexStart+size(hanFilter,1)-1);
            % if: 
            % we calculated midpoints
            % we have enough speed measurements to calculate
            % he's not in the excluded areas
            % he's above the minSpeed
            if whlIndexStart>0 & ...
                    whlIndexStart<whlIndexEnd & ...
                    size(find(speedData(whlIndexStart:whlIndexEnd) > -1),1) > 1/2*size(hanFilter,1) & ...
                    (midPointsBool | ...
                    (isempty(find(drinking(whlIndexStart:whlIndexEnd,1) > -1)) & ...
                    isempty(find(speedData(whlIndexStart:whlIndexEnd)<minSpeed & speedData(whlIndexStart:whlIndexEnd)~=-1))))

                eegData = bload([fileBase fileExt],[nChan winLength],to(i)*nChan*bps,'int16');
                rawTrace = cat(1,rawTrace,permute(eegData,[3,1,2]));
                %keyboard
                
                
                N = winLength;
                DT = 1/eegSamp;
                DJ = 1/(2^4);
                S0 = (2^2)/eegSamp;
                J1 = log2(N*DT/S0)/(DJ)-2^4;
keyboard
                yoTemp = [];
                cohTemp2 = [];
                for m=1:nChan
                    [yo,yoPeriod] = wavelet(eegData(37,:),DT,1,DJ,S0,J1);
                    %[yo,yoPeriod] = wavelet(squeeze(eegData(m,:)'),1/eegSamp,1,1/30);
                    yo = mean((abs(yo').^2).*[repmat([hanning(winLength)./mean(hanning(winLength))],1,size(yo,1))],1);
                    yoTemp = cat(1,yoTemp,yo);
                    
                    cohTemp1 = [];
                    for k=1:length(selectedChannels)
                        ,'Pad',1,'DJ',DJ,'S0',S0*eegSamp
                        [coh,cohPeriod]=wtc(eegData(selectedChannels(k),:)',eegData(m,:)','Pad',1,'DJ',DJ,'S0',S0*eegSamp,'MonteCarloCount',0); 
                        %[coh,cohPeriod]=wtc(eegData(selectedChannels(k),:)',eegData(m,:)','Pad',1,'DJ',1/30,'MonteCarloCount',0);                        
                        coh = mean(coh'.*[repmat([hanning(winLength)./mean(hanning(winLength))],1,size(coh,1))],1)';
                        cohTemp1 = cat(2,cohTemp1,coh);
                    end
                    cohTemp2 = cat(3,cohTemp2,cohTemp1);
                end
                powFo = 1./yoPeriod;
                cohFo = 1./cohPeriod.*eegSamp;
                
                if exist('pSpec','var') & powFo ~= pSpec.fo
                    ERROR_pSpec.fo_is_changing
                end
                if exist('cohSpec','var') & cohFo ~= cohSpec.fo
                    ERROR_cohSpec.fo_is_changing
                end

                wavePow = cat(1,wavePow,permute(yoTemp,[3,1,2]));
                waveCoh = cat(1,waveCoh,permute(cohTemp2,[4,2,3,1]));
                
                %[wave,fo,t,s,wb] = Wavelet(eegData',[],eegSamp,w0);
                %clear wb
                %wave = permute(mean(abs(wave).^2,1),[1,3,2]);              
                %wavePow = cat(1,wavePow,wave);
                
                fRangeInd = find(powFo>=thetaFreqRange(1) & powFo<=thetaFreqRange(2));
                [peakThetaPow, peakThetaInd] = max(wavePow(end,:,fRangeInd),[],3);
                thetaFreq = cat(1,thetaFreq,powFo(fRangeInd(1)+squeeze(peakThetaInd(:))-1));

                day = cat(1, day, {dayStruct.(fileBase)});         
                time = cat(1, time, (to(i)+winLength/2)/eegSamp); % in seconds
                [thisTaskType, thisTrialType, thisMazeLoc] = GetTrialInfo(fileBase,whlIndexStart:whlIndexEnd);
                taskType = cat(1,taskType,{thisTaskType});
                trialType = cat(1,trialType,thisTrialType);
                mazeLocation = cat(1,mazeLocation,thisMazeLoc);

                plot(whlData(whlIndexStart:whlIndexEnd,1),whlData(whlIndexStart:whlIndexEnd,2),'k');

                for k=1:length(lags)
                    lag = lags(k);
                    whlIndexStart = round(whlSamp*(to(i)/eegSamp+lag/1000)+1);
                    whlIndexEnd = whlIndexStart+size(hanFilter,1)-1;
                    if whlIndexStart<1 | whlIndexEnd>size(speedData,1)
                        fprintf('error_beyond_border_of_file: time=%i, interval=%i\n',to(i)/eegSamp,lag);
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
    thetaPowPeak = squeeze(10.*log10(max(wavePow(:,:,find(powFo>=thetaFreqRange(1) & powFo<=thetaFreqRange(2))),[],3)));
    thetaPowIntg = squeeze(10.*log10(sum(wavePow(:,:,find(powFo>=thetaFreqRange(1) & powFo<=thetaFreqRange(2))),3)));
    gammaPowPeak = squeeze(10.*log10(max(wavePow(:,:,find(powFo>=gammaFreqRange(1) & powFo<=gammaFreqRange(2))),[],3)));
    gammaPowIntg = squeeze(10.*log10(sum(wavePow(:,:,find(powFo>=gammaFreqRange(1) & powFo<=gammaFreqRange(2))),3)));
    for k=1:size(waveCoh,2)
        thetaCohPeak.(selChanNames{k}) = squeeze(max(waveCoh(:,k,:,find(cohFo>=thetaFreqRange(1) & cohFo<=thetaFreqRange(2))),[],4));
        thetaCohMean.(selChanNames{k}) = squeeze(mean(waveCoh(:,k,:,find(cohFo>=thetaFreqRange(1) & cohFo<=thetaFreqRange(2))),4));
        gammaCohPeak.(selChanNames{k}) = squeeze(max(waveCoh(:,k,:,find(cohFo>=gammaFreqRange(1) & cohFo<=gammaFreqRange(2))),[],4));
        gammaCohMean.(selChanNames{k}) = squeeze(mean(waveCoh(:,k,:,find(cohFo>=gammaFreqRange(1) & cohFo<=gammaFreqRange(2))),4));
        waveCoh2.(selChanNames{k}) = squeeze(waveCoh(:,k,:,:));
    end
    %keyboard
    pSpec.yo = 10.*log10(wavePow);
    pSpec.fo = powFo;
    cohSpec.yo = waveCoh2;
    cohSpec.fo = cohFo;
    
    subplot(3,1,2);
    hold on
    pcolor(1:length(time),pSpec.fo,squeeze(pSpec.yo(:,selectedChannels(1),:))');
    shading 'flat'
    set(gca,'clim',[35 75],'ylim',[0,50]);
    colorbar
    plot(1:length(time),thetaFreq(:,selectedChannels(1)),'k')
    
    subplot(3,1,3);
    pcolor(1:length(time),cohSpec.fo,squeeze(cohSpec.yo.(selChanNames{1})(:,selectedChannels(2),:))');
    shading 'flat'
    set(gca,'clim',[0 1],'ylim',[0,50]);
    colorbar
    
    if ~exist(saveDir,'dir')
        eval(['mkdir ' saveDir])
    end
    infoStruct = setfield(infoStruct,'saveDir',saveDir);
    fprintf('Saving: %s\n',saveDir)
    set(gcf,'name',saveDir);

    save([saveDir '/rawTrace.mat'],SaveAsV6,'rawTrace');
    save([saveDir '/thetaFreq.mat'],SaveAsV6,'thetaFreq');
    save([saveDir '/pSpec.mat'],SaveAsV6,'pSpec');
    save([saveDir '/cohSpec.mat'],SaveAsV6,'cohSpec');
    save([saveDir '/day.mat'],SaveAsV6,'day');
    save([saveDir '/time.mat'],SaveAsV6,'time');
    save([saveDir '/eegSegTime.mat'],SaveAsV6,'to');
    save([saveDir '/speed.mat'],SaveAsV6,'speed');
    save([saveDir '/accel.mat'],SaveAsV6,'accel');
    save([saveDir '/position.mat'],SaveAsV6,'position');
    save([saveDir '/taskType.mat'],SaveAsV6,'taskType');
    save([saveDir '/trialType.mat'],SaveAsV6,'trialType');
    save([saveDir '/mazeLocation.mat'],SaveAsV6,'mazeLocation');
    save([saveDir '/thetaPowPeak' num2str(thetaFreqRange(1)) '-' num2str(thetaFreqRange(2)) 'Hz.mat'],SaveAsV6,'thetaPowPeak');
    save([saveDir '/thetaPowIntg' num2str(thetaFreqRange(1)) '-' num2str(thetaFreqRange(2)) 'Hz.mat'],SaveAsV6,'thetaPowIntg');
    save([saveDir '/gammaPowPeak' num2str(gammaFreqRange(1)) '-' num2str(gammaFreqRange(2)) 'Hz.mat'],SaveAsV6,'gammaPowPeak');
    save([saveDir '/gammaPowIntg' num2str(gammaFreqRange(1)) '-' num2str(gammaFreqRange(2)) 'Hz.mat'],SaveAsV6,'gammaPowIntg');
    save([saveDir '/thetaCohPeak' num2str(thetaFreqRange(1)) '-' num2str(thetaFreqRange(2)) 'Hz.mat'],SaveAsV6,'thetaCohPeak');
    save([saveDir '/thetaCohMean' num2str(thetaFreqRange(1)) '-' num2str(thetaFreqRange(2)) 'Hz.mat'],SaveAsV6,'thetaCohMean');
    save([saveDir '/gammaCohPeak' num2str(gammaFreqRange(1)) '-' num2str(gammaFreqRange(2)) 'Hz.mat'],SaveAsV6,'gammaCohPeak');
    save([saveDir '/gammaCohMean' num2str(gammaFreqRange(1)) '-' num2str(gammaFreqRange(2)) 'Hz.mat'],SaveAsV6,'gammaCohMean');
    save([saveDir '/infoStruct.mat'],SaveAsV6,'infoStruct');

    cd ..
end

return
