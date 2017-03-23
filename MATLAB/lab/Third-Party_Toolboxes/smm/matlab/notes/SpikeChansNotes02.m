function SpikeChansNotes02(fileBaseMat,fileext,nchannels,Fs)
try   
numMeas = 0;
stdDev = 50;
refracPer = 1/1000*20000;

sampl = Fs;
lowband = 800; % 800 Hz
forder = 5/1000*sampl; % 5ms
firfiltb = fir1(forder,lowband/sampl*2,'high'); % high-pass filter
%avgfiltb = ones(avgfilorder,1)/avgfilorder; % smoothing filter

bps = 2; % bytes per sample
forderBuff = forder;%*nchannels*bps;

outBufferSize = 2^floor(log2(6000000/nchannels/bps)); % up to 60MB buffer (divisible by nchannels)
nFiles = size(fileBaseMat,1);
for j=1:nFiles
    fileBase = fileBaseMat(j,:);
    fprintf('\n%s\n',fileBase);

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
end
keyboard
catch keyboard
end

figure
imagesc(Make2DPlotMat(log(jbStat/numMeas),MakeChanMat(6,16)));
%set(gca,'clim',[6 15])
colorbar
figure
imagesc(Make2DPlotMat(jbStat/numMeas),MakeChanMat(6,16)));
%set(gca,'clim',[0 2e5])
colorbar
figure
imagesc(Make2DPlotMat(lillieStat/numMeas,MakeChanMat(6,16)));
%set(gca,'clim',[0 .15])
colorbar

spikes = spikes';
normSpikes = (spikes+1)./repmat(median(spikes+1,2),1,size(spikes,2));
numShanks = 6;
chansPerShank = 16;
chans = 1:96;
subplotChanMat = MakeChanMat(chansPerShank,numShanks)';
subplotChans = subplotChanMat(:);
figure
clf
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






for k=1:6
    figure(k+2)
    clf
    chans = (k-1)*16+1:k*16;
for j=1:length(chans)
    subplot(length(chans),1,j)
    hold on
plot(normSpikes(:,chans(j)));
%plot((spikes(:,j)+1)./mean(spikes+1,2));
plot([1 25],[1 1],'r')
set(gca,'xlim',[1 25])%,'ylim',[0 max(max(normSpikes))])
end
end
