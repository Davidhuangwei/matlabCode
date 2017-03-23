function DetectPhasicRem(fileBaseCell,fileExt,winLen,preWhitenBool,recalcSpecBool)

fileBaseCell = LoadVar('FileInfo/RemFiles')
fileExt = '.eeg';
fileExt = '_LinNearCSD121.csd';
winLen = 1024;
recalcSpecBool = 0;
preWhitenBool = 0;

eegSamp = 1250;
selChan = Struct2CellArray(LoadVar(['ChanInfo/SelChan' fileExt]),[],1);
chan = [selChan{:,2}];
nChan = load(['ChanInfo/NChan' fileExt '.txt']);
catY = [];
catT = {};
catTo = {};
if preWhitenBool
    outNameBlurb = 'WPSpec';
else
    outNameBlurb = 'PSpec';
end
for j=1:length(fileBaseCell)
    fileBase = fileBaseCell{j};
    %     if exist([fileBase '/RemTimes.mat'],'file')
    if exist([fileBase '/' fileBase '.sts.REM'],'file')
        remTimes = load([fileBase '/' fileBase '.sts.REM'])
        if preWhitenBool
            specFile = [fileBase '/' fileBase 'SelChan' outNameBlurb fileExt '.mat'];
        else
            specFile = [fileBase '/' fileBase 'SelChan' outNameBlurb fileExt '.mat'];
        end
        if ~FileExists(specFile) | recalcSpecBool
            eeg = readmulti([fileBase '/' fileBase fileExt],nChan,chan);
            if preWhitenBool
                eeg = WhitenSignal(eeg,eegSamp*2000,1);
            end
            [y,f,t] = mtcsglong(eeg',winLen*4,eegSamp,winLen,winLen/4,2,[],[],[0 250]);
            fprintf('Saving %s\n',specFile);
            save(specFile,SaveAsV6,'y','f','t','chan');
        else
            load(specFile)
        end
        for k=1:size(remTimes,1)
            catT{j,1} = t>=remTimes(k,1)/eegSamp & t<=remTimes(k,2)/eegSamp;
            catTo{j,1} = t(t>=remTimes(k,1)/eegSamp & t<=remTimes(k,2)/eegSamp);
            catY = cat(1,catY,y(t>=remTimes(k,1)/eegSamp & t<=remTimes(k,2)/eegSamp,:,:));
        end
    end
end

% calculate ICA
icaFile = ['RemICA_' outNameBlurb fileExt '.mat'];
if ~exist(icaFile,'file');
    addpath /u12/antsiro/matlab/DimReduction/FastICA/
    [icasig, A, W] = fastica(reshape(catY,size(catY,1),size(catY,2)*size(catY,3))','lastEig',5);
    save(icaFile,SaveAsV6,'icasig','A','W','catT','catTo','chan');
end
return

    weeg = WhitenSignal(Eeg,eSampleRate*2000,1);


 y = catY;
 
 figure
 clf
 for j=1:length(chan)
     subplot(length(chan),1,j)
     imagesc(1:size(y,1),f,log10(y(:,:,j)'))
     set(gca,'ylim',[0 250])
 end



figure
%remEpoch = [100 200]
%times = t>remEpoch(1) & t<remEpoch(2);
times = logical(ones(size(y,1),1));
t = 1:size(y,1);
fRanges = [4 12; 40 120; 150 250; 60 250;0 250];

smoothKrnl = gausswin(round(10/median(diff(f))))./round(10/median(diff(f)));
thetaFreq = FindSpectPeak01(permute(y,[1 3 2]),f,[4 15],[],smoothKrnl);
clf
subplot(size(fRanges,1)+2,1,1)
filtLen = 3;
plot(t(times),ConvTrim(thetaFreq(times,2),ones(filtLen,1)./filtLen));
%  plot(t(times),thetaFreq(times,2));
plotColors = 'rgbkr';
for j=1:size(fRanges,1)
    subplot(size(fRanges,1)+2,1,j+1)
    plot(t(times),squeeze(mean(mean(y(times,f>fRanges(j,1) & f<fRanges(j,2),:),2),3)),plotColors(j));
    grid on
end

z = reshape(y(:),size(y,1),size(y,2)*size(y,3));
[coeff, score, latent, tsquared] = princomp(z(times,:));
xgobi([score(:,1:6) t'])

subplot(size(fRanges,1)+2,1,size(fRanges,1)+2)
plot(t(times),score(:,2))






z2 = reshape(z(:),size(y));