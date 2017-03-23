function DetectPhasicRem02(fileExt,varargin)
try
    selChan = Struct2CellArray(LoadVar(['ChanInfo/SelChan' fileExt]),[],1);
    chan = [selChan{:,2}];
    nChan = load(['ChanInfo/NChan' fileExt '.txt']);
    plotChan = chan;
%     plotChan = chan([2,4,5]);
end
[fileBaseCell,nChan,chan,plotChan,winLen,phasicRefrac,defSD,preWhitenBool,recalcBool] = ...
    DefaultArgs(varargin,{LoadVar('FileInfo/RemFiles'),nChan,chan,plotChan,1024,2,2,1,0});

addpath /u12/antsiro/matlab/draft
addpath /u12/antsiro/matlab/General

eegSamp = 1250;
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
        if ~FileExists(specFile) | recalcBool
            eeg = readmulti([fileBase '/' fileBase fileExt],nChan,chan);
            if preWhitenBool
                eeg = WhitenSignal(eeg,eegSamp*2000,1);
            end
            [y,f,t] = mtcsglong(eeg',winLen*2,eegSamp,winLen,winLen*3/4,2,[],[],[0 250]);
            fprintf('Saving %s\n',specFile);
            save(specFile,SaveAsV6,'y','f','t','chan');
        else
            load(specFile)
        end
        catT{j,1} = [];
        catTo{j,1} = [];
        for k=1:size(remTimes,1)
            catT{j,1} = cat(1,catT{j,1},t>=remTimes(k,1)/eegSamp & t<=remTimes(k,2)/eegSamp);
            catTo{j,1} = cat(1,catTo{j,1},t(t>=remTimes(k,1)/eegSamp & t<=remTimes(k,2)/eegSamp));
            catY = cat(1,catY,y(t>=remTimes(k,1)/eegSamp & t<=remTimes(k,2)/eegSamp,:,:));
        end
    end
end
keyboard
% % calculate ICA
% icaFile = ['RemICA_' outNameBlurb fileExt '.mat'];
% if ~exist(icaFile,'file') | recalcBool
%     addpath /u12/antsiro/matlab/DimReduction/FastICA/
% %     keyboard
% %     [coeff, score, latent] = princomp(reshape(catY,size(catY,1),size(catY,2)*size(catY,3)));
% %     [icasig, A, W] = fastica(reshape(catY,size(catY,1),size(catY,2)*size(catY,3))',...
% %         'pcaE',score,'pcaD',latent','lastEig',10);
%     [icasig, A, W] = fastica(reshape(catY,size(catY,1),size(catY,2)*size(catY,3))',...
%         'lastEig',10,'maxNumIterations',10000,'maxFinetune',1000);
%     save(icaFile,SaveAsV6,'icasig','A','W','catT','catTo','chan');
% end
% return
sum = 0;
for j=1:length(catTo)
sum = sum + length(catTo{j});
end

y = catY;
times = logical(ones(size(y,1),1));
t = [1:size(y,1)]*diff(catTo{1}(1:2));
fRanges = [0 250];
smoothKrnl = gausswin(round(10/median(diff(f))))./round(10/median(diff(f)));
thetaFreq = FindSpectPeak01(permute(y,[1 3 2]),f,[4 14],'NaN',smoothKrnl);

figure
numSD = defSD;
while 1
    clf
    filtLen = 3;
    integPow = log10(squeeze(mean(mean(y(times,f>fRanges(end,1) & f<fRanges(end,2),:),2),3)));
    % integPow = squeeze(mean(mean(y(times,f>fRanges(end,1) & f<fRanges(end,2),:),2),3));
    meanPow = median(integPow);
    sdPow = std(integPow);
    % lmin2 = LocalMinima(-integPow,phasicRefrac/diff(catTo{1}(1:2)),-(meanPow+2*sdPow));
    lmin = LocalMinima(-integPow,phasicRefrac/diff(catTo{1}(1:2)),-(meanPow+numSD*sdPow));
    % cLimits = [-0.5 2.5];

    yLimits = [0 250];
    [junk plotNum] = intersect(chan, plotChan);
    for j=1:length(plotNum)
        subplot(length(plotNum)*2+1,1,j*2-1)
        hold on
        h1 = gausswin(round(1/diff(catTo{1}(1:2))));
        h2 = gausswin(round(15/diff(f(1:2))));
        imagesc(t(times),f,log10(Conv2Trim(h1,h2,y(:,:,plotNum(j)))'))
        % imagesc(t(times),f,log10(y(:,:,j)'))
        plot(t(times),ConvTrim(thetaFreq(times,plotNum(j)),ones(filtLen,1)./filtLen));
        %     plot(t([lmin2 lmin2])',repmat(yLimits,[length(lmin2) 1])','--r')
        plot(t([lmin lmin])',repmat(yLimits,[length(lmin) 1])','--k')
        set(gca,'ylim',yLimits)
        %set(gca,'clim',cLimits)
        if exist('selChan','var')
            ylabel(selChan{plotNum(j),1})
        else
            ylabel(num2str(chan(plotNum(j))))
        end
    end
    yLimits = [0 15];
    for j=1:length(plotNum)
        subplot(length(plotNum)*2+1,1,j*2)
        hold on
        imagesc(t(times),f,log10(y(:,:,plotNum(j)))')
        % imagesc(t(times),f,log10(y(:,:,j)'))
        plot(t(times),ConvTrim(thetaFreq(times,plotNum(j)),ones(filtLen,1)./filtLen));
        %     plot(t([lmin2 lmin2])',repmat(yLimits,[length(lmin2) 1])','--r')
        plot(t([lmin lmin])',repmat(yLimits,[length(lmin) 1])','--k')
        set(gca,'ylim',yLimits)
        %set(gca,'clim',cLimits)
        if exist('selChan','var')
            ylabel(selChan{plotNum(j),1})
        else
            ylabel(num2str(chan(plotNum(j))))
        end
    end
    subplot(length(plotNum)*2+1,1,length(plotNum)*2+1)
    hold on
    yLimits = [1 2.5];
    plot(t(times),integPow);
    plot(t(times),repmat(meanPow+numSD*sdPow,size(t(times))),'k')
    % plot(t([lmin2 lmin2])',repmat(yLimits,[length(lmin2) 1])','--r')
    % plot(t(times),repmat(meanPow+3*sdPow,size(t(times))),'k')
    plot(t([lmin lmin])',repmat(yLimits,[length(lmin) 1])','--k')
    set(gca,'ylim',yLimits)
    ylabel({['Integ Pow ' num2str(fRanges(end,1)) '-' num2str(fRanges(end,2)) 'Hz'],...
        ['(' num2str(numSD) ' stdev)']});

    in = input('\nIs this a good threshold? y/[n] ','s')
    if strcmp(in,'y')
        break;
    else
        in = input('Enter a new threshold: ');
        numSD = in;
    end
end

for j=1:length(fileBaseCell)
end
%%%%%%%%%%%%%%%%%%%%%


figure
clf
yLimits = [0 15];
for j=1:length(chan)
    subplot(length(chan)+1,1,j)
    hold on
    imagesc(t(times),f,log10(y(:,:,j)'))
    % imagesc(t(times),f,log10(y(:,:,j)'))
    plot(t(times),ConvTrim(thetaFreq(times,j),ones(filtLen,1)./filtLen));
    plot(t([lmin2 lmin2])',repmat(yLimits,[length(lmin2) 1])','--r')
    plot(t([lmin3 lmin3])',repmat(yLimits,[length(lmin3) 1])','--k')
    set(gca,'ylim',yLimits)
    %set(gca,'clim',cLimits)
    if exist('selChan','var')
    ylabel(selChan{j,1})
    else
    ylabel(num2str(chan(j)))
    end
end
subplot(length(chan)+1,1,length(chan)+1)
hold on
% yLimits = [0 150];
plot(t(times),integPow);
plot(t(times),repmat(meanPow+2*sdPow,size(t(times))),'r')
plot(t([lmin2 lmin2])',repmat(yLimits,[length(lmin2) 1])','--r')
plot(t(times),repmat(meanPow+3*sdPow,size(t(times))),'k')
plot(t([lmin3 lmin3])',repmat(yLimits,[length(lmin3) 1])','--k')
% set(gca,'ylim',yLimits)
ylabel(['Integ Pow ' num2str(fRanges(end,1)) '-' num2str(fRanges(end,2)) 'Hz']);


%%%%%%%%%%%%%%%%%

subplot(4,1,1)
hold on
yLimits = [0 250];
chanNum = 2;
h1 = gausswin(round(1/diff(catTo{1}(1:2))));
h2 = gausswin(round(15/diff(f(1:2))));
imagesc(t(times),f,log10(Conv2Trim(h1,h2,y(:,:,chanNum))'))
% imagesc(t(times),f,log10(y(:,:,chanNum)'))
plot(t(times),ConvTrim(thetaFreq(times,chanNum),ones(filtLen,1)./filtLen));
plot(t([lmin2 lmin2])',repmat(yLimits,[length(lmin2) 1])','--r')
plot(t([lmin3 lmin3])',repmat(yLimits,[length(lmin3) 1])','--k')
set(gca,'ylim',yLimits)
%set(gca,'clim',cLimits)
ylabel(selChan{chanNum,1})
% colorbar
subplot(4,1,2)
hold on
yLimits = [0 20];
chanNum = 4;
imagesc(t(times),f,log10(y(:,:,chanNum)'))
plot(t(times),ConvTrim(thetaFreq(times,chanNum),ones(filtLen,1)./filtLen));
plot(t([lmin2 lmin2])',repmat(yLimits,[length(lmin2) 1])','--r')
plot(t([lmin3 lmin3])',repmat(yLimits,[length(lmin3) 1])','--k')
set(gca,'ylim',yLimits)
%set(gca,'clim',cLimits)
ylabel(selChan{chanNum,1})
% colorbar
subplot(4,1,3)
hold on
yLimits = [0 250];
chanNum = 5;
h1 = gausswin(round(1/diff(catTo{1}(1:2))));
h2 = gausswin(round(15/diff(f(1:2))));
imagesc(t(times),f,log10(Conv2Trim(h1,h2,y(:,:,chanNum))'))
plot(t(times),ConvTrim(thetaFreq(times,chanNum),ones(filtLen,1)./filtLen));
plot(t([lmin2 lmin2])',repmat(yLimits,[length(lmin2) 1])','--r')
plot(t([lmin3 lmin3])',repmat(yLimits,[length(lmin3) 1])','--k')
set(gca,'ylim',yLimits)
%set(gca,'clim',cLimits)
ylabel(selChan{chanNum,1})
%colorbar
subplot(4,1,4)
hold on
yLimits = [0 150];
plot(t(times),integPow);
plot(t(times),repmat(meanPow+2*sdPow,size(t(times))),'r')
plot(t([lmin2 lmin2])',repmat(yLimits,[length(lmin2) 1])','--r')
plot(t(times),repmat(meanPow+3*sdPow,size(t(times))),'k')
plot(t([lmin3 lmin3])',repmat(yLimits,[length(lmin3) 1])','--k')
set(gca,'ylim',yLimits)
ylabel(['Integ Pow ' num2str(fRanges(end,1)) '-' num2str(fRanges(end,2)) 'Hz']);
% colorbar

%%%%%%%%%%%%%%%%%%
for j=1:length(chan)
    subplot(length(chan),1,j)
    hold on
    imagesc(t(times),f,log10(y(:,:,j)'))
    set(gca,'ylim',[0 250])
    plot(t(times),ConvTrim(thetaFreq(times,j),ones(filtLen,1)./filtLen));
    integPow = squeeze(mean(mean(y(times,f>fRanges(end,1) & f<fRanges(end,2),:),2),3));
    lmin = LocalMinima(-integPow,phasicRefrac/diff(catTo{1}(1:2)),-(meanPow+2*sdPow));
    plot(t([lmin lmin])',repmat(yLimits,[length(lmin) 1])','r')
    plot(t(times),repmat(meanPow+3*sdPow,size(t(times))),'k')
    lmin = LocalMinima(-integPow,phasicRefrac/diff(catTo{1}(1:2)),-(meanPow+3*sdPow));
    plot(t([lmin lmin])',repmat(yLimits,[length(lmin) 1])','k')

end


z = reshape(y(:),size(y,1),size(y,2)*size(y,3));
[coeff, score, latent, tsquared] = princomp(z(times,:));
xgobi([score(:,1:6) t'])

subplot(size(fRanges,1)+2,1,size(fRanges,1)+2)
plot(t(times),score(:,2))

figure
for j=1:10
    subplot(10,1,j)
    plot(score(:,j))
end





z2 = reshape(z(:),size(y));