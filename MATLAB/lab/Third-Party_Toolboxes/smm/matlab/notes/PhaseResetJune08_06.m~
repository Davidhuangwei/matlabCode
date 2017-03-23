trialDesig.returnArm = {{{'taskType','alter'},...
                        {'trialType',[1 0 1 0 0 0 0 0 0 0 0 0 0],'>',0.6},...
                        {'mazeLocation',[0 0 0 0 0 0 0 1 1],'>',0.6}}};
trialDesig.centerArm = {{{'taskType','alter'},...
                        {'trialType',[1 0 1 0 0 0 0 0 0 0 0 0 0],'>',0.6},...
                        {'mazeLocation',[0 0 0 0 1 0 0 0 0],'>',0.6}}};
trialDesig.Tjunction = {{{'taskType','alter'},...
                        {'trialType',[1 0 1 0 0 0 0 0 0 0 0 0 0],'>',0.6},...
                        {'mazeLocation',[0 0 0 1 0 0 0 0 0],'>',0.4}}};
trialDesig.goalArm = {{{'taskType','alter'},...
                        {'trialType',[1 0 1 0 0 0 0 0 0 0 0 0 0],'>',0.6},...
                        {'mazeLocation',[0 0 0 0 0 1 1 0 0],'>',0.6}}};
files = LoadVar('AlterFiles');
       
 contIndepCell = {};
        contVarSub = {};
        files = [LoadVar('RemFiles');LoadVar('MazeFiles')];
        trialDesig.maze = cat(1,{'alter',[1 0 1 0 0 0 0 0 0 0 0 0 0],0.6,[0 0 0 1 1 1 1 1 1],0.5},...
            {'circle',[1 0 1 0 0 0 0 0 0 0 0 0 0],0.6,[0 0 0 0 0 1 1 1 1],0.5});
        trialDesig.rem =  {'REM',[1 1 1 1 1 1 1 1 1 1 1 1 1],1,[1 1 1 1 1 1 1 1 1],1};
        trialMeanBool = 0;
        outlierDepth = 0;
        if strcmp(model,'whole');
            modelSpec = 1;
        else
            modelSpec = 1;
        end
        ssType = 3;
        adjDayMedBool = 1;
        adjDayZbool = 0;
        equalNbool = 1;

fileExt = '_LinNearCSD121.csd'
%fileExt = '_NearAveCSD1.csd'
%fileExt = '_LinNear.eeg'
%fileExt = '.eeg'
interpFunc = 'linear';
selChans = load(['ChanInfo/SelectedChannels' fileExt '.txt']);
selChanNames = {'Ca1Pyr','rad','LM','Mol','Gran','Ca3Pyr'};
chanMat = LoadVar(['ChanInfo/ChanMat' fileExt '.mat']);
badChans = load(['ChanInfo/BadChan' fileExt '.txt']);
%analDir = ['RemVsRun_noExp_MinSpeed0Win1250' fileExt]
analDir = ['CalcRunningSpectra9_noExp_MidPoints_MinSpeed0Win626' fileExt];
anatCurvesName = 'ChanInfo/AnatCurves.mat';
offset = load(['ChanInfo/OffSet' fileExt '.txt']);
normBool = 1;
fs = LoadField([files(1,:) '/' analDir '/powSpec.fo']);
maxFreq = 150;
thetaFreqRange = [6 12];
gammaFreqRange = [65 100];
%y = atanh(x*2-1)./(max(atanh(x*2-1))*2) + 0.5


eegTrace = [];
eegTrace = LoadDesigVar(files,analDir,'rawTrace' ,trialDesig);

pos = [];
pos = LoadDesigVar(files,analDir,'position.p0' ,trialDesig);

pixPerCm = 20.58/11;
whl = load([files(2,:) '/' files(2,:) '.whl']);

trials = 1:38;
clf
plot(whl(:,1)./pixPerCm,whl(:,2)./pixPerCm,'.','color',[0.5 0.5 0.5])
hold on
plot(pos.goalArm(trials,1)./pixPerCm,pos.goalArm(trials,2)./pixPerCm,'.')     
plot(pos.Tjunction(trials,1)./pixPerCm,pos.Tjunction(trials,2)./pixPerCm,'.') 
plot(pos.returnArm(trials,1)./pixPerCm,pos.returnArm(trials,2)./pixPerCm,'.') 
plot(pos.centerArm(trials,1)./pixPerCm,pos.centerArm(trials,2)./pixPerCm,'.') 
% plot(pos.goalArm(trials,1)./pixPerCm,pos.goalArm(trials,2)./pixPerCm,'k.')     
% plot(pos.Tjunction(trials,1)./pixPerCm,pos.Tjunction(trials,2)./pixPerCm,'g.') 
% plot(pos.returnArm(trials,1)./pixPerCm,pos.returnArm(trials,2)./pixPerCm,'b.') 
% plot(pos.centerArm(trials,1)./pixPerCm,pos.centerArm(trials,2)./pixPerCm,'r.') 
set(gcf,'name','PhaseSpace');
ReportFigSM(1,'/u12/smm/public_html/NewFigs/PhaseSpace/')

clf
fields = fieldnames(eegTrace);
for j=1:length(fields)
    for k=1:length(selChans);
        subplot(length(selChans),length(fields),(k-1)*length(fields)+j)
        hold on
        plot(squeeze(eegTrace.(fields{j})(trials,selChans(k),:))');
        plot(313,squeeze(eegTrace.centerArm(trials,selChans(k),313)),'.')
        set(gca,'ylim',[-4000 4000])
        if k==1
            title(fields{j})
        end
    end
end

sampl = 1250;
lowband = 60;
highband = 120;
forder = 626;
fieldDesig = 'returnArm';
clear filtered_data
clear filtHilbAngle
firfiltb = fir1(forder,[lowband/sampl*2,highband/sampl*2]); % band-pass filter
for j=trials
    filtered_data(j,:,:) = Filter0(firfiltb, squeeze(eegTrace.(fieldDesig)(j,:,:))');
    %size(filtered_data)
    filtHilbAngle(j,:,:) = angle(hilbert(squeeze(filtered_data(j,:,:))));
    %size(filtered_data)
end
filtered_data = permute(filtered_data,[1,3,2]);
filtHilbAngle = permute(filtHilbAngle,[1,3,2]);

figure(2)
clf
for k=1:length(selChans);
    subplot(length(selChans),1,k)
    if k==1
        title('filt')
    end
    hold on
    %plot(pos.(fieldDesig)(trials,1)./pixPerCm,squeeze(eegTrace.(fieldDesig)(trials,selChans(k),313)),'.')
    plot(pos.(fieldDesig)(trials,1)./pixPerCm,squeeze(filtered_data(trials,selChans(k),313)),'.')
    %plot(pos.(fieldDesig)(trials,1)./pixPerCm,squeeze(filtHilbAngle(trials,selChans(k),313)),'.')
    %plot(squeeze(eegTrace.(fields{j})(trials,selChans(k),:))');
    %set(gca,'ylim',[-4000 4000])
    %if k==1
    %    title(fields{j})
    %end
end
set(gcf,'name','PhaseSpace');
ReportFigSM(2,'/u12/smm/public_html/NewFigs/PhaseSpace/',[],[],{fieldDesig})

figure(3)
clf
for k=1:length(selChans);
    subplot(length(selChans),1,k)
    if k==1
        title('hilb')
    end
    hold on
    %plot(pos.(fieldDesig)(trials,1)./pixPerCm,squeeze(eegTrace.(fieldDesig)(trials,selChans(k),313)),'.')
    %plot(pos.(fieldDesig)(trials,1)./pixPerCm,squeeze(filtered_data(trials,selChans(k),313)),'.')
    plot(pos.(fieldDesig)(trials,1)./pixPerCm,squeeze(filtHilbAngle(trials,selChans(k),313)),'.')
    %plot(squeeze(eegTrace.(fields{j})(trials,selChans(k),:))');
    %set(gca,'ylim',[-4000 4000])
    %if k==1
    %    title(fields{j})
    %end
end
set(gcf,'name','PhaseSpace');
ReportFigSM(2,'/u12/smm/public_html/NewFigs/PhaseSpace/',[],[],{fieldDesig})


figure(4)
clf
for k=1:length(selChans);
    subplot(length(selChans),1,k)
    if k==1
        title('eeg')
    end
    hold on
    plot(pos.(fieldDesig)(trials,1)./pixPerCm,squeeze(eegTrace.(fieldDesig)(trials,selChans(k),313)),'.')
    %plot(pos.(fieldDesig)(trials,1)./pixPerCm,squeeze(filtered_data(trials,selChans(k),313)),'.')
    %plot(pos.(fieldDesig)(trials,1)./pixPerCm,squeeze(filtHilbAngle(trials,selChans(k),313)),'.')
    %plot(squeeze(eegTrace.(fields{j})(trials,selChans(k),:))');
    %set(gca,'ylim',[-4000 4000])
    %if k==1
    %    title(fields{j})
    %end
end
set(gcf,'name','PhaseSpace');
ReportFigSM(4,'/u12/smm/public_html/NewFigs/PhaseSpace/',[],[],{fieldDesig})



figure(5)
clf
for k=1:length(selChans);
    subplot(length(selChans),1,k)
    plot(squeeze(eegTrace.(fieldDesig)(trials(1),selChans(k),:)))
    hold on
    plot(squeeze(filtHilbAngle(trials(1),selChans(k),:))*100,'g')
    plot(squeeze(filtered_data(trials(1),selChans(k),:)),'r')
    set(gca,'xlim',[0 626])
end
set(gcf,'name','PhaseSpace');
ReportFigSM(5,'/u12/smm/public_html/NewFigs/PhaseSpace/',[],[],{fieldDesig})

trials = 1:38;
clear thetaFilt
clear gammaFilt
clear gammaPow
fields = fieldnames(eegTrace)
for k=1:length(fields)
    sampl = 1250;
    thetaBand = [6 12];
    gammaBand = [60 120];
    forder = 626;
    fieldDesig = 'returnArm';
    thetafirfiltb = fir1(forder,[thetaBand(1)/sampl*2,thetaBand(2)/sampl*2]); % band-pass filter
    gammafirfiltb = fir1(forder,[gammaBand(1)/sampl*2,gammaBand(2)/sampl*2]); % band-pass filter
    avgfiltb = ones(63,1)/(63); % smoothing filter
    for j=trials
        thetaFilt.(fields{k})(j,:,:) = Filter0(thetafirfiltb, squeeze(eegTrace.(fields{k})(j,:,:))');
        gammaFilt.(fields{k})(j,:,:) = Filter0(gammafirfiltb, squeeze(eegTrace.(fields{k})(j,:,:))');
        gammaPow.(fields{k})(j,:,:) = 10.*log10(Filter0(avgfiltb,squeeze(abs(gammaFilt.(fields{k})(j,:,:)).^2)));
        %size(thetaFilt)
        %filtHilbAngle.(fields{k})(j,:,:) = angle(hilbert(squeeze(thetaFilt.(fields{k})(j,:,:))));
        %size(thetaFilt)
    end
    thetaFilt.(fields{k}) = permute(thetaFilt.(fields{k}),[1,3,2]);
    gammaFilt.(fields{k}) = permute(gammaFilt.(fields{k}),[1,3,2]);
    gammaPow.(fields{k}) = permute(gammaPow.(fields{k}),[1,3,2]);
    %filtHilbAngle.(fields{k}) = permute(filtHilbAngle.(fields{k}),[1,3,2]);
end
figure(5)
clf
for m=1:length(trials)
    clf
    for j=1:length(fields)
        for k=1:length(selChans);
            subplot(length(selChans),length(fields),(k-1)*length(fields)+j)
            plot(squeeze(eegTrace.(fields{j})(trials(m),selChans(k),:)),'color',[0.75 0.75 0.75])
            hold on
            %plot(squeeze(filtHilbAngle.(fields{j})(trials(m),selChans(k),:))*100,'g')
            plot(squeeze(gammaFilt.(fields{j})(trials(m),selChans(k),:)).*2,'g')
            plot((squeeze(gammaPow.(fields{j})(trials(m),selChans(k),:))-mean(squeeze(gammaPow.(fields{j})(trials(m),selChans(k),:))))*200,'r')
            plot(squeeze(thetaFilt.(fields{j})(trials(m),selChans(k),:)),'b')
           set(gca,'xlim',[0 626],'ylim',[-4000 4000],'xtick',[1:626/10:626])
            if k==1 
                title(fields{j})
            end
            grid on
        end
    end
    in = input('anything quits:','s');
    if ~isempty(in)
        break
    end
end
clear offSet
for m=1:length(trials)
    for j=1:length(fields)
        for k=1:length(selChans)
            lmin = LocalMinima(squeeze(thetaFilt.(fields{j})(trials(m),selChans(k),:)),60,0);
            offSet.(fields{j})(trials(m),k) = 313-lmin(find(abs(lmin-313)==min(abs(lmin-313)),1));
        end
    end
end
for j=1:length(fields)
    max(max(abs(offSet.(fields{j}))))
end

figure(5)
clf
selCh
for m=1:length(trials)
for j=1:length(fields)
    for k=1:length(selChans);
        subplot(length(selChans),length(fields),(k-1)*length(fields)+j)
        %plot([1:626]+offSet.(fields{j})(trials(m),k),squeeze(eegTrace.(fields{j})(trials(m),selChans(k),:)),'color',[0.75 0.75 0.75])
        hold on
        %plot(squeeze(filtHilbAngle.(fields{j})(trials(m),selChans(k),:))*100,'g')
        %plot([1:626]+offSet.(fields{j})(trials(m),k),squeeze(gammaFilt.(fields{j})(trials(m),selChans(k),:)).*2,'g')
        plot([1:626]+offSet.(fields{j})(trials(m),k),(squeeze(gammaPow.(fields{j})(trials(m),selChans(k),:))-mean(squeeze(gammaPow.(fields{j})(trials(m),selChans(k),:))))*200,'r')
        plot([1:626]+offSet.(fields{j})(trials(m),k),squeeze(thetaFilt.(fields{j})(trials(m),selChans(k),:)),'b')
        set(gca,'xlim',[0 626],'ylim',[-4000 4000],'xtick',[1:626/10:626])
        if k==1
            title(fields{j})
        end
        grid on
    end
end
end


in = input('anything quits:','s');
if ~isempty(in)
    break
end

% for j=1:length(fields)
%     alignGammaPow.(fields{j}) = zeros(length(selChans),626+200,1);
% end
clear alignGammaPow
clear alignThetaFilt
clear alignEEG
for m=1:length(trials)
for j=1:length(fields)
    for k=1:length(selChans);
        alignGammaPow.(fields{j})(trials(m),k,[150+offSet.(fields{j})(trials(m),k):150+offSet.(fields{j})(trials(m),k)+625]) = squeeze(gammaPow.(fields{j})(trials(m),selChans(k),:));
        alignThetaFilt.(fields{j})(trials(m),k,[150+offSet.(fields{j})(trials(m),k):150+offSet.(fields{j})(trials(m),k)+625]) = squeeze(thetaFilt.(fields{j})(trials(m),selChans(k),:));
        alignEEG.(fields{j})(trials(m),k,[150+offSet.(fields{j})(trials(m),k):150+offSet.(fields{j})(trials(m),k)+625]) = squeeze(eegTrace.(fields{j})(trials(m),selChans(k),:));
        %plot([1:626]+offSet.(fields{j})(trials(m),k),squeeze(eegTrace.(fields{j})(trials(m),selChans(k),:)),'color',[0.75 0.75 0.75])
        %plot(squeeze(filtHilbAngle.(fields{j})(trials(m),selChans(k),:))*100,'g')
        %plot([1:626]+offSet.(fields{j})(trials(m),k),squeeze(gammaFilt.(fields{j})(trials(m),selChans(k),:)).*2,'g')
%         plot([1:626]+offSet.(fields{j})(trials(m),k),(squeeze(gammaPow.(fields{j})(trials(m),selChans(k),:))-mean(squeeze(gammaPow.(fields{j})(trials(m),selChans(k),:))))*200,'r')
%         plot([1:626]+offSet.(fields{j})(trials(m),k),squeeze(thetaFilt.(fields{j})(trials(m),selChans(k),:)),'b')
%         set(gca,'xlim',[0 626],'ylim',[-4000 4000],'xtick',[1:626/10:626])
%         if k==1
%             title(fields{j})
%         end
%         grid on
    end
end
end

figure(5)
clf
for j=1:length(fields)
    for k=1:length(selChans);
        subplot(length(selChans),length(fields),(k-1)*length(fields)+j)
        hold on
plot(squeeze(mean(alignEEG.(fields{j})(:,k,:))),'color',[0.75 0.75 0.75])
plot(squeeze(mean(alignThetaFilt.(fields{j})(:,k,:))))
plot(squeeze(mean(alignGammaPow.(fields{j})(:,k,:))-mean(mean(alignGammaPow.(fields{j})(:,k,200:600)),3)).*400,'r')
stDev = std(alignGammaPow.(fields{j})(:,:,:));
plot(squeeze(mean(alignGammaPow.(fields{j})(:,k,:))-mean(mean(alignGammaPow.(fields{j})(:,k,200:600)),3)-stDev(:,k,:)).*400,':g')
plot(squeeze(mean(alignGammaPow.(fields{j})(:,k,:))-mean(mean(alignGammaPow.(fields{j})(:,k,200:600)),3)+stDev(:,k,:)).*400,':g')

set(gca,'ylim',[-2000 2000],'xtick',[0:626/5:800])
grid on
        if k==1
            title(fields{j})
        end
if j==1
    ylabel(selChanNames{k});
end
    end
end

set(gcf,'name','PhaseSpace');
ReportFigSM(5,'/u12/smm/public_html/NewFigs/PhaseSpace/',[],[],{fileExt})




for k=1:length(selChans);
    subplot(length(selChans),1,k)
    if k==1
        title('hilb')
    end
    hold on
    %plot(pos.(fieldDesig)(trials,1)./pixPerCm,squeeze(eegTrace.(fieldDesig)(trials,selChans(k),313)),'.')
    plot(squeeze(filtHilbAngle(trials,selChans(k),:))')
    %plot(pos.(fieldDesig)(trials,1)./pixPerCm,squeeze(filtHilbAngle(trials,selChans(k),313)),'.')
    %plot(squeeze(eegTrace.(fields{j})(trials,selChans(k),:))');
    %set(gca,'ylim',[-4000 4000])
    %if k==1
    %    title(fields{j})
    %end
end
set(gcf,'name','PhaseSpace');

clf
fields = fieldnames(eegTrace);
for j=1:length(fields)
    for k=1:length(selChans);
        subplot(length(selChans),length(fields),(k-1)*length(fields)+j)
        hold on
        plot(squeeze(eegTrace.(fields{j})(trials,selChans(k),:))');
        %plot(313,squeeze(eegTrace.(fieldDesig)(trials,selChans(k),313)),'.')
        set(gca,'ylim',[-4000 4000])
        if k==1
            title(fields{j})
        end
    end
end

data = [];
for j=1:length(selChans)
    selChanNames{j} = ['ch' num2str(selChans(j))];
    data.(selChanNames{j}) = LoadDesigVar(files,analDir,['cohSpec.yo.' selChanNames{j}] ,trialDesig);
end
thetaCohLMF = [];
for j=1:length(selChans)
    selChanNames{j} = ['ch' num2str(selChans(j))];
    thetaCohLMF.(selChanNames{j}) = LoadDesigVar(files,analDir,['thetaCohPeakLMF4-12Hz.' selChanNames{j}] ,trialDesig);
end
thetaCohSelChF = [];
for j=1:length(selChans)
    selChanNames{j} = ['ch' num2str(selChans(j))];
    thetaCohSelChF.(selChanNames{j}) = LoadDesigVar(files,analDir,['thetaCohPeakSelChF4-12Hz.' selChanNames{j}] ,trialDesig);
end




thetaFreq = [];
thetaFreq = LoadDesigVar(files,analDir,'thetaFreq' ,trialDesig);

junk = max(thetaFreq.rem(:,selChans)')-min(thetaFreq.rem(:,selChans)');

behav = 'maze';
freqRange = [4 12];
chan = 42
clf
for j=1:length(selChans)
    subplot(length(selChans),1,j)
    selChanName = ['ch' num2str(selChans(j))]
    hold on
    pcolor(1:size(data.(selChanName).(behav),1),squeeze(fs(fs>freqRange(1) & fs<freqRange(2))),...
        squeeze(data.(selChanName).(behav)(:,chan,(fs>freqRange(1) & fs<freqRange(2))))');
    shading interp
    %plot(thetaFreq.rem(:,selChans(j)))
    plot(thetaCohLMF.(selChanName).(behav)(:,chan)*2+3)
    plot(thetaCohSelChF.(selChanName).(behav)(:,chan)*2+3,':')
    %set(gca,'ylim',[4 12])
end

powSpec = [];
powSpec = LoadDesigVar(files,analDir,'powSpec.yo' ,trialDesig);
thetaFreqRange = [4 12];
fields = fieldnames(powSpec);
fRange = find(fs>=thetaFreqRange(1) & fs<=thetaFreqRange(2));
for f=1:length(fields)
    for t=1:size(powSpec.(fields{f}),1)
        for c=1:size(powSpec.(fields{f}),2)
            temp = LocalMinima(-powSpec.(fields{f})(t,c,fRange),length(fRange));
            if isempty(temp)
                temp = NaN;
                %[junk temp] = max(powSpec.(fields{f})(t,c,fRange));
            end
            if isnan(temp)
                thetaFreqNew.(fields{f})(t,c) = NaN;
            else
                thetaFreqNew.(fields{f})(t,c) = fs(temp-1+fRange(1));
            end
        end
    end
end
behav = 'rem';
chan = 37;
freqRange = thetaFreqRange;
figure
for j=1:length(selChans)
    subplot(length(selChans),1,j)
    pcolor(1:size(powSpec.(behav),1),squeeze(fs(fs>freqRange(1) & fs<freqRange(2))),...
        squeeze(powSpec.(behav)(:,selChans(j),(fs>freqRange(1) & fs<freqRange(2))))');
    shading interp
    hold on
    plot(thetaFreqNew.(behav)(:,selChans(j)))
end
junk = max(thetaFreqNew.maze(:,setdiff(1:96,badChans)),[],2)-min(thetaFreqNew.maze(:,setdiff(1:96,badChans)),[],2);
           
size(find(thetaFreqNew.(behav)(:,selChans)==fs(1)))     


behav = 'rem';

freqRange = [60 120];
% refChan = 2;
% chan = 53;
% factor = 20;
% offset = 80;
freqRange = [4 12];
factor = 3;
offset = 7.5;
refChan = 4;
chan = 37;

thetaFreqRange = [4 12]
gammaFreqRange = [60 120];
for j=1:size(data.(selChanNames{refChan}).(behav),1)
    clf 
    subplot(2,1,1)
    hold on
    plot(fs,squeeze(data.(selChanNames{refChan}).(behav)(j,chan,:)))
    set(gca,'xlim',[0 16],'ylim',[-2 3])
    grid on
 
    subplot(2,1,2)
    hold on
    plot(fs,squeeze(data.(selChanNames{refChan}).(behav)(j,chan,:)))
    set(gca,'xlim',[40 150],'ylim',[-2 1])
    grid on
    in = input('anything quits:','s');
    if ~isempty(in)
        break
    end
end    

  %%%% theta Peak %%%%%%   
figure
pcolor(1:size(data.(selChanNames{refChan}).(behav),1),squeeze(fs(fs>freqRange(1) & fs<freqRange(2))),...
    squeeze(data.(selChanNames{refChan}).(behav)(:,chan,(fs>freqRange(1) & fs<freqRange(2))))');
%pcolor(squeeze(data.(selChanNames{refChan}).(behav)(:,chan,(fs>freqRange(1) & fs<freqRange(2)))));
hold on
absDiff = abs(squeeze(data.(selChanNames{refChan}).(behav)(:,chan,(fs>freqRange(1) & fs<freqRange(2))))...
    -repmat(thetaCohMed.(selChanNames{refChan}).(behav)(:,chan),1,length(find(fs>freqRange(1) & fs<freqRange(2)))));
for j=1:size(absDiff,1)
    fsNew = fs(fs>freqRange(1) & fs<freqRange(2));
    thetaCohMedFreq(j) = fsNew(find(absDiff(j,:) == min(absDiff(j,:)),1));
end
%plot(thetaCohMedFreq,'.')
title(['peak ' behav fileExt])
shading interp
colorbar
for j=1:size(thetaFreq.(behav),1)
peakN(j) = find(abs(fs-thetaFreq.(behav)(j,selChans(refChan))) == min(abs(fs-thetaFreq.(behav)(j,selChans(refChan)))),1);
peakCoh(j) = data.(selChanNames{refChan}).(behav)(j,chan,peakN(j));
end
%plot(fs(peakN))
plot(peakCoh*2+5)
%plot(thetaCohMean.(selChanNames{refChan}).(behav)(:,chan)*factor+7,':')
   
    
 %%%% median %%%%%%   
figure
pcolor(1:size(data.(selChanNames{refChan}).(behav),1),squeeze(fs(fs>freqRange(1) & fs<freqRange(2))),...
    squeeze(data.(selChanNames{refChan}).(behav)(:,chan,(fs>freqRange(1) & fs<freqRange(2))))');
%pcolor(squeeze(data.(selChanNames{refChan}).(behav)(:,chan,(fs>freqRange(1) & fs<freqRange(2)))));
hold on
absDiff = abs(squeeze(data.(selChanNames{refChan}).(behav)(:,chan,(fs>freqRange(1) & fs<freqRange(2))))...
    -repmat(thetaCohMed.(selChanNames{refChan}).(behav)(:,chan),1,length(find(fs>freqRange(1) & fs<freqRange(2)))));
for j=1:size(absDiff,1)
    fsNew = fs(fs>freqRange(1) & fs<freqRange(2));
    thetaCohMedFreq(j) = fsNew(find(absDiff(j,:) == min(absDiff(j,:)),1));
end
plot(thetaCohMedFreq,'.')
title(['median ' behav fileExt])
shading interp
colorbar
plot(thetaCohMed.(selChanNames{refChan}).(behav)(:,chan)*factor+offset)
%plot(thetaCohMean.(selChanNames{refChan}).(behav)(:,chan)*factor+7,':')

%%%%% mean %%%%%%%
figure
pcolor(1:size(data.(selChanNames{refChan}).(behav),1),squeeze(fs(fs>freqRange(1) & fs<freqRange(2))),...
    squeeze(data.(selChanNames{refChan}).(behav)(:,chan,(fs>freqRange(1) & fs<freqRange(2))))');
%pcolor(squeeze(data.(selChanNames{refChan}).(behav)(:,chan,(fs>freqRange(1) & fs<freqRange(2)))));
hold on
absDiff = abs(squeeze(data.(selChanNames{refChan}).(behav)(:,chan,(fs>freqRange(1) & fs<freqRange(2))))...
    -repmat(thetaCohMean.(selChanNames{refChan}).(behav)(:,chan),1,length(find(fs>freqRange(1) & fs<freqRange(2)))));
for j=1:size(absDiff,1)
    fsNew = fs(fs>freqRange(1) & fs<freqRange(2));
    thetaCohMeanFreq(j) = fsNew(find(absDiff(j,:) == min(absDiff(j,:)),1));
end
plot(thetaCohMeanFreq,'.')
title(['mean ' behav fileExt ])
shading interp
colorbar
plot(thetaCohMean.(selChanNames{refChan}).(behav)(:,chan)*factor+offset)

ReportFigSM([1 2],'/u12/smm/public_html/temp/')
thetaCohMedian.(selChanNames{refChan}) = squeeze(median(data.(selChanNames{refChan}).(behav)(:,:,find(fs>=4 & fs<=12)),3));
thetaCohMean.(selChanNames{refChan}) = squeeze(mean(waveCoh(:,:,find(fo>=4 & fo<=12)),3));

figure
hold on
for j=1:size(data.(selChanNames{refChan}).(behav),1)
    clf 
    hold on
    plot(fs,squeeze(data.(selChanNames{refChan}).(behav)(j,chan,:)))
    set(gca,'xlim',[0 16],'ylim',[-3 3])
    grid on
    plot([thetaCohMedFreq(j) thetaCohMedFreq(j)],get(gca,'ylim'),'r')
    plot(get(gca,'xlim'),[thetaCohMed.(selChanNames{refChan})(j,chan) thetaCohMed.(selChanNames{refChan})(j,chan)],'r')
    medTemp = median(squeeze(data.(selChanNames{refChan}).(behav)(j,chan,find(fs>=4 & fs<=12))));
    plot(get(gca,'xlim'),[medTemp medTemp],':k')
    plot([thetaFreq.(behav)(j,chan) thetaFreq.(behav)(j,chan)],get(gca,'ylim'),'g')
    plot([thetaFreq.(behav)(j,selChans(refChan)) thetaFreq.(behav)(j,selChans(refChan))],get(gca,'ylim'),'--b')
    in = input('anything quits:','s')
    if ~isempty(in)
        break
    end
end


%%% pow %%%%
refChan = 2;
%grandMean = repmat(1,1,size(data.maze,2));
grandMean = mean(cat(1,data.maze,data.rem));
%colorLimits = [75 85]
colorLimits = [0.9 1.1]
figure
subplot(2,1,1)
imagesc([data.maze(:,selChans)./repmat(grandMean(selChans),size(data.maze(:,selChans),1),1)]');
set(gca,'xlim',[1,length(data.rem)]);
title([fileExt ' maze'])
set(gca,'clim',colorLimits)
colorbar
subplot(2,1,2)
imagesc([data.rem(:,selChans)./repmat(grandMean(selChans),size(data.rem(:,selChans),1),1)]');
set(gca,'xlim',[1,length(data.rem)]);
title([fileExt ' maze'])
set(gca,'clim',colorLimits)
colorbar


%%%% coh %%%%
refChan = 2;
grandMean = mean(cat(1,data.(selChanNames{refChan}).maze,data.(selChanNames{refChan}).rem));
colorLimits = [0 2]
figure
subplot(2,1,1)
imagesc([data.(selChanNames{refChan}).maze(:,selChans)./repmat(grandMean(selChans),size(data.(selChanNames{refChan}).maze(:,selChans),1),1)]');
set(gca,'xlim',[1,length(data.(selChanNames{refChan}).rem)]);
title([fileExt ' maze'])
set(gca,'clim',colorLimits)
colorbar
subplot(2,1,2)
imagesc([data.(selChanNames{refChan}).rem(:,selChans)./repmat(grandMean(selChans),size(data.(selChanNames{refChan}).rem(:,selChans),1),1)]');
set(gca,'xlim',[1,length(data.(selChanNames{refChan}).rem)]);
title([fileExt ' maze'])
set(gca,'clim',colorLimits)
colorbar


figure
subplot(2,1,1)
imagesc(Make2DPlotMat(squeeze(mean(data.(selChanNames{refChan}).maze)),chanMat,badChans,interpFunc));
title([fileExt ' maze'])
PlotAnatCurves(anatCurvesName,[16.5 6.5],offset)
set(gca,'clim',colorLimits)
colorbar
subplot(2,1,2)
imagesc(Make2DPlotMat(squeeze(mean(data.(selChanNames{refChan}).rem)),chanMat,badChans,interpFunc));
title([fileExt ' maze'])
PlotAnatCurves(anatCurvesName,[16.5 6.5],offset)
set(gca,'clim',colorLimits)
colorbar

figure
for j=1:length(selChans)
    subplot(2,length(selChans),j)
hist(data.(selChanNames{refChan}).maze(:,selChans(j)))
set(gca,'xlim',[-1 3])
title([fileExt ' maze'])

subplot(2,length(selChans),j+length(selChans))
hist(data.(selChanNames{refChan}).rem(:,selChans(j)))
title([fileExt ' rem'])
set(gca,'xlim',[-1 3])
end

figure(4)
mazeRegions = fieldnames(data);
for k=1:30
    clf
    for j=1:length(mazeRegions)
        subplot(1,length(mazeRegions),j)
        hold on
        grid on
        for m=1:length(selChans)
            plot(squeeze(data.(mazeRegions{j})(k,selChans(m),:))-m*5000)
        end
        title(mazeRegions{j})
    end
    in = input('anything quits:','s')
    if ~isempty(in)
        break
    end
end


figure(1)
clf
colormap(LoadVar('CircularColorMap.mat'))
refChans = fieldnames(data);
for j=1:length(refChans)
    mazeRegions = fieldnames(data.(refChans{j}));
    for k=1:length(mazeRegions)
        subplot(length(refChans),length(mazeRegions),(j-1)*length(mazeRegions)+k)
        imagesc(Make2DPlotMat(angle(mean(data.(refChans{j}).(mazeRegions{k}))),chanMat,badChans,interpFunc));
        colorbar
        PlotAnatCurves(anatCurvesName,[16.5 6.5],offset)
        if k==1
            ylabel(refChans{j})
        end
        if j==1
            title(mazeRegions{k})
        end
    end
end

junk = cat(2,data.(refChans{2}).(mazeRegions{1})(:,37),data.(refChans{2}).(mazeRegions{2})(:,37));
junk = cat(2,data.(refChans{2}).(mazeRegions{1})(:,37),data.(refChans{2}).(mazeRegions{2})(:,37));


figure(2)
clf
chan = 48;
%plotColors = ['b','r','g','k'];
plotColors = [0 0 1;1 0 0;0 1 0;0 0 0];
colormap(LoadVar('ColorMapSean6.mat'))
refChans = fieldnames(data);
for j=1:length(refChans)
    mazeRegions = fieldnames(data.(refChans{j}));
    allReg = [];
    for k=1:length(mazeRegions)
        %meanReg(k) = mean(data.(refChans{j}).(mazeRegions{k}));
        allReg = cat(1,allReg,data.(refChans{j}).(mazeRegions{k}));
    end
    size(allReg);
        angle(mean(allReg(:,chan)));
         subplot(length(refChans),1,j)
         get(gca,'colororder');
         temp2 = [];
   for k=1:length(mazeRegions)
        %subplot(length(refChans),length(mazeRegions),(j-1)*length(mazeRegions)+k)
        temp = angle(data.(refChans{j}).(mazeRegions{k}))-repmat(angle(mean(allReg)),size(data.(refChans{j}).(mazeRegions{k}),1),1);
        temp = angle((complex(cos(temp),sin(temp))));
        temp2 = cat(2,temp2,permute(temp,[1 3 2]));
    end
        hist(temp2(:,:,chan),5,1)
         %set(gca,'colororder',plotColors)
        %imagesc(Make2DPlotMat(temp,chanMat,badChans));
        %set(gca,'clim',[-pi/8 pi/8])
        set(gca,'xlim',[-pi pi],'ylim',[0 25]);
        %colorbar
        %PlotAnatCurves(anatCurvesName,[16.5 6.5],offset)
        %if k==1
            ylabel(refChans{j})
        %end
        %if j==1
        %    title(mazeRegions{k})
        %end
    %end
end


figure(3)
clf
colormap(LoadVar('ColorMapSean6.mat'))
refChans = fieldnames(data);
for j=1:length(refChans)
    mazeRegions = fieldnames(data.(refChans{j}));
    allReg = [];
    for k=1:length(mazeRegions)
        %meanReg(k) = mean(data.(refChans{j}).(mazeRegions{k}));
        allReg = cat(1,allReg,data.(refChans{j}).(mazeRegions{k}));
    end
    for k=1:length(mazeRegions)
        subplot(length(refChans),length(mazeRegions),(j-1)*length(mazeRegions)+k)
        temp = angle(data.(refChans{j}).(mazeRegions{k}))-repmat(angle(mean(allReg)),size(data.(refChans{j}).(mazeRegions{k}),1),1);
        temp = angle(mean(complex(cos(temp),sin(temp))));
        imagesc(Make2DPlotMat(temp./pi.*360,chanMat,badChans,interpFunc));
        set(gca,'clim',[-50 50]);
        colorbar
        PlotAnatCurves(anatCurvesName,[16.5 6.5],offset)
        if k==1
            ylabel(refChans{j})
        end
        if j==1
            title(mazeRegions{k})
        end
    end
end

figure(2)
clf
colormap(LoadVar('ColorMapSean6.mat'))
refChans = fieldnames(data);
for j=1:length(refChans)
    mazeRegions = fieldnames(data.(refChans{j}));
    allReg = [];
    for k=1:length(mazeRegions)
        allReg = cat(1,allReg,data.(refChans{j}).(mazeRegions{k}));
    end
    size(allReg);
        angle(mean(allReg(:,37)));
    for k=1:length(mazeRegions)
        subplot(length(refChans),length(mazeRegions),(j-1)*length(mazeRegions)+k)
        rose(angle(data.(refChans{j}).(mazeRegions{k})(:,34))-angle(mean(allReg(:,34))),40);
        if k==1
            ylabel(refChans{j})
        end
        if j==1
            title(mazeRegions{k})
        end
    end
end



plot(real(data.(refChans{j}).(mazeRegions{k})(:,37)),imag(data.(refChans{j}).(mazeRegions{k})(:,37)),'.')


allThetaMed = [];
allGammaMed = [];
for j=1:length(selChans) 
    fields = fieldnames(data.(selChanNames{j}));
    for k=1:length(fields)
        dataAtanh.(selChanNames{j}).(fields{k}) = atanh((data.(selChanNames{j}).(fields{k})-0.5)*1.999);
        dataAtanhSq.(selChanNames{j}).(fields{k}) = atanh(((data.(selChanNames{j}).(fields{k})).^2-0.5)*1.999);
        %thetaMed.(selChanNames{j}).(fields{k}) = squeeze(atanh((median(data.(selChanNames{j}).(fields{k})(:,:,find(fs>=thetaFreqRange(1) & fs<=thetaFreqRange(2))),3)-0.5)*1.999));
        %thetaMed.(selChanNames{j}).(fields{k}) = squeeze(median(data.(selChanNames{j}).(fields{k})(:,:,find(fs>=thetaFreqRange(1) & fs<=thetaFreqRange(2))),3));
        %thetaMed.(selChanNames{j}).(fields{k}) = squeeze(median(data.(selChanNames{j}).(fields{k})(:,:,find(fs>=thetaFreqRange(1) & fs<=thetaFreqRange(2))),3));
        %allThetaMed = cat(1,allThetaMed,thetaMed.(selChanNames{j}).(fields{k}));
        %gammaMed.(selChanNames{j}).(fields{k}) = squeeze(atanh((median(data.(selChanNames{j}).(fields{k})(:,:,find(fs>=gammaFreqRange(1) & fs<=gammaFreqRange(2))),3)-0.5)*1.999));
        %gammaMed.(selChanNames{j}).(fields{k}) = squeeze(median(data.(selChanNames{j}).(fields{k})(:,:,find(fs>=gammaFreqRange(1) & fs<=gammaFreqRange(2))),3));
        %gammaMed.(selChanNames{j}).(fields{k}) = squeeze(median(data.(selChanNames{j}).(fields{k})(:,:,find(fs>=gammaFreqRange(1) & fs<=gammaFreqRange(2))),3));
        %allGammaMed = cat(1,allGammaMed,gammaMed.(selChanNames{j}).(fields{k}));           
    end
end
speed = LoadDesigVar(files,analDir,'speed.p0',trialDesig);
accel = LoadDesigVar(files,analDir,'accel.p0',trialDesig);
plotColors = [0 0 1;1 0 0;0 1 0;0 0 0];
clf
f = 37;
selChans2 = [40 53 55 57 46 79];
for j=1:length(selChans)
    for k=1:length(selChans2)
        subplot(length(selChans),length(selChans2),(k-1)*length(selChans)+j);
        hold on
        fields = fieldnames(data.(selChanNames{j}));
        for m=1:length(fields)
            plot(accel.(fields{m}),data.(selChanNames{j}).(fields{m})(:,selChans2(k),f),'.','color',plotColors(m,:));
        end
        if k==1
            title(selChanNames{j});
        end
        if j==1
            ylabel(num2str(selChans2(k)));
        end
        %ylabel(selChanNames{j});
        %title(num2str(selChans2(k)));
        %set(gca,'xlim',[0 150],'ylim',[-2 3]);
        %set(gca,'xlim',[0 150])
        set(gcf,'name',num2str(fs(f)));
    end
end




for j=1:length(selChans) 
    fields = fieldnames(data.(selChanNames{j}));
    for k=1:length(fields)
        sigCoh.(selChanNames{j}).(fields{k}) = atanh((data.(selChanNames{j}).(fields{k})-0.5)*1.999);
    end
end
hist(sigCoh.(selChanNames{1}).(fields{1})(:,37,39))
for j=1:length(selChans) 
    fields = fieldnames(data.(selChanNames{j}));
    for k=1:length(fields)
        for ch=1:96
            for f=1:109
                yNormPsSigCoh.(selChanNames{j}).(fields{k})(ch,f) = TestNormality(sigCoh.(selChanNames{j}).(fields{k})(:,ch,f));
                yNormPs.(selChanNames{j}).(fields{k})(ch,f) = TestNormality(data.(selChanNames{j}).(fields{k})(:,ch,f));
            end
        end
    end
end

%for j=2:2
for j=1:length(selChans)
    nextFig = j;
    for k=1:length(fields)
        a = yNormPsSigCoh.(selChanNames{j}).(fields{k});
        a(find(a==0)) = 1.1e-16;
        plotData(k,:,:) =  log10(a);
    end
    %log10Bool = 1;
    colorLimits = [-3 0];
    commonCLim = [];
    cCenter = [];
    invCscaleBool = 1;
    titlesBase = fields;
    titlesExt = 'sigCoh';
    resizeWinBool = 1;
    filename = selChanNames{j};
    interpFunc = [];
    PlotMultiFreqHelper(nextFig,plotData,fileExt,colorLimits,commonCLim,cCenter,invCscaleBool,titlesBase,titlesExt,resizeWinBool,fs,maxFreq,filename,interpFunc);
end
%for j=2:2
for j=1:length(selChans)
    nextFig = j+6;
    for k=1:length(fields)
        a = yNormPs.(selChanNames{j}).(fields{k});
        a(find(a==0)) = 1.1e-16;
        plotData(k,:,:) =  log10(a);
    end
    %log10Bool = 1;
    colorLimits = [-3 0];
    commonCLim = [];
    cCenter = [];
    invCscaleBool = 1;
    titlesBase = fields;
    titlesExt = [];
    resizeWinBool = 1;
    filename = selChanNames{j};
    interpFunc = [];
    PlotMultiFreqHelper(nextFig,plotData,fileExt,colorLimits,commonCLim,cCenter,invCscaleBool,titlesBase,titlesExt,resizeWinBool,fs,maxFreq,filename,interpFunc);
end



for j=1:length(selChans) 
    fields = fieldnames(data.(selChanNames{j}));
    for k=1:length(fields)
        thetaMed.(selChanNames{j}).(fields{k}) = squeeze(median(data.(selChanNames{j}).(fields{k})(:,:,find(fs>=thetaFreqRange(1) & fs<=thetaFreqRange(2))),3));
        thetaATanMed.(selChanNames{j}).(fields{k}) = atanh((thetaMed.(selChanNames{j}).(fields{k})-0.5)*1.999);
        gammaMed.(selChanNames{j}).(fields{k}) = squeeze(median(data.(selChanNames{j}).(fields{k})(:,:,find(fs>=gammaFreqRange(1) & fs<=gammaFreqRange(2))),3));
        gammaATanMed.(selChanNames{j}).(fields{k}) = atanh((gammaMed.(selChanNames{j}).(fields{k})-0.5)*1.999);
    end
end
for j=1:length(selChans) 
    fields = fieldnames(data.(selChanNames{j}));
    for k=1:length(fields)
        for ch=1:96
            thetayNormPs.(selChanNames{j}).(fields{k})(ch) = TestNormality(thetaMed.(selChanNames{j}).(fields{k})(:,ch));
            thetaAtanNormPs.(selChanNames{j}).(fields{k})(ch) = TestNormality(thetaATanMed.(selChanNames{j}).(fields{k})(:,ch));
            gammayNormPs.(selChanNames{j}).(fields{k})(ch) = TestNormality(gammaMed.(selChanNames{j}).(fields{k})(:,ch));
            gammaAtanNormPs.(selChanNames{j}).(fields{k})(ch) = TestNormality(gammaATanMed.(selChanNames{j}).(fields{k})(:,ch));
            %yNormPsSqrt.(selChanNames{j}).(fields{k})(ch) = TestNormality(dataSqrt.(selChanNames{j}).(fields{k})(:,ch));
            %yNormPsATanH.(selChanNames{j}).(fields{k})(ch) = TestNormality(dataATanH.(selChanNames{j}).(fields{k})(:,ch));
        end
    end
end
%for j=2:2
for j=1:length(selChans)
    nextFig = j+10;
    a = [];
    plotData = [];
    for k=1:length(fields)
        a = gammaAtanNormPs.(selChanNames{j}).(fields{k});
        a(find(a==0)) = 1.1e-16;
        plotData(k,:) =  log10(a);
    end
    %log10Bool = 1;
    colorLimits = [-5 0];
    commonCLim = [];
    cCenter = [];
    invCscaleBool = 1;
    titlesBase = fields;
    titlesExt = [];
    resizeWinBool = 0;
    filename = selChanNames{j};
    interpFunc = [];
    PlotHelper(nextFig,plotData,fileExt,colorLimits,commonCLim,cCenter,invCscaleBool,titlesBase,titlesExt,resizeWinBool,fs,maxFreq,filename,interpFunc);
end





figure(1)
colormap(LoadVar('ColorMapSean6.mat'))
set(gcf,'DefaultAxesPosition',[0.05,0.15,0.92,0.75]);
for j=1:length(selChans) 
    fields = fieldnames(data.(selChanNames{j}));
    for k=1:length(fields)
        subplot(length(fields),length(selChans),(k-1)*length(selChans)+j);
        imagesc(Make2DPlotMat(log10(gammayNormPs.(selChanNames{j}).(fields{k})),chanMat,badChans,'linear'));
        title([selChanNames{j} ': ' fields{k}])
        set(gca,'clim',[-2 0])
        PlotAnatCurves(anatCurvesName,[16.5 6.5],offset)
        colorbar
    end
end





%cd([alterFiles(1,:) '/' analDir]);
%fo = LoadField('cohSpec.fo');
%cd('../..')
for j=1:length(selChans) 
    fields = fieldnames(data.(selChanNames{j}));
    for k=1:length(fields)
        dataATanH.(selChanNames{j}).(fields{k}) = atanh(data.(selChanNames{j}).(fields{k}));
    end
end
for j=1:length(selChans) 
    fields = fieldnames(data.(selChanNames{j}));
    for k=1:length(fields)
        for ch=1:96
            for f=1:109
                yNormPs.(selChanNames{j}).(fields{k})(ch,f) = TestNormality(data.(selChanNames{j}).(fields{k})(:,ch,f));
                yNormPsAtanhSq.(selChanNames{j}).(fields{k})(ch,f) = TestNormality(dataAtanhSq.(selChanNames{j}).(fields{k})(:,ch,f));
                yNormPsATanh.(selChanNames{j}).(fields{k})(ch,f) = TestNormality(dataAtanh.(selChanNames{j}).(fields{k})(:,ch,f));
            end
        end
    end
end
for j=2:2
%for j=1:length(selChans)
    nextFig = j;
    fields = fieldnames(yNormPs.(selChanNames{j}));
    plotData = [];
    for k=1:length(fields)
        a = yNormPs.(selChanNames{j}).(fields{k});
        a(find(a==0)) = 1.1e-16;
        %size(a)
        plotData(k,:,:) =  log10(a);
    end
    colorLimits = [-5 0];
    commonCLim = [];
    cCenter = [];
    invCscaleBool = 1;
    titlesBase = fields;
    titlesExt = [];
    resizeWinBool = 1;
    filename = selChanNames{j};
    interpFunc = [];
    PlotMultiFreqHelper(nextFig,plotData,fileExt,colorLimits,commonCLim,cCenter,invCscaleBool,titlesBase,titlesExt,resizeWinBool,fs,maxFreq,filename,interpFunc);
end
%for j=2:2
for j=1:length(selChans)
    nextFig = j+6;
    fields = fieldnames(yNormPsAtanhSq.(selChanNames{j}));
    plotData = [];
    for k=1:length(fields)
        a = yNormPsAtanhSq.(selChanNames{j}).(fields{k});
        a(find(a==0)) = 1.1e-16;
        %size(a)
        plotData(k,:,:) =  log10(a);
    end
    colorLimits = [-3 0];
    commonCLim = [];
    cCenter = [];
    invCscaleBool = 1;
    titlesBase = fields;
    titlesExt = ['yNormPsAtanhSq'];
    resizeWinBool = 1;
    filename = selChanNames{j};
    interpFunc = [];
    PlotMultiFreqHelper(nextFig,plotData,fileExt,colorLimits,commonCLim,cCenter,invCscaleBool,titlesBase,titlesExt,resizeWinBool,fs,maxFreq,filename,interpFunc);
end
%for j=2:2
for j=1:length(selChans)
    nextFig = j;
    fields = fieldnames(yNormPsATanh.(selChanNames{j}));
    plotData = [];
    for k=1:length(fields)
        a = yNormPsATanh.(selChanNames{j}).(fields{k});
        a(find(a==0)) = 1.1e-16;
        %size(a)
        plotData(k,:,:) =  log10(a);
    end
    colorLimits = [-3 0];
    commonCLim = [];
    cCenter = [];
    invCscaleBool = 1;
    titlesBase = fields;
    titlesExt = ['yNormPsATanh'];
    resizeWinBool = 1;
    filename = selChanNames{j};
    interpFunc = [];
    PlotMultiFreqHelper(nextFig,plotData,fileExt,colorLimits,commonCLim,cCenter,invCscaleBool,titlesBase,titlesExt,resizeWinBool,fs,maxFreq,filename,interpFunc);
end

function nextFig = PlotMultiFreqHelper(nextFig,plotData,fileExt,log10Bool,colorLimits,commonCLim,cCenter,invCscaleBool,titlesBase,titlesExt,resizeWinBool,fs,maxFreq,filename,interpFunc)
chanMat = LoadVar(['ChanMat' fileExt '.mat']);
badChans = load(['BadChan' fileExt '.txt']);
plotAnatBool = 1;
anatOverlayName = 'AnatCurves.mat';
plotSize = [-16.5,6.5]; % adjusted for inversion of pcolor
plotOffset = [-16.5 0];% adjusted for inversion of pcolor
if invCscaleBool
    colorStyle = flipud(LoadVar('ColorMapSean6'));
else
    colorStyle = LoadVar('ColorMapSean6');
end
figSizeFactor = 1.5;
figVertOffset = 0.5;
figHorzOffset = 0;
defaultAxesPosition = [0.05,0.05,0.92,0.80+.1*size(plotData,1)/6];
sitesPerShank = size(chanMat,1);
nShanks = size(chanMat,2);
if ~isempty(colorLimits)
    commonCLim = 2;
end

nextFig = nextFig +1;
figure(nextFig)
clf
set(gcf,'name',filename);
set(gcf,'DefaultAxesPosition',defaultAxesPosition);
if resizeWinBool
    set(gcf, 'Units', 'inches')
    set(gcf, 'Position', [figHorzOffset,figVertOffset,figSizeFactor*(nShanks)*1.6,figSizeFactor*(size(plotData,1))*1.3])
end

for j=1:size(plotData,1)
    if commonCLim ~=2
        colorLimits = [];
    end
    for k=1:nShanks

        subplot(size(plotData,1),nShanks,(j-1)*nShanks+k);
        a = plotData(j,(k-1)*sitesPerShank+1:(k)*sitesPerShank,:);
        a(find(a==0)) = 1.1e-16;
        if log10Bool
            a = log10(a);
        end
        pcolor(fs(1:find(abs(fs-maxFreq)==min(abs(fs-maxFreq)),1)),sitesPerShank:-1:1,squeeze(a));
        shading 'interp'
        %h = ImageScMask(Make2DPlotMat(log10((j,:)),chanMat,badChans,interpFunc),badChanMask,colorLimits);
        %imagesc(fs(1:find(abs(fs-maxFreq)==min(abs(fs-maxFreq)),1)),1:sitesPerShank,squeeze(a));
        if commonCLim == 0
            colorLimits = [];
        end
        if isempty(colorLimits)
            if isempty(cCenter)
                colorLimits = [median(abs(a(:)))-1*std(a(:)) median(abs(a(:)))+1*std(a(:))];
            else
                colorLimits = [cCenter-median(abs(a(:)))-1*std(a(:)) cCenter+median(abs(a(:)))+1*std(a(:))];
            end
        end
        if ~isempty(colorLimits)
            set(gca,'clim',colorLimits)
        end
        colorbar
        if isempty(interpFunc)
            hold on
            barh(flipud(Accumulate([intersect(chanMat(:,k), badChans)-min(chanMat(:,k))+1]',maxFreq,16)),1,'w');
        end
        if plotAnatBool
            PlotShankAnatCurves(anatOverlayName,k,get(gca,'xlim'),plotSize,plotOffset)
        end
        set(gca,'fontsize',8)
        if k == 1
            ylabel(titlesBase(j));
        end
        if j == 1
            title([{titlesExt}] );
        end
    end
    colormap(colorStyle)
end
return



if normBool
    for j=1:length(selChans)
        fields = fieldnames(data.(selChanNames{j}));
        meanTemp = [];
        stdTemp = [];
        for k=1:length(fields)
            meanTemp = cat(1,meanTemp,mean(data.(selChanNames{j}).(fields{k})));
            stdTemp = cat(1,stdTemp,std(data.(selChanNames{j}).(fields{k}),[],1));
        end
        %size(meanTemp)
        %keyboard
        meanData.(selChanNames{j}) = mean(meanTemp);
        stdData.(selChanNames{j}) = mean(stdTemp);
    end
end

figure(1)
colormap(LoadVar('ColorMapSean6.mat'))
set(gcf,'DefaultAxesPosition',[0.05,0.15,0.92,0.75]);
for j=1:length(selChans) 
    fields = fieldnames(data.(selChanNames{j}));
    for k=1:length(fields)
        subplot(length(fields),length(selChans),(k-1)*length(selChans)+j);
        imagesc(Make2DPlotMat(squeeze(mean(data.(selChanNames{j}).(fields{k}))),chanMat,badChans,'linear'));
        title([selChanNames{j} ': ' fields{k}])
        set(gca,'clim',[0 1])
        PlotAnatCurves(anatCurvesName,[16.5 6.5],offset)
        colorbar
    end
end

if normBool
    figure(2)
    colormap(LoadVar('ColorMapSean6.mat'))
    set(gcf,'DefaultAxesPosition',[0.05,0.15,0.92,0.75]);
    for j=1:length(selChans)
        fields = fieldnames(data.(selChanNames{j}));
        for k=1:length(fields)
            %             if j==2
            %                 junk = mean(data.(selChanNames{j}).(fields{k}))-meanData.(selChanNames{j});
            %             end
            %             junk(37)
            subplot(length(fields),length(selChans),(k-1)*length(selChans)+j);
            imagesc(Make2DPlotMat(squeeze((mean(data.(selChanNames{j}).(fields{k}))-meanData.(selChanNames{j}))./stdData.(selChanNames{j}))',chanMat,badChans,'linear'));
            title([selChanNames{j} ': ' fields{k}])
            set(gca,'clim',[-1 1])
             PlotAnatCurves(anatCurvesName,[16.5 6.5],offset)
            colorbar
        end
    end
end


figure(1)
colormap(LoadVar('CircularColorMap.mat'))
set(gcf,'DefaultAxesPosition',[0.05,0.15,0.92,0.75]);
for j=1:length(selChans) 
    fields = fieldnames(data.(selChanNames{j}));
    for k=1:length(fields)
        subplot(length(fields),length(selChans),(k-1)*length(selChans)+j);
        imagesc(Make2DPlotMat(angle(squeeze(mean(data.(selChanNames{j}).(fields{k})))),chanMat,badChans,'linear'));
        title([selChanNames{j} ': ' fields{k}])
        set(gca,'clim',[-pi pi])
        %set(gca,'clim',[0.5 1])
        PlotAnatCurves(anatCurvesName,[16.5 6.5],offset)
        colorbar
    end
end


if normBool
    figure(2)
    colormap(LoadVar('CircularColorMap'))
    set(gcf,'DefaultAxesPosition',[0.05,0.15,0.92,0.75]);
    for j=1:length(selChans)
        fields = fieldnames(data.(selChanNames{j}));
        for k=1:length(fields)
            %             if j==2
            %                 junk = mean(data.(selChanNames{j}).(fields{k}))-meanData.(selChanNames{j});
            %             end
            %             junk(37)
            subplot(length(fields),length(selChans),(k-1)*length(selChans)+j);
            imagesc(Make2DPlotMat(angle(squeeze((mean(data.(selChanNames{j}).(fields{k}))-meanData.(selChanNames{j})))),chanMat,badChans,'linear'));
            title([selChanNames{j} ': ' fields{k}])
            set(gca,'clim',[-pi pi])
             PlotAnatCurves(anatCurvesName,[16.5 6.5],offset)
            colorbar
        end
    end
end




    nextFig = j+10;
    a = [];
    plotData = [];
    fields = fieldnames(assumTest.dw);
    a = MatStruct2StructMat(assumTest.dw);
    for k=1:length(fields)
        %a = assumTest.dw.(fields{k});
        %a(find(a==0)) = 1.1e-16;
        plotData(k,:) = a.(fields{k});
    end
    %log10Bool = 1;
    colorLimits = [];
    commonCLim = [];
    cCenter = [];
    invCscaleBool = 1;
    titlesBase = fields;
    titlesExt = [];
    resizeWinBool = 1;
    filename = 'junk';
    interpFunc = [];
    PlotHelper(nextFig,plotData,fileExt,colorLimits,commonCLim,cCenter,invCscaleBool,titlesBase,titlesExt,resizeWinBool,fs,maxFreq,filename,interpFunc);

