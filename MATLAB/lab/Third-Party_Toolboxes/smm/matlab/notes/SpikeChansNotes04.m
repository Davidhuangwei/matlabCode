function SpikeChansNotes04(fileBaseMat,nchannels,Fs)
infoStruct.fileBaseMat = fileBaseMat;
infoStruct.numMeas = numMeas;
infoStruct.nchannels = nchannels;
infoStruct.datSamp = sampl;
infoStruct.stdDev = stdDev;
infoStruct.fileext = fileext;
infoStruct.refracPer = refracPer;
infoStruct.lowband = lowband;
infoStruct.forder = forder;
infoStruct.firfiltb = firfiltb;
infoStruct.bps = bps;
infoStruct. = ;
infoStruct. = ;

stdDev = 50;
fileext = '.dat';
sampl = Fs;
refracPer = 1/1000*sampl;
lowband = 800; % 800 Hz
forder = 5/1000*sampl; % 5ms
firfiltb = fir1(forder,lowband/sampl*2,'high'); % high-pass filter
%avgfiltb = ones(avgfilorder,1)/avgfilorder; % smoothing filter

bps = 2; % bytes per sample
forderBuff = forder;%*nchannels*bps;

infoStruct.fileBaseMat = fileBaseMat;
infoStruct.nchannels = nchannels;
infoStruct.datSamp = sampl;
infoStruct.stdDev = stdDev;
infoStruct.fileext = fileext;
infoStruct.refracPer = refracPer;
infoStruct.lowband = lowband;
infoStruct.forder = forder;
infoStruct.firfiltb = firfiltb;
infoStruct.bps = bps;

outBufferSize = 2^floor(log2(6000000/nchannels/bps)); % up to 60MB buffer (divisible by nchannels)
nFiles = size(fileBaseMat,1);
for j=1:nFiles
    fileBase = fileBaseMat(j,:);
    cd(fileBase)
    fprintf('\n%s\n',fileBase);
    numMeas = 0;

    infoStruct = dir([fileBase fileext]);
    numSamples = infoStruct.bytes/nchannels/bps;

    %Woffset = 0; % in samples
    Roffset = forderBuff; % in samples
    readPos = 0; % in samples
    writePos = 0;
    progressBar = 0;

    % values set for first read
    Roffset = forderBuff; % in samples
    inBufferSize = outBufferSize + forderBuff; % outBufferSize + 1 forder buffer
    
    fprintf('#.............Filtering & Smoothing..............#\n');
    while readPos < numSamples,
        while floor(50*(readPos-progressBar)/numSamples) > 0
            fprintf('#');
            progressBar = progressBar + floor(numSamples/50);
        end
        if numSamples-readPos < inBufferSize, % last segment
            inBufferSize = numSamples-readPos;
            outBufferSize = inBufferSize - forderBuff;
            Roffset = -forderBuff; % to avoid getting stuck not advancing readPos
        end

        eegdat = bload([fileBase fileext],[nchannels inBufferSize],readPos*nchannels*bps,'int16')';
%         for n=1:nchannels
%             [temp fo] = pwelch(eegdat(:,n),[],[],[],sampl);
%             if readPos ~= 0
%                 pSpec(:,n) = pSpec(:,n) + temp;
%             else
%                 pSpec(:,n) = temp;
%             end
%             fs = fo;
%         end
        filtered_data = Filter0(firfiltb, eegdat); % filter
        filtered_data = filtered_data(writePos+1:writePos+outBufferSize,:);
        
        
        for m=1:size(filtered_data,2)
            [junk junk2 temp] = jbtest(filtered_data(:,m));
            if readPos ~= 0
                jbStat(m) = jbStat(m) + temp;
            else
                jbStat(m) = temp;
            end
            
            [junk junk2 temp] = lillietest(filtered_data(:,m));
            if readPos ~= 0
                lillieStat(m) = lillieStat(m) + temp;
            else
                lillieStat(m) = temp;
            end
            for n=1:25
                if readPos ~= 0
                    spikes(m,n) = spikes(m,n)+length(LocalMinima(filtered_data(:,m),refracPer,-stdDev*(n)));
                else
                    spikes(m,n) = length(LocalMinima(filtered_data(:,m),refracPer,-stdDev*(n)));
                end
            end
        end
        numMeas = numMeas + 1;
        inBufferSize = outBufferSize + 2 * forderBuff;
        readPos = readPos + outBufferSize - Roffset;
        writePos = forderBuff;
        Roffset = 0;
    end
    infoStruct.numMeas = numMeas;
    jbStat = jbStat/numMeas;
    lillieStat = lillieStat/numMeas;
    save('SpikeChanDist',SaveAsV6,'infoStruct','jbStat','lillieStat','spikes');
    clear jbStat;
    clear lillieStat;
    clear spikes;
    cd ..
end
return

figure
imagesc(Make2DPlotMat(log(jbStat/numMeas),MakeChanMat(6,16)));
set(gca,'clim',[2 9])
colorbar
figure
imagesc(Make2DPlotMat(lillieStat/numMeas,MakeChanMat(6,16)));
set(gca,'clim',[0.005 .01])
colorbar

% spikes = spikes';
normSpikes = (spikes+1)./repmat(median(spikes+1,1),size(spikes,1),1);
% numShanks = 6;
% chansPerShank = 16;
% chans = 1:96;
% subplotChanMat = MakeChanMat(chansPerShank,numShanks)';
% subplotChans = subplotChanMat(:);
% figure
% clf
chanInfoDir = 'ChanInfo/';
eegOffset = load([chanInfoDir 'OffSet.eeg.txt']);
eegChanMat = LoadVar([chanInfoDir 'ChanMat.eeg.mat']);
chanMat = LoadVar([chanInfoDir 'ChanMat.eeg.mat']);
plotSpikes = MakeBufferedPlotMat(permute(normSpikes,[1,3,2]),[0.1 0.1],chanMat);
ImageScRmNaN(plotSpikes,[0 5],[1 0 1])
PlotAnatCurvesNew([chanInfoDir 'AnatCurvesNew.mat'],...
    [size(plotSpikes,1)/size(eegChanMat,1)*size(chanMat,1) size(plotSpikes,2)],...
    [0.5+eegOffset(1)*(size(plotSpikes,1)/size(eegChanMat,1)) 0.5]);
set(gca,'xtick',[]);

for j=1:length(chans)
    subplot(chansPerShank,numShanks,subplotChans(j))
    %hold on
    set(gca,'xlim',[1 25],'fontsize',5)%,'ylim',[0 max(max(normSpikes))])
    imagesc(normSpikes(:,chans(j))')
    set(gca,'clim',[0 5],'ytick',[])
    %colorbar
    %plot(normSpikes(:,chans(j)));
    ylabel(['ch' num2str(chans(j))])
    %plot((spikes(:,j)+1)./mean(spikes+1,2));
    %plot([1 25],[1 1],'r')
    %set(gca,'xlim',[1 25])%,'ylim',[0 max(max(normSpikes))])
end
plotPspec = permute(pSpec(fo>200,:)',[1,3,2]);
plotPspec = MakeBufferedPlotMat(plotPspec.*...
    repmat(permute(fo(fo>200).^2,[3 2 1]),[size(plotPspec,1),1,1]),...
    [0.1 0.1],chanMat);
ImageScRmNaN(plotPspec,[],[1 0 1])
PlotAnatCurvesNew([chanInfoDir 'AnatCurvesNew.mat'],...
    [size(plotPspec,1)/size(eegChanMat,1)*size(chanMat,1) size(plotPspec,2)],...
    [0.5+eegOffset(1)*(size(plotPspec,1)/size(eegChanMat,1)) 0.5]);

figure
test = sum(pSpec(find(fo<700 & fo>300),:)); 
imagesc(Make2DPlotMat(test',MakeChanMat(6,16)))
set(gca,'clim',[3.5e4 7e4])



