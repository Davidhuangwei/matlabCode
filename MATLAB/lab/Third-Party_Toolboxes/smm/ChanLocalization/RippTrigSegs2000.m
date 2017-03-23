function RippTrigSegs2000(fileBaseCell,eegNChan,rippDetChans,rippTrigChan,swTrigChan,fileExt,nChan,varargin)
% function RippTrigSegs(fileBaseCell,eegNChan,rippDetChans,rippTrigChan,swTrigChan,fileExt,nChan,varargin)
% [chanMat,badChans,plotBool] = DefaultArgs(varargin,{LoadVar([chanInfoDir 'ChanMat' fileExt '.mat']),...
%     load([chanInfoDir 'BadChan.eeg.txt']),0});

chanInfoDir = 'ChanInfo/';
[chanMat,badChans,plotBool] = DefaultArgs(varargin,{LoadVar([chanInfoDir 'ChanMat' fileExt '.mat']),...
    load([chanInfoDir 'BadChan.eeg.txt']),0});
chansPerShank = size(chanMat,1);
nShanks = size(chanMat,2);

eegSamp = 1250;
segLen = 2000;
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
infoStruct.mfilename = mfilename;
infoStruct.date = date;




for k=1:length(fileBaseCell)
    time = [];
    segs = [];
    fileBase = fileBaseCell{k};

    [RippleTime, taxis]=ripdetecthsmm([fileBase '/' fileBase],eegNChan,rippDetChans,plotBool); %,Mult,shanknumber,drugconditions,drugtimes)

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
    for i=1:size(RippleTime,1)
        swMin = LocalMinima(swfiltTrigChan(RippleTime(i,1):RippleTime(i,2)),RippleTime(i,2)-RippleTime(i,1),0);
        rippMin = LocalMinima(rippfiltTrigChan(RippleTime(i,1):RippleTime(i,2)),1/rippFiltFreqRange(2),0);
        if ~isempty(swMin) & ~isempty(rippMin)
            rippMin = LocalMinima(rippfiltTrigChan(RippleTime(i,1):RippleTime(i,2)),1/rippFiltFreqRange(2),0);
            trigCenter = rippMin(find(abs(rippMin-swMin) == min(abs(rippMin-swMin)),1,'first'));

            seg = bload([fileBase '/' fileBase fileExt],[nChan segLen],round(RippleTime(i,1)-1+trigCenter-segLen/2)*nChan*2,'int16');
            %seg = bload([ fileBase fileExt],[nChan segLen],round(RippleTime(i,1)-1+trigCenter-segLen/2)*nChan*2,'int16');
            segs = cat(3,segs,seg);
            time = [time; (RippleTime(i,1)-1+trigCenter)/eegSamp];
%             if plotBool
%                 figure(3)
%                 hold on
%                 plotSeg = MakeBufferedPlotMat(permute(seg,[1,3,2]),chanMat);
%                 for j=1:size(plotSeg,1)
%                     plot(plotSeg(j,:)-6000*j);
%                 end
%              end
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

    outName = [fileBase '/' 'RippTrigSegs2000' fileExt '.mat'];
    fprintf('Saving: %s\n',outName);

    save(outName,SaveAsV6,'segs','time','infoStruct');
end
