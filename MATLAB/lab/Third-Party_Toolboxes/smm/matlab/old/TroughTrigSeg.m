function TroughTrigSeg(taskDesc,fileBaseMat,trigChan,filtFreqRange,maxFreq,varargin)

%function aveSeg = TroughTrigSeg(fileBaseMat,nchan,nShanks,chansPerShank,peakTrigBool,trialTypesBool,mazeRegionsBool)


[nChan,nShanks,chansPerShank,peakTrigBool,trialTypesBool,mazeRegionsBool,plotBool] = DefaultArgs(varargin,{97,6,16,0,...
    [1 0 1 0 0 0 0 0 0 0 0 0 0],[0 0 0 1 1 1 1 1 1],1});

eegSamp = 1250;
whlSamp = 39.065;
fileExt = '.eeg';

figTitle = 'NotesOnCSD2';

badChans = load('BadChanEEG.txt');

info = [];
setfield(info,'taskDesc',taskDesc);
setfield(info,'fileBaseMat',fileBaseMat);
setfield(info,'trigChan',trigChan);
setfield(info,'filtFreqRange',filtFreqRange);
setfield(info,'maxFreq',maxFreq);
setfield(info,'nChan',nChan);
setfield(info,'nShanks',nShanks);
setfield(info,'chansPerShank',chansPerShank);
setfield(info,'peakTrigBool',peakTrigBool);
setfield(info,'trialTypesBool',trialTypesBool);
setfield(info,'mazeRegionsBool',mazeRegionsBool);
setfield(info,'badChans',badChans);
setfield(info,'eegSamp',eegSamp);
setfield(info,'whlSamp',whlSamp);
setfield(info,'fileExt',fileExt);

for k=1:size(fileBaseMat,1)
    taskType = {};
    trialType = [];
    mazeRegion = [];
    segs = [];

    fileBase = fileBaseMat(k,:);
    fprintf('Reading: %s\n',fileBase);
    eegTrigChan = readmulti([fileBase '/' fileBase fileExt],nChan,trigChan);
    firfiltb = fir1(odd(3/filtFreqRange(1)*eegSamp)-1,[filtFreqRange(1)/eegSamp*2,filtFreqRange(2)/eegSamp*2]);
    filtTrigChan = Filter0(firfiltb, eegTrigChan');
    if peakTrigBool
        minsTrigChan = LocalMinima(-filtTrigChan,eegSamp/maxFreq,0);
    else
        minsTrigChan = LocalMinima(filtTrigChan,eegSamp/maxFreq,0);
    end

    whl = LoadMazeTrialTypes([fileBase '/' fileBase],trialTypesBool,mazeRegionsBool);
    points = diff(whl(:,1)~=-1);
    begining = find(points==1);
    ending = find(points==-1);

    eegBegin = round(begining*eegSamp/whlSamp);
    eegEnd = round(ending*eegSamp/whlSamp);

    interv = round(2/filtFreqRange(1)*eegSamp); % at least 2 cycles
    for j=1:length(eegBegin)
        goodPoints = find(minsTrigChan>eegBegin(j));
        begining = goodPoints(1);
        goodPoints = find(minsTrigChan<eegEnd(j));
        ending = goodPoints(end);
        for i=begining:ending
            eegSeg = bload([fileBase '/' fileBase '.eeg'],[nChan interv],round(minsTrigChan(i)-interv/2)*nChan*2,'int16');
            [task, trial, region] = ...
                GetTrialInfo([fileBase '/' fileBase],round((minsTrigChan(i)-interv/2:minsTrigChan(i)+interv/2).*whlSamp./eegSamp));
            taskType = [taskType; {task}];
            trialType = [trialType; trial];
            mazeRegion = [mazeRegion; region];
            filtSeg = Filter0(firfiltb, eegSeg');
            segs = cat(3,segs,filtSeg');
        end
    end
    keyboard
    outName = [fileBase '/' taskDesc '_TroughTrigSeg_trigCh' num2str(trigChan) '_freq' num2str(filtFreqRange(1)) '-' num2str(filtFreqRange(2)) ...
        '_maxFreq' num2str(maxFreq) '_' fileExt(2:end) '.mat'];
    fprintf('Saving: %s\n',outName);

    save(outName,SaveAsV6,'segs','taskType','trialType','mazeRegion',info');
 
    
    if plotBool
        aveSeg = mean(segs,3);
        stdSeg = squeeze(std(permute(segs,[3 1 2])));

        figure(1)
        clf
        set(gca,'xlim',[1 eegEnd(1)-eegBegin(1)+1].*1000./eegSamp)
        hold on
        %plot([eegBegin(1):eegEnd(1)],eegTrigChan(eegBegin(1):eegEnd(1)))
        plot([1:eegEnd(1)-eegBegin(1)+1].*1000./eegSamp,eegTrigChan(eegBegin(1):eegEnd(1)))
        plot([1:eegEnd(1)-eegBegin(1)+1].*1000./eegSamp,filtTrigChan(eegBegin(1):eegEnd(1)),'g')

        plotMins = find(minsTrigChan>=eegBegin(1) & minsTrigChan<=eegEnd(1));
        plot([minsTrigChan(plotMins)-eegBegin(1)+1].*1000./eegSamp,ones(length(plotMins)),'r.')

        shift = 2*max(abs(aveSeg(trigChan,:)+stdSeg(trigChan,:)));
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
                set(gca,'ylim',[-(chansPerShank+1)*shift 0],'xlim',[0 interv],'ytick',[],...
                    'xtick',[0,(interv+1)/2,interv],'xticklabel',[-interv/2/eegSamp*1000 0 interv/2/eegSamp*1000]);
            end
        end
    end
end

