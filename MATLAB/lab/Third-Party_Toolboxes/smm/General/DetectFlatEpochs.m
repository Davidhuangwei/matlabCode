% function DetectFlatEpochs(fileBaseCell,fileExt,nChan,varargin)
% Finds flat epochs caused by datamax system skipping samples from one or
% more of it's a/d cards. Seems to be due to transferring large files 
% over Samba without correct option for large files.
% Uses the fact that these flat epochs occur
% simultaneously on all channels on one or more a/d cards.  
% Uses the fact that std of all chans on an a/d card drops to 0 during 
% flat epochs.
% OUTPUT: an epochs file for each channel in [fileBase '/FlatEpochs/'] 
% directory and an single file [fileBase '/' fileBase fileExt '.flat.txt'] 
% with the union of all epochs.
%
% chanPerGroup = 8;
% nGroups = ceil(nChan/chanPerGroup);
% for j=0:nGroups-1
%     channelGroups{j+1} = [j*chanPerGroup+1:min([(j+1)*chanPerGroup nChan])];
% end
% if strcmp(fileExt,'.dat')
%     edgeBuffer = 0;
% end
% if strcmp(fileExt,'.eeg')
%     edgeBuffer = 10; % to account for filtering of .dat->.eeg
% end
% [channelGroups edgeBuffer bps] = DefaultArgs(varargin,{channelGroups,edgeBuffer,2});

function DetectFlatEpochs(fileBaseCell,fileExt,nChan,varargin)
chanPerGroup = 8;
nGroups = ceil(nChan/chanPerGroup);
for j=0:nGroups-1
    channelGroups{j+1} = [j*chanPerGroup+1:min([(j+1)*chanPerGroup nChan])];
end
if strcmp(fileExt,'.dat')
    edgeBuffer = 0;
    Fs = 20000;
elseif strcmp(fileExt,'.eeg')
    edgeBuffer = 10; % to account for filtering of .dat->.eeg
    Fs = 1250;
else
    edgeBuffer = [];
    Fs = [];
end
[channelGroups edgeBuffer Fs plotBool bps] = DefaultArgs(varargin,{channelGroups,edgeBuffer,Fs,1,2});

prevWarn = SetWarnings({'off','MATLAB:MKDIR:DirectoryExists'});
bufferSize = 2^floor(log2(30000000/nChan/bps));% up to 30MB buffer (divisible by nchannels)

for j=1:length(fileBaseCell)
    fileBase = fileBaseCell{j};
    fprintf('%s: ',fileBase)

    readPos = 0;
    infoStruct = dir([fileBase '/' fileBase fileExt]);
    numSamples = infoStruct.bytes/nChan/bps;
    
    flatEEG = cell(size(channelGroups));
    while readPos <= numSamples
        eeg = bload([fileBase '/' fileBase fileExt],[nChan bufferSize],...
            readPos*nChan*bps);
        
        for k=1:length(channelGroups)
            % std of all chans on an a/d card drops to 0 during flat epochs
            eegStdDiff = [0; diff(std(eeg(channelGroups{k},:),[],1) == 0)'];
            epochsStart = readPos - edgeBuffer + find(eegStdDiff == 1);
            epochsEnd = readPos + edgeBuffer -1 + find(eegStdDiff == -1); % -1 accounts for [0; diff]
            % fixing edges
            if length(epochsStart) > length(epochsEnd)
                epochsEnd = [epochsEnd; min(readPos+bufferSize,numSamples)];
            end
            if length(epochsEnd) > length(epochsStart)
                epochsStart = [readPos+1; epochsStart];
            end
            flatEEG{k} = cat(1,flatEEG{k},cat(2,epochsStart,epochsEnd));
        end
        readPos = readPos + bufferSize; % increment readPos
    end
    for k=1:length(channelGroups)
        for m=channelGroups{k}
            %             flatEEG{m} = cat(2,epochsStart,epochsEnd);
            outDir = [fileBase '/FlatEpochs/'];
            mkdir(outDir)
            outName = [outDir fileBase fileExt '.flat.ch' num2str(m) '.txt'];
            msave(outName,flatEEG{k})
        end
    end

    unionEpochs = UnionEpochs(flatEEG{:});
    
    time = length(Epochs2Times(unionEpochs,1));
%     time = sum(diff(unionEpochs,[],2),1);
    if isempty(time)
        time = 0;
    end
    temp = dir([fileBase '/' fileBase fileExt]);
    fprintf('%i epochs (%i/%i samples: %2.1f%%)\n',size(unionEpochs,1),time,...
        temp.bytes/bps/nChan,time/(temp.bytes/bps/nChan)*100)
    msave([fileBase '/' fileBase fileExt '.flat.txt'],unionEpochs)
    if plotBool & ~isempty(unionEpochs)
        plotDuration = 10; %sec
        figure
        hold on
        plotData = bload([fileBase '/' fileBase fileExt],[nChan Fs*plotDuration],...
            (unionEpochs(1,1)-1)*bps*nChan);
        offset = max(std(plotData,[],2));
        for k=1:nChan
            plot(unionEpochs(1,1):unionEpochs(1,1)+Fs*plotDuration-1,...
                plotData(k,:)-k*offset/5);
        end
%         indexes = find(unionEpochs(:,2)<=unionEpochs(1,1)+Fs*plotDuration);
        PlotVertLines(unionEpochs(:,1),get(gca,'ylim'),...
            'color','g')
        PlotVertLines(unionEpochs(:,2),get(gca,'ylim'),...
            'color','r')
        set(gca,'xlim',[unionEpochs(1,1) unionEpochs(1,1)+Fs*plotDuration]);
        set(gcf,'name',[fileBase fileExt '.flat.txt'])
        SetFigPos(gcf,[0.5 0.5 15 10]);
    end
end

SetWarnings(prevWarn);

return

%%%%%%%%%%%%%%%%%%%%%%%%% testing %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
eegSamp = 1250;
bps = 2;
nChan = 99;
for j=1:length(fileBaseCell)
    fileBase = fileBaseCell{j};
    unionEpochs = [];
    for k=1:length(channelGroups)
            outDir = [fileBase '/FlatEpochs/'];
            outName = [outDir fileBase fileExt '.flat.ch' ...
                num2str(channelGroups{k}(1)) '.txt'];
            temp = load(outName);
            unionEpochs = UnionEpochs(unionEpochs,temp);
    end
    time = sum(diff(unionEpochs,[],2)/eegSamp,1);
    if isempty(time)
        time = 0;
    end
    temp = dir([fileBase '/' fileBase '.eeg']);
    fprintf('%s: %i (time = %1.1f/%1.1f sec)\n',fileBase,length(unionEpochs),time,...
        temp.bytes/bps/eegSamp/nChan)
end


chan = 65:72;
epochs = load(['FlatEpochs/ec014.194.eeg.flat.ch' num2str(chan(1)) '.txt']);
eeg = readmulti('ec014.194.eeg',nChan,chan);

clf
hold on
for j=1:8
plot(eeg(:,j)-j*1000)
end
PlotVertLines(epochs(:,1),[-10000 2000],'color','g')
PlotVertLines(epochs(:,2),[-10000 2000],'color','r')




fileBase = 'ec014.195';
fileExt = '.eeg';
nChan = 99;
k=1;
channelGroups = {};
nGroups = 12;
chanPerGroup = 8;
for j=1:nGroups
    channelGroups{j} = [(j-1)*chanPerGroup+1:j*chanPerGroup];
end
edgeBuffer = 10;


nChan = 99
eegSamp = 1250
bps = 2
time = 32*60
eeg = bload('ec014.195.eeg',[nChan 60*eegSamp],time*nChan*eegSamp*bps);

nChan = 40
csd1 = bload('ec014.195.csd1',[nChan 60*eegSamp],time*nChan*eegSamp*bps);

eegDiff = [];
for j=1:8
    eegDiff(j,:) = std(eeg([(j-1)*8+1:j*8],:),[],1);
    [(j-1)*8+1:j*8]
end

clf
hold on
for j=1:8
plot(eeg(j,:)-j*1000)
end

hold on
for j=1:4
plot(eegDiff(j,:)-j*8000,'r')
end
grid on

clf
plot(1:size(eegDiff,2),eegDiff)

set(gca,'ylim',[0 100])


clf
hold on
for j=1:8
plot(eeg(:,j)-j*1000)
end
PlotVertLines(epochsStart,[-10000 2000],'color','r')
PlotVertLines(epochsEnd,[-10000 2000],'color','g')  

set(gca,'xlim',[a a+1250*5]);a = 2126000;

