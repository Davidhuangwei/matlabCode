% function DetectPhasicRem04(fileBaseCell,fileExt,varargin)
% [nChan,chan,chanGroupName,plotChan,winLen,phasicRefrac,defSD,preWhitenBool,recalcBool,fRange] = ...
%     DefaultArgs(varargin,{nChan,chan,'Mol',plotChan,1/2,2,2,1,0,[0 250]});
% 
% tag:phasic
% tag:rem

function DetectPhasicRem04(fileBaseCell,fileExt,varargin)
try
%     selChan = Struct2CellArray(LoadVar(['ChanInfo/SelChan' fileExt]),[],1);
%     chan = [selChan{:,2}];
    chanLoc = LoadVar(['ChanInfo/ChanLoc_Min' fileExt]);
    badChan = load(['ChanInfo/BadChan' fileExt '.txt']);
    chan = setdiff([chanLoc.mol{:}],badChan);
    nChan = load(['ChanInfo/NChan' fileExt '.txt']);
    plotChan = chan;
%     plotChan = chan([2,4,5]);
end
[nChan,chan,chanGroupName,plotChan,winLen,phasicRefrac,defSD,preWhitenBool,recalcBool,fRange] = ...
    DefaultArgs(varargin,{nChan,chan,'Mol',plotChan,1/2,2,2,1,0,[0 250]});

addpath /u12/antsiro/matlab/draft
addpath /u12/antsiro/matlab/General

eegSamp = 1250;
catY = [];
catTo = [];
fileNum = [];
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
            specFile = [fileBase '/' fileBase '_' chanGroupName '_' outNameBlurb fileExt '.mat'];
        else
            specFile = [fileBase '/' fileBase '_' chanGroupName '_' outNameBlurb fileExt '.mat'];
        end
        if ~FileExists(specFile) | recalcBool
            eeg = readmulti([fileBase '/' fileBase fileExt],nChan,chan);
            if preWhitenBool
                eeg = WhitenSignal(eeg,eegSamp*2000,1);
            end
            winLen = 1;
            params.tapers = [1 1];
            params.pad = 1;
            params.Fs = eegSamp;
            params.fpass = [0 250];
             [y,t,f]=mtspecgramc(eeg,[winLen winLen/4],params);
            fprintf('Saving %s\n',specFile);
            save(specFile,SaveAsV6,'y','f','t','chan');
        else
            load(specFile)
        end
        for k=1:size(remTimes,1)
%             catT{j,1} = cat(1,catT{j,1},t>=remTimes(k,1)/eegSamp & t<=remTimes(k,2)/eegSamp);
%             catTo{j,1} = cat(1,catTo{j,1},t(t>=remTimes(k,1)/eegSamp & t<=remTimes(k,2)/eegSamp));
            selInd = t>=remTimes(k,1)/eegSamp & t<=remTimes(k,2)/eegSamp;
            catTo = cat(1,catTo,t(selInd)');
             fileNum = cat(1,fileNum,repmat(j,[length(find(selInd)) 1]));
            catY = cat(1,catY,y(selInd,:,:));
            
        end
    end
end

y = catY;
times = logical(ones(size(y,1),1));
diffTime = diff(catTo(1:2));
t = [1:size(y,1)]*diffTime;
smoothKrnl = gausswin(round(10/median(diff(f))))./round(10/median(diff(f)));
thetaFreq = FindSpectPeak01(permute(y,[1 3 2]),f,[4 14],'NaN',smoothKrnl);

figure
numSD = defSD;
while 1
    clf
    filtLen = 3;
    integPow = 10*log10(squeeze(mean(mean(y(times,f>fRange(end,1) & f<fRange(end,2),:),2),3)));
%     integPow = log10(squeeze(mean(mean(y(times,f>fRange(end,1) & f<fRange(end,2),5),2),3)));
%     integPow = squeeze(mean(mean(y(times,f>fRange(end,1) & f<fRange(end,2),:),2),3));
    medianPow = median(integPow);
    sdPow = std(integPow);
    lmin = LocalMinima(-integPow,phasicRefrac/diffTime,-(medianPow+numSD*sdPow));
    % cLimits = [-0.5 2.5];

    yLimits = [2 250];
    e = 1/3;
    [junk plotNum] = intersect(chan, plotChan);
    set(gcf,'unit','inches')
    set(gcf,'position',[0 0.5 16 2.5*(length(plotNum)+1)])
    set(gcf,'paperposition',get(gcf,'position'))
    for j=1:length(plotNum)
        subplot(length(plotNum)+1,1,j)
        hold on
        h1 = gausswin(round(1/diffTime));
        h2 = gausswin(round(15/diff(f(1:2))));
%          imagesc(t(times),f,log10(Conv2Trim(h1,h2,y(:,:,plotNum(j)))'))
%          pcolor(t(times),f,log10(Conv2Trim(h1,h2,y(:,:,plotNum(j)))'))
%         imagesc(t(times),f,log10(y(:,:,plotNum(j))'))
%          pcolor(t(times),(f).^e,log10(y(:,:,plotNum(j))'))
         pcolor(t(times),(f).^e,log10(Conv2Trim(h1,h2,y(:,:,plotNum(j)))'))
         shading interp
%         imagesc(t(times),f,log10(y(:,:,plotNum(j)))')
        % imagesc(t(times),f,log10(y(:,:,j)'))
        plot(t(times),ConvTrim(thetaFreq(times,plotNum(j)),ones(filtLen,1)./filtLen).^e);
        %     plot(t([lmin2 lmin2])',repmat(yLimits,[length(lmin2) 1])','--r')
%         plot(t([lmin lmin])',repmat(yLimits,[length(lmin) 1])','--k')
        plot(t([lmin lmin])',repmat(yLimits.^e,[length(lmin) 1])','--k')
        SetExpYTick(yLimits,e)
%         set(gca,'ylim',sqrt(yLimits))
%         set(gca,'ytick',5/2*2.^[1:7]
%         set(gca,'yticklabel',num2str(sqrt(str2num(get(gca,'yticklabel')))))
        %set(gca,'clim',cLimits)
        if exist('selChan','var')
            ylabel(selChan{plotNum(j),1})
        else
            ylabel(num2str(chan(plotNum(j))))
        end
    end
    subplot(length(plotNum)+1,1,length(plotNum)+1)
    hold on
    yLimits = [min(integPow), max(integPow)];
    plot(t(times),integPow);
    plot(t(times),repmat(medianPow+numSD*sdPow,size(t(times))),'k')
    % plot(t([lmin2 lmin2])',repmat(yLimits,[length(lmin2) 1])','--r')
    % plot(t(times),repmat(medianPow+3*sdPow,size(t(times))),'k')
    plot(t([lmin lmin])',repmat(yLimits,[length(lmin) 1])','--k')
    set(gca,'ylim',yLimits)
    ylabel({['Integ Pow ' num2str(fRange(end,1)) '-' num2str(fRange(end,2)) 'Hz'],...
        ['(' num2str(numSD) ' stdev)']});
    fprintf('\n%i detected times',length(lmin))
    in = input('\nIs this a good threshold? y/[n] ','s');
    if strcmp(in,'y')
        break;
    else
        in = input('Enter a new threshold: ');
        numSD = in;
    end
end
saveName = ['PhasicRemTimes_' chanGroupName '_' ...
    num2str(fRange(1)) '-' num2str(fRange(2)) 'Hz'...
    '_SD' num2str(numSD) '_Refrac' num2str(phasicRefrac) fileExt '.txt'];
in = [];
while ~strcmp(in,'y') & ~strcmp(in,'n')
    in = input(['Save ' saveName '? y/n: '],'s');
end
if strcmp(in,'y')
    set(gcf,'name',saveName)
    ReportFigSM(gcf,['NewFigs/' mfilename '/'])
    lminVec = zeros(size(catTo));
    lminVec(lmin) = 1;
    for j=1:length(fileBaseCell)
        phasicRemTimes = catTo(lminVec & fileNum==j);
        fprintf('\nSaving: %s',[fileBaseCell{j} '/' saveName])
        save([fileBaseCell{j} '/' saveName],'-ascii','phasicRemTimes');
        cd(fileBaseCell{j});
        if exist('PhasicRemTimes.txt','file')
            eval(['!rm PhasicRemTimes.txt']);
        end
        eval(['!ln -s ' saveName ' ' 'PhasicRemTimes.txt'])
        cd ..
    end
end

return
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
plot(t(times),repmat(medianPow+2*sdPow,size(t(times))),'r')
plot(t([lmin2 lmin2])',repmat(yLimits,[length(lmin2) 1])','--r')
plot(t(times),repmat(medianPow+3*sdPow,size(t(times))),'k')
plot(t([lmin3 lmin3])',repmat(yLimits,[length(lmin3) 1])','--k')
% set(gca,'ylim',yLimits)
ylabel(['Integ Pow ' num2str(fRange(end,1)) '-' num2str(fRange(end,2)) 'Hz']);


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
plot(t(times),repmat(medianPow+2*sdPow,size(t(times))),'r')
plot(t([lmin2 lmin2])',repmat(yLimits,[length(lmin2) 1])','--r')
plot(t(times),repmat(medianPow+3*sdPow,size(t(times))),'k')
plot(t([lmin3 lmin3])',repmat(yLimits,[length(lmin3) 1])','--k')
set(gca,'ylim',yLimits)
ylabel(['Integ Pow ' num2str(fRange(end,1)) '-' num2str(fRange(end,2)) 'Hz']);
% colorbar

%%%%%%%%%%%%%%%%%%
for j=1:length(chan)
    subplot(length(chan),1,j)
    hold on
    imagesc(t(times),f,log10(y(:,:,j)'))
    set(gca,'ylim',[0 250])
    plot(t(times),ConvTrim(thetaFreq(times,j),ones(filtLen,1)./filtLen));
    integPow = squeeze(mean(mean(y(times,f>fRange(end,1) & f<fRange(end,2),:),2),3));
    lmin = LocalMinima(-integPow,phasicRefrac/diff(catTo{1}(1:2)),-(medianPow+2*sdPow));
    plot(t([lmin lmin])',repmat(yLimits,[length(lmin) 1])','r')
    plot(t(times),repmat(medianPow+3*sdPow,size(t(times))),'k')
    lmin = LocalMinima(-integPow,phasicRefrac/diff(catTo{1}(1:2)),-(medianPow+3*sdPow));
    plot(t([lmin lmin])',repmat(yLimits,[length(lmin) 1])','k')

end


z = reshape(y(:),size(y,1),size(y,2)*size(y,3));
[coeff, score, latent, tsquared] = princomp(z(times,:));
xgobi([score(:,1:6) t'])

subplot(size(fRange,1)+2,1,size(fRange,1)+2)
plot(t(times),score(:,2))

figure
for j=1:10
    subplot(10,1,j)
    plot(score(:,j))
end





z2 = reshape(z(:),size(y));