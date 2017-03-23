function CalcRunningSpectra3(taskType,fileBaseMat,fileExt,nChan,winLength,nOverlap,midPointsBool,thetaNW,thetaFreqRange,gammaNW,gammaFreqRange,varargin)

[trialTypesBool,excludeLocations,minSpeed,spectraDir] = DefaultArgs(varargin,{[1 1 1 1 1 1 1 1 1 1 1 1 1],[1 1 1 0 0 0 0 0 0],0,'spectrograms/'});


thetaYo = [];
gammaYo = [];
tempYo = [];
figure;
hold on;



addpath /u12/antsiro/matlab/General

lags = -1500:50:1500;
thetaFreq = [];
speeds = [];
accels = [];
times = [];
position = [];
taskTypes = {};
trialTypes = [];
mazeLocations = [];
fileNames = [];
positions = [];
whlSamp = 39.065;
eegSamp = 1250;
bps = 2;
yoFreqRange = [0 120];

for j=1:size(fileBaseMat,1)
    fileBase = fileBaseMat(j,:);
    
    %inName = [spectraDir fileBaseMat(j,:) fileExt 'Win' num2str(winLength) 'Ovrlp' num2str(nOverlap) 'NW' num2str(NW) '_mtpsg_' num2str(channels(1)) '.mat'];
    %fprintf('Loading: %s\n' ,inName)
    %load(inName);
         
   
    infoStruct = dir([fileBaseMat(j,:) fileExt]);
    numSamples = infoStruct.bytes/nChan/bps;

    whlWinLen = winLength*whlSamp/eegSamp;
    hanFilter = hanning(floor(whlWinLen));
    %hanFilter = hanFilter./mean(hanFilter);
    
    drinking = LoadMazeTrialTypes(fileBase, [1 1 1 1 1 1 1 1 1 1 1 1 1],excludeLocations);
    whldata = LoadMazeTrialTypes(fileBase, trialTypesBool,[1 1 1 1 1 1 1 1 1]);
    plot(whldata(find(whldata(:,1)~=-1),1),whldata(find(whldata(:,1)~=-1),2),':y')
    [speed accel] = MazeSpeedAccel(whldata);
    
    goodTo = [];
    
    if midPointsBool
        trialMidsStruct = CalcFileMidPoints(fileBaseMat(j,:),0,trialTypesBool);
        mazeRegionNames = fieldnames(getfield(trialMidsStruct,fileBaseMat(j,:)));
        to = [];
        for i=1:size(mazeRegionNames,1)
            to = [to getfield(trialMidsStruct,fileBaseMat(j,:),mazeRegionNames{i})];
        end
        to = round(sort(to-1)*eegSamp/whlSamp-winLength/2); % in eeg samples starting with 0
    else
        to = 0:winLength:numSamples; % in in eeg samples starting with 0
    end
    if ~isempty(to)
        for i=1:length(to)
            whlIndexStart = round(to(i)*whlSamp/eegSamp+1); % in whl samples starting with 1
            whlIndexEnd = min(size(whldata,1),whlIndexStart+size(hanFilter,1)-1);
            % if: we calculated midpoints
            % we have enough speed measurements to calculate
            % he's not in the excluded areas
            % he's above the minSpeed
            if whlIndexStart>0 & ...
                    whlIndexStart<whlIndexEnd & ...
                    size(find(speed(whlIndexStart:whlIndexEnd) > -1),1) > 1/2*size(hanFilter,1) & ...
                    (midPointsBool | ...
                    (isempty(find(drinking(whlIndexStart:whlIndexEnd,1) > -1)) & ...
                    isempty(find(speed(whlIndexStart:whlIndexEnd)<minSpeed & speed(whlIndexStart:whlIndexEnd)~=-1))))

                %inName = [fileBaseMat(j,:)  '.eeg'];
                %fprintf('Loading: %s\n' ,inName)
                eegData = bload([fileBaseMat(j,:) fileExt],[nChan winLength],to(i)*nChan*bps,'int16');
                [thetaY,thetaF]= mtpsd(eegData,winLength*2,eegSamp,winLength,nOverlap,thetaNW);
                [gammaY,gammaF]= mtpsd(eegData,winLength*2,eegSamp,winLength,nOverlap,gammaNW);
                
                %Calculate theta Freq for each Channel (use NW=1)
                [thetaFreqY,thetaFreqF] = mtpsd(eegData,winLength*2,eegSamp,winLength,nOverlap,1);
                peakThetaPow = max(thetaFreqY(thetaFreqF>=thetaFreqRange(1) & thetaFreqF<=thetaFreqRange(2),:),[],1);
                for k=1:nChan
                    peakFreqIndexes(:,k) = find(thetaFreqY(:,k)==peakThetaPow(k));
                end
                thetaFreq = [thetaFreq, thetaFreqF(peakFreqIndexes(1,:))];
                
                
                thetaF = thetaF(find(thetaF>=yoFreqRange(1) & thetaF<=yoFreqRange(2)));
                gammaF = gammaF(find(gammaF>=yoFreqRange(1) & gammaF<=yoFreqRange(2)));
                if  (exist('thetaFo') & thetaFo ~= thetaF) | (exist('gammaFo') & gammaFo ~= gammaF)
                    fprintf('\nPROBLEM fo~=f\n')
                    keyboard
                end
                thetaFo=thetaF;
                gammaFo=gammaF;
                thetaYo = cat(3,thetaYo,thetaY(find(thetaF>=yoFreqRange(1) & thetaF<=yoFreqRange(2)),:)); %[f,chan,sample]
                gammaYo = cat(3,gammaYo,gammaY(find(gammaF>=yoFreqRange(1) & gammaF<=yoFreqRange(2)),:)); %[f,chan,sample]

                times = [times, (to(i)+winLength/2)/eegSamp]; % in seconds

                [thisTaskType, thisTrialType, thisMazeLoc] = GetTrialInfo(fileBase,whlIndexStart:whlIndexEnd);
                taskTypes = cat(1,taskTypes,{thisTaskType});
                trialTypes = cat(1,trialTypes,thisTrialType);
                mazeLocations = cat(1,mazeLocations,thisMazeLoc);
                fileNames = cat(1,fileNames,{fileBaseMat(j,:)});

                plot(whldata(whlIndexStart:whlIndexEnd,1),whldata(whlIndexStart:whlIndexEnd,2),'k');

                for k=1:length(lags)
                    lag = lags(k);
                    whlIndexStart = round(whlSamp*(to(i)/eegSamp+lag/1000)+1);
                    whlIndexEnd = whlIndexStart+size(hanFilter,1)-1;
                    if whlIndexStart<1 | whlIndexEnd>size(speed,1)
                        fprintf('error_beyond_border_of_file: time=%i, interval=%i\n',to(i)/eegSamp,lag);
                        aveSpeed = NaN;
                        aveAccel = NaN;
                        position = [NaN NaN NaN NaN];
                    else
                        speedSeg = speed(whlIndexStart:whlIndexEnd);
                        accelSeg = accel(whlIndexStart:whlIndexEnd);
                        indexes = speedSeg >= 0;


                        if isempty(find(indexes>0))
                            %fprintf('error_speed_cant_be_reliably_measured: time=%i, interval=%i\n',to(i)/eegSamp,lag);
                            aveSpeed = NaN;
                            aveAccel = NaN;
                            position = [NaN NaN NaN NaN];
                        else
                            normHanFilter = hanFilter./mean(hanFilter(indexes)); % normalize the hanning filter
                            speedSeg = normHanFilter.*speedSeg;
                            accelSeg = normHanFilter.*accelSeg;

                            aveSpeed = mean(speedSeg(indexes));
                            aveAccel = mean(accelSeg(indexes));

                            position = whldata(floor(whlIndexStart+size(hanFilter,1)/2),:);
                        end
                    end
                    %keyboard
                    if lag<0
                        speeds = setfield(speeds,['n' num2str(abs(lag))],{length(times)},aveSpeed);
                        accels = setfield(accels,['n' num2str(abs(lag))],{length(times)},aveAccel);
                        positions = setfield(positions,['n' num2str(abs(lag))],{length(times),1:4},position);
                    else
                        speeds = setfield(speeds,['p' num2str(abs(lag))],{length(times)},aveSpeed);
                        accels = setfield(accels,['p' num2str(abs(lag))],{length(times)},aveAccel);
                        positions = setfield(positions,['p' num2str(abs(lag))],{length(times),1:4},position);
                    end
                    if lag==0
                        plot(position(1),position(2),'r.');
                    end

                end
            end
        end
        %keyboard
        %thetaFreq(end-20:end,35)
        size(thetaYo)
        size(gammaYo)
    end
end
    %[f,chan,sample]
%thetaFreqRange = [5 11];
%gammaFreqRange = [65 100];
%keyboard
thetaPowPeak = zeros(size(thetaYo,2),size(thetaYo,3));
thetaPowIntg = zeros(size(thetaYo,2),size(thetaYo,3));
gammaPowPeak = zeros(size(gammaYo,2),size(gammaYo,3));
gammaPowIntg = zeros(size(gammaYo,2),size(gammaYo,3));

for i=1:size(thetaYo,2) %channels
    for j=1:size(thetaYo,3) %samples
        thetaPowPeak(i,j) = 10.*log10(max(thetaYo(find(thetaFo>=thetaFreqRange(1) & thetaFo<=thetaFreqRange(2)),i,j)));
        thetaPowIntg(i,j) = 10.*log10(sum(thetaYo(find(thetaFo>=thetaFreqRange(1) & thetaFo<=thetaFreqRange(2)),i,j)));
    end
end
for i=1:size(gammaYo,2) %channels
    for j=1:size(gammaYo,3) %samples
        gammaPowPeak(i,j) = 10.*log10(max(gammaYo(find(gammaFo>=gammaFreqRange(1) & gammaFo<=gammaFreqRange(2)),i,j)));
        gammaPowIntg(i,j) = 10.*log10(sum(gammaYo(find(gammaFo>=gammaFreqRange(1) & gammaFo<=gammaFreqRange(2)),i,j)));
    end
end

thetaYo = 10.*log10(thetaYo);
gammaYo = 10.*log10(gammaYo);

if midPointsBool
    midPtext = '_midPoints';
else
    midPtext = [];
end
outName = [taskType midPtext '_MazeMeas_MinSpeed' num2str(minSpeed) 'Win' num2str(winLength) ...
    'thetaNW' num2str(thetaNW) 'gammaNW' num2str(gammaNW) '.mat'];
fprintf('Saving: %s\n',outName)

mazeMeasStruct = [];
mazeMeasStruct = setfield(mazeMeasStruct,'thetaYo',thetaYo);
mazeMeasStruct = setfield(mazeMeasStruct,'thetaFo',thetaFo);
mazeMeasStruct = setfield(mazeMeasStruct,'thetaFreq',thetaFreq);
mazeMeasStruct = setfield(mazeMeasStruct,'gammaYo',gammaYo);
mazeMeasStruct = setfield(mazeMeasStruct,'gammaFo',gammaFo);
mazeMeasStruct = setfield(mazeMeasStruct,'time',times);
mazeMeasStruct = setfield(mazeMeasStruct,'speed',speeds);
mazeMeasStruct = setfield(mazeMeasStruct,'accel',accels);
mazeMeasStruct = setfield(mazeMeasStruct,'position',positions);
mazeMeasStruct = setfield(mazeMeasStruct,'fileName',fileNames);
mazeMeasStruct = setfield(mazeMeasStruct,'taskType',taskTypes);
mazeMeasStruct = setfield(mazeMeasStruct,'trialType',trialTypes);
mazeMeasStruct = setfield(mazeMeasStruct,'mazeLocation',mazeLocations);
mazeMeasStruct = setfield(mazeMeasStruct,'thetaPowPeak',thetaPowPeak);
mazeMeasStruct = setfield(mazeMeasStruct,'thetaPowIntg',thetaPowIntg);
mazeMeasStruct = setfield(mazeMeasStruct,'gammaPowPeak',gammaPowPeak);
mazeMeasStruct = setfield(mazeMeasStruct,'gammaPowIntg',gammaPowIntg);
%mazeMeasStruct = setfield(mazeMeasStruct,'info','channels',channels);
mazeMeasStruct = setfield(mazeMeasStruct,'info','thetaNW',thetaNW);
mazeMeasStruct = setfield(mazeMeasStruct,'info','gammaNW',gammaNW);
mazeMeasStruct = setfield(mazeMeasStruct,'info','winLength',winLength);
mazeMeasStruct = setfield(mazeMeasStruct,'info','nOverlap',nOverlap);
mazeMeasStruct = setfield(mazeMeasStruct,'info','minSpeed',minSpeed);
mazeMeasStruct = setfield(mazeMeasStruct,'info','trialTypesBool',trialTypesBool);
mazeMeasStruct = setfield(mazeMeasStruct,'info','excludeLocations',excludeLocations);
mazeMeasStruct = setfield(mazeMeasStruct,'info','fileBaseMat',fileBaseMat);
mazeMeasStruct = setfield(mazeMeasStruct,'info','fileExt',fileExt);
mazeMeasStruct = setfield(mazeMeasStruct,'info','saveName',outName);
mazeMeasStruct = setfield(mazeMeasStruct,'info','thetaFreqRange',thetaFreqRange);
mazeMeasStruct = setfield(mazeMeasStruct,'info','gammaFreqRange',gammaFreqRange);

save(outName, 'mazeMeasStruct');
return
