function CalcRunningSpectra5(description,fileBaseMat,fileExt,nChan,winLength,nOverlap,midPointsBool,thetaNW,thetaFreqRange,gammaNW,gammaFreqRange,varargin)

[trialTypesBool,excludeLocations,minSpeed,selectedChannels] = ...
    DefaultArgs(varargin,{[1 1 1 1 1 1 1 1 1 1 1 1 0],[1 1 1 0 0 0 0 0 0],0,load(['SelectedChannels' fileExt '.txt'])});




addpath /u12/antsiro/matlab/General

lags = -1500:50:1500;
whlSamp = 39.065;
eegSamp = 1250;
bps = 2;
%yoFreqRange = [0 500];

infoStruct = [];
infoStruct = setfield(infoStruct,'thetaNW',thetaNW);
infoStruct = setfield(infoStruct,'gammaNW',gammaNW);
infoStruct = setfield(infoStruct,'winLength',winLength);
infoStruct = setfield(infoStruct,'nOverlap',nOverlap);
infoStruct = setfield(infoStruct,'minSpeed',minSpeed);
infoStruct = setfield(infoStruct,'trialTypesBool',trialTypesBool);
infoStruct = setfield(infoStruct,'excludeLocations',excludeLocations);
infoStruct = setfield(infoStruct,'fileExt',fileExt);
infoStruct = setfield(infoStruct,'thetaFreqRange',thetaFreqRange);
infoStruct = setfield(infoStruct,'gammaFreqRange',gammaFreqRange);
infoStruct = setfield(infoStruct,'description',description);
infoStruct = setfield(infoStruct,'program',mfilename);

for j=1:size(fileBaseMat,1)
    fileBase = fileBaseMat(j,:);
    infoStruct = setfield(infoStruct,'fileBase',fileBase);
    fprintf('Processing: %s%s\n',fileBase,fileExt);
    eval(['cd ' fileBase]);
   
    figure;
    subplot(2,1,1)
    hold on;

    thetaYo = [];
    gammaYo = [];
    thetaFreq = [];
    speed = [];
    accel = [];
    time = [];
    taskType = {};
    trialType = [];
    mazeLocation = [];
    position = [];

    
    %inName = [spectraDir fileBase fileExt 'Win' num2str(winLength) 'Ovrlp' num2str(nOverlap) 'NW' num2str(NW) '_mtpsg_' num2str(channels(1)) '.mat'];
    %fprintf('Loading: %s\n' ,inName)
    %load(inName);
         
   
    fileInfo = dir([fileBase fileExt]);
    numSamples = fileInfo.bytes/nChan/bps;

    whlWinLen = winLength*whlSamp/eegSamp;
    hanFilter = hanning(floor(whlWinLen));
    %hanFilter = hanFilter./mean(hanFilter);
    
    drinking = LoadMazeTrialTypes(fileBase, [1 1 1 1 1 1 1 1 1 1 1 1 1],excludeLocations);
    whlData = LoadMazeTrialTypes(fileBase, trialTypesBool,[1 1 1 1 1 1 1 1 1]);
    plot(whlData(find(whlData(:,1)~=-1),1),whlData(find(whlData(:,1)~=-1),2),':y')
    [speedData accelData] = MazeSpeedAccel(whlData);
    
    goodTo = [];
    
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
    if ~isempty(to)
        for i=1:length(to)
            whlIndexStart = round(to(i)*whlSamp/eegSamp+1); % in whl samples starting with 1
            whlIndexEnd = min(size(whlData,1),whlIndexStart+size(hanFilter,1)-1);
            % if: we calculated midpoints
            % we have enough speed measurements to calculate
            % he's not in the excluded areas
            % he's above the minSpeed
            if whlIndexStart>0 & ...
                    whlIndexStart<whlIndexEnd & ...
                    size(find(speedData(whlIndexStart:whlIndexEnd) > -1),1) > 1/2*size(hanFilter,1) & ...
                    (midPointsBool | ...
                    (isempty(find(drinking(whlIndexStart:whlIndexEnd,1) > -1)) & ...
                    isempty(find(speedData(whlIndexStart:whlIndexEnd)<minSpeed & speedData(whlIndexStart:whlIndexEnd)~=-1))))

                %inName = [fileBase  '.eeg'];
                %fprintf('Loading: %s\n' ,inName)
                eegData = bload([fileBase fileExt],[nChan winLength],to(i)*nChan*bps,'int16');
                [thetaY,thetaF]= mtpsd(eegData,winLength*2,eegSamp,winLength,nOverlap,thetaNW,[],[]);
                [gammaY,gammaF]= mtpsd(eegData,winLength*2,eegSamp,winLength,nOverlap,gammaNW,[],[]);
                if  (exist('thetaFo') & thetaFo ~= thetaF) | (exist('gammaFo') & gammaFo ~= gammaF)
                    fprintf('\nPROBLEM fo~=f\n')
                    keyboard
                end
                thetaFo=thetaF;
                gammaFo=gammaF;
                thetaYo = cat(1,thetaYo,permute(thetaY,[3 2 1])); %[f,chan,sample]
                gammaYo = cat(1,gammaYo,permute(gammaY,[3 2 1])); %[f,chan,sample]

                
                %Calculate theta Freq for each Channel (use NW=1)
                [thetaFreqY,thetaFreqF] = mtpsd(eegData,winLength*2,eegSamp,winLength,nOverlap,1,[],[],thetaFreqRange);
                [peakThetaPow, peakThetaInd] = max(thetaFreqY,[],1);
                thetaFreqF = repmat(thetaFreqF,size(peakThetaInd));
                thetaFreq = cat(1,thetaFreq,thetaFreqF(peakThetaInd));
                           
                time = [time; (to(i)+winLength/2)/eegSamp]; % in seconds

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
        %keyboard
        %thetaFreq(end-20:end,35)
        size(thetaYo)
        size(gammaYo)
    end

    thetaPowPeak = squeeze(10.*log10(max(thetaYo(:,:,find(thetaFo>=thetaFreqRange(1) & thetaFo<=thetaFreqRange(2))),[],3)));
    thetaPowIntg = squeeze(10.*log10(sum(thetaYo(:,:,find(thetaFo>=thetaFreqRange(1) & thetaFo<=thetaFreqRange(2))),3)));
    gammaPowPeak = squeeze(10.*log10(max(gammaYo(:,:,find(gammaFo>=gammaFreqRange(1) & gammaFo<=gammaFreqRange(2))),[],3)));
    gammaPowIntg = squeeze(10.*log10(sum(gammaYo(:,:,find(gammaFo>=gammaFreqRange(1) & gammaFo<=gammaFreqRange(2))),3)));

    thetaYo = 10.*log10(thetaYo);
    gammaYo = 10.*log10(gammaYo);

    subplot(2,1,2)
    hold on
    imagesc(1:length(time),thetaFo,squeeze(thetaYo(:,selectedChannels(1),:))');
    set(gca,'clim',[35 70],'ylim',[0 25]);
    colorbar
    plot(1:length(time),thetaFreq(:,selectedChannels(1)),'k')

    if midPointsBool
        midPtext = '_MidPoints';
    else
        midPtext = [];
    end
    saveDir = [mfilename '_' description midPtext '_MinSpeed' num2str(minSpeed) 'Win' num2str(winLength) ...
        'ThetaNW' num2str(thetaNW) 'GammaNW' num2str(gammaNW) fileExt];
    eval(['mkdir ' saveDir])
    infoStruct = setfield(infoStruct,'saveDir',saveDir);
    fprintf('Saving: %s\n',saveDir)
    set(gcf,'name',saveDir);

   
    save([saveDir '/thetaYo.mat'],SaveAsV6,'thetaYo');
    save([saveDir '/thetaFo.mat'],SaveAsV6,'thetaFo');
    save([saveDir '/thetaFreq.mat'],SaveAsV6,'thetaFreq');
    save([saveDir '/gammaYo.mat'],SaveAsV6,'gammaYo');
    save([saveDir '/gammaFo.mat'],SaveAsV6,'gammaFo');
    save([saveDir '/time.mat'],SaveAsV6,'time');
    save([saveDir '/speed.mat'],SaveAsV6,'speed');
    save([saveDir '/accel.mat'],SaveAsV6,'accel');
    save([saveDir '/position.mat'],SaveAsV6,'position');
    save([saveDir '/taskType.mat'],SaveAsV6,'taskType');
    save([saveDir '/trialType.mat'],SaveAsV6,'trialType');
    save([saveDir '/mazeLocation.mat'],SaveAsV6,'mazeLocation');
    save([saveDir '/thetaPowPeak.mat'],SaveAsV6,'thetaPowPeak');
    save([saveDir '/thetaPowIntg.mat'],SaveAsV6,'thetaPowIntg');
    save([saveDir '/gammaPowPeak.mat'],SaveAsV6,'gammaPowPeak');
    save([saveDir '/gammaPowIntg.mat'],SaveAsV6,'gammaPowIntg');
    save([saveDir '/infoStruct.mat'],SaveAsV6,'infoStruct');

    cd ..
end

return
