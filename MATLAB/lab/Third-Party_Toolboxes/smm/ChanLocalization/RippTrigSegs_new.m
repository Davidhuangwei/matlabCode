function RippTrigSegs(fileBaseCell,eegNChan,rippDetChans,rippTrigChan,swTrigChan,fileExt,nChan,varargin)
% function RippTrigSegs(fileBaseCell,eegNChan,rippDetChans,rippTrigChan,swTrigChan,fileExt,nChan,varargin)
% [segLen,segRestriction,chanMat,badChans,plotBool] = DefaultArgs(varargin,{160,'',LoadVar([chanInfoDir 'ChanMat' fileExt '.mat']),...
%     load([chanInfoDir 'BadChan.eeg.txt']),0});

chanInfoDir = 'ChanInfo/';
[segLen,segRestriction,chanMat,badChans,plotBool] = DefaultArgs(varargin,{160,'',LoadVar([chanInfoDir 'ChanMat' fileExt '.mat']),...
    load([chanInfoDir 'BadChan.eeg.txt']),0});
chansPerShank = size(chanMat,1);
nShanks = size(chanMat,2);

eegSamp = 1250;
rippFiltFreqRange = [120 250];
swFiltFreqRange = [5 30];

infoStruct = [];
infoStruct = setfield(infoStruct,'rippFiltFreqRange',rippFiltFreqRange);
infoStruct = setfield(infoStruct,'swFiltFreqRange',swFiltFreqRange);
infoStruct = setfield(infoStruct,'nChan',nChan);
infoStruct = setfield(infoStruct,'eegNChan',eegNChan);
infoStruct = setfield(infoStruct,'swTrigChan',swTrigChan);
infoStruct = setfield(infoStruct,'rippTrigChan',rippTrigChan);
infoStruct = setfield(infoStruct,'rippDetChans',rippDetChans);
infoStruct = setfield(infoStruct,'nShanks',nShanks);
infoStruct = setfield(infoStruct,'chansPerShank',chansPerShank);
infoStruct = setfield(infoStruct,'badChans',badChans);
infoStruct = setfield(infoStruct,'sampRate',eegSamp);
infoStruct = setfield(infoStruct,'fileExt',fileExt);
infoStruct = setfield(infoStruct,'segLen',segLen);
infoStruct = setfield(infoStruct,'segRestriction',segRestriction);
infoStruct.mfilename = mfilename;
infoStruct.date = date;




for k=1:length(fileBaseCell)
    time = [];
    timeInc = [];
    timeExc = [];
    segs = [];
    fileBase = fileBaseCell{k};

    %     [RippleTime, taxis]=ripdetecthsmm([fileBase '/' fileBase],eegNChan,rippDetChans,plotBool); %,Mult,shanknumber,drugconditions,drugtimes)
    [RippleTimeInc, taxis]=ripdetecthsmm([fileBase '/' fileBase],eegNChan,rippDetChans,plotBool,3,4); %,Mult,shanknumber,drugconditions,drugtimes)
    [RippleTimeExc, taxis]=ripdetecthsmm([fileBase '/' fileBase],eegNChan,rippDetChans,plotBool,1,1); %,Mult,shanknumber,drugconditions,drugtimes)
     
    
    fprintf('Reading: %s\n',fileBase);
    swEegTrigChan = readmulti([fileBase '/' fileBase '.eeg'],eegNChan,swTrigChan);
    %swEegTrigChan = readmulti([fileBase '.eeg'],eegNChan,swTrigChan);
    swFilt = fir1(odd(3/swFiltFreqRange(1)*eegSamp)-1,[swFiltFreqRange(1)/eegSamp*2,swFiltFreqRange(2)/eegSamp*2]);
    swfiltTrigChan = Filter0(swFilt, swEegTrigChan);
    
    rippEegTrigChan = readmulti([fileBase '/' fileBase '.eeg'],eegNChan,rippTrigChan);
    %rippEegTrigChan = readmulti([fileBase '.eeg'],eegNChan,rippTrigChan);
    rippFilt = fir1(odd(3/rippFiltFreqRange(1)*eegSamp)-1,[rippFiltFreqRange(1)/eegSamp*2,rippFiltFreqRange(2)/eegSamp*2]);
    rippfiltTrigChan = Filter0(rippFilt, rippEegTrigChan);
 
    if plotBool
        figure(3)
        clf
    end
    for i=1:size(RippleTimeInc,1)
        swMin = LocalMinima(swfiltTrigChan(RippleTimeInc(i,1):RippleTimeInc(i,2)),RippleTimeInc(i,2)-RippleTimeInc(i,1),0);
        rippMin = LocalMinima(rippfiltTrigChan(RippleTimeInc(i,1):RippleTimeInc(i,2)),1/rippFiltFreqRange(2),0);
        if ~isempty(swMin) & ~isempty(rippMin)
            rippMin = LocalMinima(rippfiltTrigChan(RippleTimeInc(i,1):RippleTimeInc(i,2)),1/rippFiltFreqRange(2),0);
            trigCenter = rippMin(find(abs(rippMin-swMin) == min(abs(rippMin-swMin)),1,'first'));
            
            timeInc = [timeInc; (RippleTimeInc(i,1)-1+trigCenter)/eegSamp];
        end
    end
    for i=1:size(RippleTimeExc,1)
        swMin = LocalMinima(swfiltTrigChan(RippleTimeExc(i,1):RippleTimeExc(i,2)),RippleTimeExc(i,2)-RippleTimeExc(i,1),0);
        rippMin = LocalMinima(rippfiltTrigChan(RippleTimeExc(i,1):RippleTimeExc(i,2)),1/rippFiltFreqRange(2),0);
        if ~isempty(swMin) & ~isempty(rippMin)
            rippMin = LocalMinima(rippfiltTrigChan(RippleTimeExc(i,1):RippleTimeExc(i,2)),1/rippFiltFreqRange(2),0);
            trigCenter = rippMin(find(abs(rippMin-swMin) == min(abs(rippMin-swMin)),1,'first'));
            
            timeExc = [timeExc; (RippleTimeExc(i,1)-1+trigCenter)/eegSamp];
        end
    end
    
%     excJunk = round(timeExc*eegSamp);
%     incJunk = round(timeInc*eegSamp);
%     junk1 = zeros(max([excJunk;incJunk]),1);
%     plotInc = junk1;
%     plotInc(incJunk) = 1;
%     plotExc = junk1;
%     plotExc(excJunk) = 1;
%     
%     timeJunk = round(time*eegSamp);
%     plotTime = junk1;
%     plotTime(timeJunk) = 1;
%     
%     plot([1:length(plotExc)]/eegSamp,plotExc,'r')
%     hold on
%     plot([1:length(plotExc)]/eegSamp,plotInc,'b')
%      plot([1:length(plotExc)]/eegSamp,plotTime,'g')
   
    
    switch lower(segRestriction)
        case 'single'
            for i=1:length(timeInc)
                if isempty(find(timeExc~=timeInc(i)...
                        & timeExc>=timeInc(i)-segLen/1000/2 & timeExc<=timeInc(i)+segLen/1000/2))
                    time = cat(1,time,timeInc(i));
                end
            end
        case 'first'
            for i=1:length(timeInc)
                if isempty(find(timeExc~=timeInc(i)...
                        & timeExc>=timeInc(i)-segLen/1000/2 & timeExc<=timeInc(i)))
                    time = cat(1,time,timeInc(i));
                end
            end            
        case 'last'
            for i=1:length(timeInc)
                if isempty(find(timeExc~=timeInc(i)...
                        & timeExc>=timeInc(i) & timeExc<=timeInc(i)+segLen/1000/2))
                    time = cat(1,time,timeInc(i));
                end
            end            
        otherwise 
            time = timeInc;
    end
            
    for i=1:length(time)
        if round(time(i)-segLen/1000/2)*eegSamp*nChan*2 >= 0
            seg = bload([fileBase '/' fileBase fileExt],[nChan round(segLen*eegSamp/1000)],...
                round(time(i)-segLen/1000/2)*eegSamp*nChan*2,'int16');
            if isempty(segs) | size(seg,2) == size(segs,2) % if didn't run off edge of file
                segs = cat(3,segs,seg);
            end
        end
    end
            
   if plotBool
        figure(3)
        hold on
        distance = max(max(mean(segs,3)))-min(min(mean(segs,3)));
        plotSeg = MakeBufferedPlotMat(permute(mean(segs,3),[1,3,2]),chanMat);
        for j=1:size(plotSeg,1)
            plot(plotSeg(j,:)-distance*j,'b');
        end
        stdPlotSeg = MakeBufferedPlotMat(permute(std(segs,[],3),[1,3,2]),chanMat);
        for j=1:size(plotSeg,1)
            plot(plotSeg(j,:)-stdPlotSeg(j,:)-distance*j,'--r');
            plot(plotSeg(j,:)+stdPlotSeg(j,:)-distance*j,'--r');
        end
    end

    infoStruct.fileBase = fileBase;

    outName = [fileBase '/' 'RippTrigSegs_' segRestriction num2str(segLen) fileExt '.mat'];
    fprintf('Saving: %s\n',outName);

    save(outName,SaveAsV6,'segs','time','infoStruct');
end
