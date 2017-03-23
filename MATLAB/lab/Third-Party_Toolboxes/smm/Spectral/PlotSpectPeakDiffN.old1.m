% function PlotSpectPeakDiffN(spectAnalBase,fileExt,analRoutine,varargin)
% [TrialDesigVersion filtFreqRange maxFreq chans diffN] = DefaultArgs(varargin,...
%     {'GlmWholeModel08',[4 25],14,[1:load(['ChanInfo/NChan' fileExt '.txt'])],2});
% Plots histograms of the nth derivative of the peak times for different
% behaviors (using LoadDesigVar). Use CalcPeakTrigRes.m to calculate the
% peak times. Useful for examining the wave by wave variability in
% wavelength.
% tag:peak
% tag:diff
% tag:freq
% tag:spectral
function PlotSpectPeakDiffN(analDirs,spectAnalBase,fileExt,analRoutine,varargin)
[TrialDesigVersion filtFreqRange maxFreq chans diffN ReportFigBool] = ...
    DefaultArgs(varargin,...
    {'GlmWholeModel08',[4 12],14,[],2,1});
    
datSamp = 20000;
eegSamp = 1250;


cwd = pwd;
for a=1:length(analDirs)
    cd(analDirs{a})

    try
        
        selChan = Struct2CellArray(LoadVar(['ChanInfo/SelChan' fileExt]));
        if isempty(chans)
            chans = [selChan{:,end}];
        end
    end
    
    load(['TrialDesig/' TrialDesigVersion '/' analRoutine '.mat']);

    % infoStruct = LoadVar([fileBaseCell{1} '/' spectAnalBase fileExt '/infoStruct'])
    % eegSamp = LoadField([fileBaseCell{1} '/' spectAnalBase fileExt '/infoStruct.eegSamp']);
    winLen = LoadField([fileBaseCell{1} '/' spectAnalBase fileExt '/infoStruct.winLength']);
    timeWin = winLen/eegSamp;

    time = Struct2CellArray(LoadDesigVar(fileBaseCell,...
        [spectAnalBase fileExt],...
        'time',trialDesig),[],1);
    % dtN = time;
    % clu = time;
    % for j=1:size(time,1)
    %     dtN{j,end} = [];
    %     clu{j,end} = [];
    % end
    for j=1:size(time,1)
        for k=1:length(fileBaseCell)
            time = Struct2CellArray(LoadDesigVar(fileBaseCell{k},...
                [spectAnalBase fileExt],...
                'time',trialDesig),[],1);
            inBase = [fileBaseCell{k} '_Peak' ...
                num2str(filtFreqRange(1)) '-' num2str(filtFreqRange(2)) 'Hz'...
                '_Max' num2str(maxFreq) fileExt];

            if length(time{j,end})
                epochs = Times2Epochs(time{j,end} - timeWin/2,timeWin);
            else
                epochs = [0 0];
            end

            [catRes catClu] = LoadResClu([fileBaseCell{k} '/' inBase],chans,epochs*datSamp);
            catClu = catClu(2:end);
            %        if epochs(1,2)
            %         keyboard
            %         eeg = readmulti([fileBaseCell{k} '/' fileBaseCell{k} fileExt],...
            %             load(['ChanInfo/NChan' fileExt '.txt']),40);
            %        end
            for c=1:length(chans)
                if ~exist('dtN','var') | length(dtN)<j
                    dtN{j} = diff(catRes(catClu==chans(c)),diffN,1);
                    clu{j} = repmat(c,[sum(catClu==chans(c))-2 1]);
                else
                    dtN{j} = cat(1,dtN{j},diff(catRes(catClu==chans(c)),diffN,1));
                    clu{j} = cat(1,clu{j},repmat(c,[sum(catClu==chans(c))-2 1]));
                end
            end
        end
    end
end
cd(cwd);

xLimit = 150;
plotXLim = [-100 100];
yLimit = 0.25;
nBins = 50;
percConf = 95;
resamps = 1000;
clf
plotColors = 'brgk';
screenHeight = 15;
xyRatio = 1.5;
set(gcf,'units','inches')
set(gcf,'position',[0.5 -1 screenHeight/length(chans)*xyRatio screenHeight])
set(gcf,'paperposition',get(gcf,'position'))
set(gcf,'name',GenFieldName([analRoutine '_'...
    num2str(filtFreqRange(1)) '-' num2str(filtFreqRange(2)) 'Hz_Max'...
    num2str(maxFreq) fileExt]))
for c=1:length(chans)
    subplot(length(chans),1,c)
    for k=1:length(dtN)
        %         [n x] = hist((dtN{k}(clu{k}==chans(j))/datSamp*1000),...
        %             [-xLimit:xLimit*2/nBins:xLimit]);
        %         plot(x,n/sum(clu{k}==chans(j)),plotColors(k));
        [n x] = BsErrBars(@median,percConf,resamps,@hist,1,...
            (dtN{k}(clu{k}==c)/datSamp*1000),...
            [-xLimit:xLimit*2/nBins:xLimit]);
        plot(x(1,:),n(1,:)/sum(clu{k}==c),plotColors(k));
        hold on
        plot(repmat(x(1,:),[2 1]),n(2:3,:)/sum(clu{k}==c),...
            plotColors(k));

        if c==1
            text(xLimit/2,yLimit-k*yLimit/(length(dtN)+1),...
                [time{k,1:end-1}],'color',plotColors(k));
        end
    end
    set(gca,'ylim',[0 yLimit])
    set(gca,'xlim',plotXLim);
    if exist('selChan','var')
        ylabel(selChan{c,1})
    else
        ylabel(['ch ' num2str(chans(c))])
    end
    xlabel('Change in wavelength')
end
if ReportFigBool
    ReportFigSM(gcf,GenFieldName(['/u12/smm/public_html/NewFigs/REMPaper/'...
        mfilename '_' num2str(diffN) '/']),[],[],{cat(1,spectAnalBase,analDirs(:))});
end

