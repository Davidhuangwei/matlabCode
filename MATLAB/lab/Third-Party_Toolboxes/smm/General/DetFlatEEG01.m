function DetFlatEEG01(fileBaseCell,fileExt,nChan,varargin)
chanPerGroup = 8;
nGroups = ceil(nChan/chanPerGroup);
for j=0:nGroups-1
    channelGroups{j+1} = [j*chanPerGroup+1:min([(j+1)*chanPerGroup nChan])];
end
if strcmp(fileExt,'.dat')
    edgeBuffer = 0;
end
if strcmp(fileExt,'.eeg')
    edgeBuffer = 10;
end
[channelGroups edgeBuffer] = DefaultArgs(varargin,{channelGroups,edgeBuffer});

prevWarn = SetWarnings({'off','MATLAB:MKDIR:DirectoryExists'});

for j=1:length(fileBaseCell)
    fileBase = fileBaseCell{j};
    fprintf('Processing: %s\n',fileBase)
    for k=1:length(channelGroups)
        eeg = readmulti([fileBase '/' fileBase fileExt],nChan,channelGroups{k});
%         eegStd = std(readmulti([fileBase '/' fileBase fileExt],nChan,channelGroups{k}),[],2);
        eegStdDiff = [0; diff(std(eeg,[],2) == 0)];
        epochsStart = -edgeBuffer + find(eegStdDiff == 1);
        epochsEnd = edgeBuffer -1 + find(eegStdDiff == -1);
        if length(epochsStart) > length(epochsEnd)
            epochsEnd = [epochsEnd; length(eegStdDiff)];
        end
        if length(epochsEnd) > length(epochsStart)
            epochsStart = [0 epochsStart];
        end
        flatEEG = cat(2,epochsStart,epochsEnd);
        for m=channelGroups{k}
%             flatEEG{m} = cat(2,epochsStart,epochsEnd);
            outDir = [fileBase '/FlatEpochs/'];
            mkdir(outDir)
            outName = [outDir fileBase fileExt '.flat.ch' num2str(m) '.txt'];
            msave(outName,flatEEG)
        end
    end
end

SetWarnings(prevWarn);

return

%%%%%%%%%%%%%%%%%%%%%%%%% testing %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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

