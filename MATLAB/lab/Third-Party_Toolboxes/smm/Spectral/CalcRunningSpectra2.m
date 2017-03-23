function CalcRunningSpectra2(taskType,fileBaseMat,fileExt,nChan,channels,winLength,nOverlap,NW,varargin)
% function CalcRunningSpectra(taskType,fileBaseMat,fileExt,channels,winLength,nOverlap,NW,trialTypesBool,excludeLocations,minSpeed,spectraDir)

[trialTypesBool,excludeLocations,minSpeed,spectraDir] = DefaultArgs(varargin,{[1 1 1 1 1 1 1 1 1 1 1 1 1],[1 1 1 0 0 0 0 0 0],0,'spectrograms/'});


yo = [];
tempYo = [];
figure(1);
clf
hold on;




lags = -1500:50:1500;
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
    [speed accel] = MazeSpeedAccel(whldata);
    
    goodTo = [];
    
    for i=0:winLength:numSamples
        whlIndexStart = round(i*whlSamp/eegSamp+1);
        whlIndexEnd = min(size(whldata,1),whlIndexStart+size(hanFilter,1)-1);
        % if: we have enough speed measurements to calculate
        % he's not in the excluded areas
        % he's above the minSpeed
        if size(find(speed(whlIndexStart:whlIndexEnd) > -1),1) > 1/2*size(hanFilter,1) & ... 
                isempty(find(drinking(whlIndexStart:whlIndexEnd,1) > -1)) & ... 
                isempty(find(speed(whlIndexStart:whlIndexEnd)<minSpeed & speed(whlIndexStart:whlIndexEnd)~=-1)) 
               
            %inName = [fileBaseMat(j,:)  '.eeg'];
            %fprintf('Loading: %s\n' ,inName)
            eegData = bload([fileBaseMat(j,:) fileExt],[nChan winLength],i*nChan*bps,'int16');
            [y,f]= mtpsd(eegData,winLength*2,eegSamp,winLength,nOverlap,NW);
            if  exist('fo') & fo ~= f
                fprintf('\nPROBLEM fo~=f\n')
                keyboard
            end
            fo=f;
            yo = cat(3,yo,y(find(f>=yoFreqRange(1) & f<=yoFreqRange(2)),:)); %[f,chan,sample]
                        
            times = [times, (i+winLength/2)/eegSamp]; % in seconds
             
            [thisTaskType, thisTrialType, thisMazeLoc] = GetTrialInfo(fileBase,whlIndexStart:whlIndexEnd);      
            taskTypes = cat(1,taskTypes,{thisTaskType});
            trialTypes = cat(1,trialTypes,thisTrialType);
            mazeLocations = cat(1,mazeLocations,thisMazeLoc);
            fileNames = cat(1,fileNames,{fileBaseMat(j,:)});
            
            plot(whldata(whlIndexStart:whlIndexEnd,1),whldata(whlIndexStart:whlIndexEnd,2),'k.');
            
            for k=1:length(lags)
                lag = lags(k);             
                whlIndexStart = round(whlSamp*(i/eegSamp+lag/1000)+1);
                whlIndexEnd = whlIndexStart+size(hanFilter,1)-1;
                if whlIndexStart<1 | whlIndexEnd>size(speed,1)
                    fprintf('error_beyond_border_of_file: time=%i, interval=%i\n',i/eegSamp,lag);
                    aveSpeed = NaN;
                    aveAccel = NaN;
                    position = [NaN NaN NaN NaN];
                else
                    speedSeg = speed(whlIndexStart:whlIndexEnd);
                    accelSeg = accel(whlIndexStart:whlIndexEnd);
                    indexes = speedSeg >= 0;
                    
                    
                    if isempty(find(indexes>0))
                        fprintf('error_speed_cant_be_reliably_measured: time=%i, interval=%i\n',i/eegSamp,lag);
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
            end
        end
    end 
    size(yo)
end
%[f,chan,sample]
thetaFreqRange = [5 10];
gammaFreqRange = [65 85];

thetaPowPeak = zeros(size(yo,2),size(yo,3));
thetaPowIntg = zeros(size(yo,2),size(yo,3));
gammaPowPeak = zeros(size(yo,2),size(yo,3));
gammaPowIntg = zeros(size(yo,2),size(yo,3));

for i=1:size(yo,2) %channels
    for j=1:size(yo,3) %samples
        thetaPowPeak(i,j) = 10.*log10(max(yo(find(fo>=thetaFreqRange(1) & fo<=thetaFreqRange(2)),i,j)));
        thetaPowIntg(i,j) = 10.*log10(sum(yo(find(fo>=thetaFreqRange(1) & fo<=thetaFreqRange(2)),i,j)));
        gammaPowPeak(i,j) = 10.*log10(max(yo(find(fo>=gammaFreqRange(1) & fo<=gammaFreqRange(2)),i,j)));
        gammaPowIntg(i,j) = 10.*log10(sum(yo(find(fo>=gammaFreqRange(1) & fo<=gammaFreqRange(2)),i,j)));
    end
end
yo = 10.*log10(yo);

outName = [taskType '_MazeMeas_MinSpeed' num2str(minSpeed) 'Win' num2str(winLength) 'NW' num2str(NW) '.mat'];
fprintf('Saving: %s\n',outName)

mazeMeasStruct = [];
mazeMeasStruct = setfield(mazeMeasStruct,'yo',yo);
mazeMeasStruct = setfield(mazeMeasStruct,'fo',fo);
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
mazeMeasStruct = setfield(mazeMeasStruct,'info','channels',channels);
mazeMeasStruct = setfield(mazeMeasStruct,'info','NW',NW);
mazeMeasStruct = setfield(mazeMeasStruct,'info','winLength',winLength);
mazeMeasStruct = setfield(mazeMeasStruct,'info','nOverlap',nOverlap);
mazeMeasStruct = setfield(mazeMeasStruct,'info','minSpeed',minSpeed);
mazeMeasStruct = setfield(mazeMeasStruct,'info','trialTypesBool',trialTypesBool);
mazeMeasStruct = setfield(mazeMeasStruct,'info','excludeLocations',excludeLocations);
mazeMeasStruct = setfield(mazeMeasStruct,'info','fileBaseMat',fileBaseMat);
mazeMeasStruct = setfield(mazeMeasStruct,'info','fileExt',fileExt);
mazeMeasStruct = setfield(mazeMeasStruct,'info','saveName',outName);

save(outName, 'mazeMeasStruct');
return
