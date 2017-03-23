function TroughTrigSegs(saveBaseName,fileBaseCell,eegNChan,eegTrigChan,filtFreqRange,maxFreq,fileExt,nChan,varargin)
% function TroughTrigSegs(fileBaseCell,eegTrigChan,filtFreqRange,maxFreq,fileExt,nChan,varargin)
% [eegNChan,chanMat,badChans,peakTrigBool,trialTypesBool,mazeRegionsBool,plotBool] = DefaultArgs(varargin,...
%     {97,LoadVar([chanInfoDir 'ChanMat' fileExt '.mat']),load([chanInfoDir 'BadChan.eeg.txt']),...

chanInfoDir = 'ChanInfo/';
[chanMat,badChans,peakTrigBool,trialTypesBool,mazeRegionsBool,plotBool] = DefaultArgs(varargin,...
    {LoadVar([chanInfoDir 'ChanMat' fileExt '.mat']),load([chanInfoDir 'BadChan.eeg.txt']),...
    0,[1 1 1 1 1 1 1 1 1 1 1 1 0],[0 0 0 1 1 1 1 1 1],0});

chansPerShank = size(chanMat,1);
nShanks = size(chanMat,2);
eegSamp = 1250;
whlSamp = 39.065;
segLen = round(2/filtFreqRange(1)*eegSamp); % at least 2 cycles

infoStruct = [];
infoStruct = setfield(infoStruct,'fileBaseCell',fileBaseCell);
infoStruct = setfield(infoStruct,'eegTrigChan',eegTrigChan);
infoStruct = setfield(infoStruct,'filtFreqRange',filtFreqRange);
infoStruct = setfield(infoStruct,'maxFreq',maxFreq);
infoStruct = setfield(infoStruct,'nChan',nChan);
infoStruct = setfield(infoStruct,'eegNChan',eegNChan);
infoStruct = setfield(infoStruct,'nShanks',nShanks);
infoStruct = setfield(infoStruct,'chansPerShank',chansPerShank);
infoStruct = setfield(infoStruct,'peakTrigBool',peakTrigBool);
infoStruct = setfield(infoStruct,'trialTypesBool',trialTypesBool);
infoStruct = setfield(infoStruct,'mazeRegionsBool',mazeRegionsBool);
infoStruct = setfield(infoStruct,'badChans',badChans);
infoStruct = setfield(infoStruct,'sampRate',eegSamp);
infoStruct = setfield(infoStruct,'whlSamp',whlSamp);
infoStruct = setfield(infoStruct,'fileExt',fileExt);
infoStruct = setfield(infoStruct,'segLen',segLen);
%infoStruct = setfield(infoStruct,'description',description);
infoStruct.mfilename = mfilename;
infoStruct.date = date;


for k=1:length(fileBaseCell)
    taskType = {};
    trialType = [];
    mazeRegion = [];
    time = [];
    segs = [];

    fileBase = fileBaseCell{k};
    fprintf('Reading: %s\n',fileBase);
    eegTrigChanData = readmulti([fileBase '/' fileBase '.eeg'],eegNChan,eegTrigChan);
    firfiltb = fir1(odd(3/filtFreqRange(1)*eegSamp)-1,[filtFreqRange(1)/eegSamp*2,filtFreqRange(2)/eegSamp*2]);
    filtTrigChan = Filter0(firfiltb, eegTrigChanData');
    if peakTrigBool
        minsTrigChan = LocalMinima(-filtTrigChan,eegSamp/maxFreq,0);
    else
        minsTrigChan = LocalMinima(filtTrigChan,eegSamp/maxFreq,0);
    end
    
    whl = LoadMazeTrialTypes([fileBase '/' fileBase],trialTypesBool,mazeRegionsBool);
    
    minsTrigChan = minsTrigChan(find((whl(clip(floor(minsTrigChan*whlSamp/eegSamp),1,size(whl,1)),1) ~= -1) & ...
        (minsTrigChan-segLen/2>1) & (minsTrigChan+segLen/2<length(eegTrigChanData))));
    for i=1:length(minsTrigChan)
            seg = bload([fileBase '/' fileBase fileExt],[nChan segLen],round(minsTrigChan(i)-segLen/2)*nChan*2,'int16');
            [task, trial, region] = ...
                GetTrialInfo([fileBase '/' fileBase],round((minsTrigChan(i)-segLen/2:minsTrigChan(i)+segLen/2).*whlSamp./eegSamp));
            taskType = [taskType; {task}];
            trialType = [trialType; trial];
            mazeRegion = [mazeRegion; region];
            time = [time; minsTrigChan(i)/eegSamp];
            filtSeg = Filter0(firfiltb, seg')';
            segs = cat(3,segs,filtSeg);
    end
    infoStruct.fileBase = fileBase;
    outName = [fileBase '/TroughTrigSegs_' saveBaseName  '_freq' num2str(filtFreqRange(1)) '-' num2str(filtFreqRange(2)) ...
        '_maxFreq' num2str(maxFreq) fileExt '.mat'];
    fprintf('Saving: %s\n',outName);

    save(outName,SaveAsV6,'segs','taskType','trialType','mazeRegion','time','infoStruct');
 
    
    if plotBool
        aveSeg = mean(segs,3);
        stdSeg = squeeze(std(permute(segs,[3 1 2])));

        figure(1)
        clf
        %set(gca,'xlim',[1 eegEnd(1)-eegBegin(1)+1].*1000./eegSamp)
        hold on
        plot(eegTrigChanData(minsTrigChan(1):minsTrigChan(10)))
        plot(filtTrigChan(minsTrigChan(1):minsTrigChan(10)),'g')
        plot(minsTrigChan(1:10)-minsTrigChan(1)+1,ones(size(minsTrigChan(1:10))),'.r')
        %plot([eegBegin(1):eegEnd(1)],eegTrigChanData(eegBegin(1):eegEnd(1)))
        %plot([1:eegEnd(1)-eegBegin(1)+1].*1000./eegSamp,eegTrigChanData(eegBegin(1):eegEnd(1)))
        %plot([1:eegEnd(1)-eegBegin(1)+1].*1000./eegSamp,filtTrigChan(eegBegin(1):eegEnd(1)),'g')

        %plotMins = find(minsTrigChan>=eegBegin(1) & minsTrigChan<=eegEnd(1));
        %plot([minsTrigChan(plotMins)-eegBegin(1)+1].*1000./eegSamp,ones(length(plotMins)),'r.')

       % plot(eegSeg(eegTrigChan,:))
        %plot(filtSeg(eegTrigChan,:),'g')
        %plot(minsTrigChan(find(minsTrigChan>minsTrigChan(end)-segLen/2 & minsTrigChan<minsTrigChan(end)+segLen/2))-minsTrigChan(end),...
        %    ones(size(minsTrigChan(find(minsTrigChan>minsTrigChan(end)-segLen/2 & minsTrigChan<minsTrigChan(end)+segLen/2)))),'.r')
        
        shift = 2*max(abs(aveSeg(eegTrigChan,:)+stdSeg(eegTrigChan,:)));
        if 1
            figure(2)
            clf
            for j=0:1:nShanks-1
                plotChans = j*chansPerShank+1:(j+1)*chansPerShank;
                subplot(1,nShanks,j+1)
                for i=1:length(plotChans)
                    hold on
                    if isempty(find(plotChans(i)==badChans))
                        plot(aveSeg(plotChans(i),:)-i*shift)
                        plot(aveSeg(plotChans(i),:)+stdSeg(plotChans(i),:)-i*shift,'--r')
                        plot(aveSeg(plotChans(i),:)-stdSeg(plotChans(i),:)-i*shift,'--r')
                    else
                        plot(aveSeg(plotChans(i),:)-i*shift,'color',[0 0 0])
                        plot(aveSeg(plotChans(i),:)+stdSeg(plotChans(i),:)-i*shift,'--','color',[0.5 0.5 0.5])
                        plot(aveSeg(plotChans(i),:)-stdSeg(plotChans(i),:)-i*shift,'--','color',[0.5 0.5 0.5])
                    end
                end
                set(gca,'ylim',[-(chansPerShank+1)*shift 0],'xlim',[0 segLen],'ytick',[],...
                    'xtick',[0,(segLen+1)/2,segLen],'xticklabel',[-segLen/2/eegSamp*1000 0 segLen/2/eegSamp*1000]);
            end
        end
    end
end

