trialDesig.returnArm = {'alter',[1 0 1 0 0 0 0 0 0 0 0 0 0],0.6,[0 0 0 0 0 0 0 1 1],0.5};
trialDesig.centerArm = {'alter',[1 0 1 0 0 0 0 0 0 0 0 0 0],0.6,[0 0 0 0 1 0 0 0 0],0.5};
trialDesig.Tjunction = {'alter',[1 0 1 0 0 0 0 0 0 0 0 0 0],0.6,[0 0 0 1 0 0 0 0 0],0.4};
trialDesig.goalArm =   {'alter',[1 0 1 0 0 0 0 0 0 0 0 0 0],0.6,[0 0 0 0 0 1 1 0 0],0.5};
 files = LoadVar('AlterFiles');
 %files = files(1,:);
   
trialDesig.circle.q1 = cat(1,{'circle',[1 0 0 0 0 0 0 0 0 0 0 0 0],0.6,[0 0 0 0 0 0 0 0 1],0.5},...
    {'circle',[0 0 1 0 0 0 0 0 0 0 0 0 0],0.6,[0 0 0 0 0 0 0 1 0],0.5});
trialDesig.circle.q2 = cat(1,{'circle',[1 0 0 0 0 0 0 0 0 0 0 0 0],0.6,[0 0 0 0 0 0 1 0 0],0.5},...
    {'circle',[0 0 1 0 0 0 0 0 0 0 0 0 0],0.6,[0 0 0 0 0 1 0 0 0],0.5});
trialDesig.circle.q3 = cat(1,{'circle',[1 0 0 0 0 0 0 0 0 0 0 0 0],0.6,[0 0 0 0 0 1 0 0 0],0.5},...
    {'circle',[0 0 1 0 0 0 0 0 0 0 0 0 0],0.6,[0 0 0 0 0 0 1 0 0],0.5});
trialDesig.circle.q4 = cat(1,{'circle',[1 0 0 0 0 0 0 0 0 0 0 0 0],0.6,[0 0 0 0 0 0 0 1 0],0.5},...
    {'circle',[0 0 1 0 0 0 0 0 0 0 0 0 0],0.6,[0 0 0 0 0 0 0 0 1],0.5});
files = LoadVar('CircleFiles');
 files = files(1,:);

fileExt = '_LinNear.eeg'
%fileExt = '_LinNearCSD121.csd'
selChans = load(['ChanInfo/SelectedChannels' fileExt '.txt']);
chanMat = LoadVar(['ChanInfo/ChanMat' fileExt '.mat']);
badChans = load(['ChanInfo/BadChan' fileExt '.txt']);
analDir = ['CalcRunningSpectra9_noExp_MidPoints_MinSpeed0Win626' fileExt];
anatCurvesName = 'ChanInfo/AnatCurves.mat';
offset = load(['ChanInfo/OffSet' fileExt '.txt']);
normBool = 1;
fs = LoadField([files(1,:) '/' analDir '/cohSpec.fo']);
maxFreq = 150;
thetaFreqRange = [6 12];
gammaFreqRange = [65 100];

data = LoadDesigVar(files,analDir,'powSpec.yo',trialDesig);

for j=1:length(selChans)
    selChanNames{j} = ['ch' num2str(selChans(j))];
    data.(selChanNames{j}) = LoadDesigVar(files,analDir,depVar = ['cohSpec.yo.' selChanNames{j}];,trialDesig);
end

ch = 37;
plotColors = [0 0 1;1 0 0;0 1 0;0 0 0];
figure(50)
fields = fieldnames(data);
catData = [];
for k=1:length(fields)
    catData = cat(1,catData,data.(fields{k}));
end
grandMean = mean(catData);
clf
%for j=1:size(data.returnArm,1)

    clf
    for m=1:length(selChans)
        subplot(1,length(selChans),m);
        hold on
        set(gca,'xlim',[0 150])
        fields = fieldnames(data);
        for k=1:length(fields)
            meanData = mean(log10(squeeze(data.(fields{k})(:,selChans(m),:))));
            stdData = std(log10(squeeze(data.(fields{k})(:,selChans(m),:))));
            plot(fs,meanData,'color',plotColors(k,:))
            plot(fs,meanData+stdData,':','color',plotColors(k,:))
            %plot(fs,meanData-stdData,':','color',plotColors(k,:))
            %plot(fs,log10(squeeze(data.(fields{k})(j,selChans(m),:))),'color',plotColors(k,:))
            %plot(fs,log10(squeeze(data.(fields{k})(j,selChans(m),:)./grandMean(1,selChans(m),:))),'color',plotColors(k,:))
        end
    end
%     in = input('any key to quit','s')
%     if ~isempty(in)
%         break;
%     end
% end
%     