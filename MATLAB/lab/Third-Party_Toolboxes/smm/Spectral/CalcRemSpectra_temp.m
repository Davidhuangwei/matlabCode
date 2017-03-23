function CalcRemSpectra_temp(description,fileBaseMat,fileExt,nChan,winLength,thetaFreqRange,gammaFreqRange,varargin)
%function CalcRemSpectra02(description,fileBaseMat,fileExt,nChan,winLength,thetaFreqRange,gammaFreqRange,varargin)
%[selectedChannels] = ...
%    DefaultArgs(varargin,{load(['SelectedChannels' fileExt '.txt'])});

chanInfoDir = 'ChanInfo/';

[selectedChannels] = ...
    DefaultArgs(varargin,{load([chanInfoDir 'SelectedChannels' fileExt '.txt'])});
keyboard
for k=1:length(selectedChannels)
    selChanNames{k} = ['ch' num2str(selectedChannels(k))];
end

saveDir = [mfilename '_' description '_Win' num2str(winLength) fileExt];

%addpath /u12/antsiro/matlab/General
addpath /u12/smm/matlab/sm_Copies

%%%% parameters optimized for winLength = 626 %%%%
N = winLength;
DJ = 1/18;
S0 = 4;
J1 = round(log2(N/S0)/(DJ)-1.3/DJ);

eegSamp = 1250;
bps = 2;

%yoFreqRange = [0 500];

infoStruct = [];
infoStruct = setfield(infoStruct,'winLength',winLength);
infoStruct = setfield(infoStruct,'S0',S0);
infoStruct = setfield(infoStruct,'DJ',DJ);
infoStruct = setfield(infoStruct,'J1',J1);
infoStruct = setfield(infoStruct,'eegSamp',eegSamp);
infoStruct = setfield(infoStruct,'fileExt',fileExt);
infoStruct = setfield(infoStruct,'thetaFreqRange',thetaFreqRange);
infoStruct = setfield(infoStruct,'gammaFreqRange',gammaFreqRange);
infoStruct = setfield(infoStruct,'description',description);
infoStruct = setfield(infoStruct,'program',mfilename);

dayStruct = LoadVar('DayStruct.mat');

for j=1:size(fileBaseMat,1)
    c1 = clock;
    fileBase = fileBaseMat(j,:);
    infoStruct = setfield(infoStruct,'fileBase',fileBase);
    fprintf('Processing: %s%s\n',fileBase,fileExt);
    eval(['cd ' fileBase]);
   
    figure;
    subplot(2,2,1);
    hold on;
    
    wavePow = [];
    waveXspec = [];
    waveCoh = [];
    wavePhase = [];
    thetaFreq = [];
    time = [];
    taskType = {};
    day = {};
    rawTrace = [];
    trialType = []; % for similarity to maze analysis
    mazeLocation = []; % for similarity to maze analysis
               
    if exist([saveDir '/eegSegTime.mat'],'file')
        fprintf('Loading: %s/eegSegTime.mat\n',saveDir)
        to = LoadVar([saveDir '/eegSegTime.mat']);
    else
        remTimes = LoadVar('RemTimes.mat');
        to = [];
        for k=1:size(remTimes,1)
            to = [to remTimes(k,1)*eegSamp:winLength:remTimes(k,2)*eegSamp-winLength];
        end 
    end
    if ~isempty(to)
        for i=1:length(to)
            eegData = bload([fileBase fileExt],[nChan winLength],to(i)*nChan*bps,'int16');
            rawTrace = cat(1,rawTrace,permute(eegData,[3,1,2]));
            
            
            %%%%%%% testing %%%%%%%%%%
%             keyboard
%             m=34
%             [temp period junk coi] = xwt(eegData(m,:),eegData(m,:),'Pad',1,'DJ',DJ,'S0',S0,'J1',J1);
%             figure(1)
%             clf
%             pcolor(1:winLength,1./period.*eegSamp,temp)
%             shading interp
%             set(gca,'ylim',[0 20])
%             hold on
%             plot(1:winLength,1./coi.*eegSamp)
%             plot(1:winLength,repmat(4,size(1:winLength)),'r--')
%             pow(1,:) = mean(temp'.*[repmat([hanning(winLength)./mean(hanning(winLength))],1,size(temp,1))],1);
%             figure(2)
%             clf
%             plot(1./period.*eegSamp,log10(pow))
%             figure(3)
%             clf
%             plot(1:winLength,hanning(winLength)./mean(hanning(winLength)))
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
            for m=1:nChan
                [temp period] = xwt(eegData(m,:),eegData(m,:),'Pad',1,'DJ',DJ,'S0',S0,'J1',J1);
                pow(1,m,:) = mean(temp'.*[repmat([hanning(winLength)./mean(hanning(winLength))],1,size(temp,1))],1);
            end
            for k=1:length(selectedChannels)
                for m=1:nChan
                    [temp xSpecPeriod]= xwt(eegData(selectedChannels(k),:),eegData(m,:),'Pad',1,'DJ',DJ,'S0',S0,'J1',J1);
                    xSpec(1,k,m,:) = mean(temp'.*[repmat([hanning(winLength)./mean(hanning(winLength))],1,size(temp,1))],1);
                    coh(1,k,m,:) = atanh((sqrt(squeeze(xSpec(1,k,m,:).*conj(xSpec(1,k,m,:)))./...
                        squeeze(pow(1,selectedChannels(k),:).*pow(1,m,:)))-0.5)*1.999);
                    phase(1,k,m,:) = complex(cos(angle(xSpec(1,k,m,:))),sin(angle(xSpec(1,k,m,:))));
                    %atanh((cohSpec.yo.(selChanNames{m})-0.5)*1.999);
                    %                         if squeeze(angle(phase(1,k,m,:))) ~= squeeze(angle(xSpec(1,k,m,:)))
                    %                             bad
                    %                         end
                end
            end

            fo = 1./period.*eegSamp;
            fo = flipdim(fo,2);

            if period ~= xSpecPeriod
                ERROR_period_not_equal_to_cohPeriod
            end
            if exist('pSpec','var') & fo ~= pSpec.fo
                ERROR_pSpec.fo_is_changing
            end

            wavePow = cat(1,wavePow,flipdim(pow,3));
            waveXspec = cat(1,waveXspec,flipdim(xSpec,4));
            waveCoh = cat(1,waveCoh,flipdim(coh,4));
            wavePhase = cat(1,wavePhase,flipdim(phase,4));

            %[wave,fo,t,s,wb] = Wavelet(eegData',[],eegSamp,w0);
            %clear wb
            %wave = permute(mean(abs(wave).^2,1),[1,3,2]);
            %wavePow = cat(1,wavePow,wave);

            %% calculate theta frequency: try LocalMinima then max
            fRangeInd = find(fo>=thetaFreqRange(1) & fo<=thetaFreqRange(2));
            for k=1:size(wavePow,2)
                temp = LocalMinima(-wavePow(end,k,fRangeInd),length(fRangeInd));
                if isempty(temp)
                    [peakThetaPow, temp] = max(wavePow(end,k,fRangeInd),[],3);
                end
                peakThetaInd(:,k) = temp;
            end
            thetaFreq = cat(1,thetaFreq,fo(fRangeInd(1)+squeeze(peakThetaInd(:))-1));
                
            trialType = cat(1,trialType,[1 1 1 1 1 1 1 1 1 1 1 1 1]);
            mazeLocation = cat(1,mazeLocation,[1 1 1 1 1 1 1 1 1]);

            day = cat(1, day, {dayStruct.(fileBase)});
            time = cat(1, time, (to(i)+winLength/2)/eegSamp); % in seconds
            taskType = cat(1,taskType,{'REM'});
        end
        size(wavePow)
    end
    
    thetaPowPeak = squeeze(10.*log10(max(wavePow(:,:,find(fo>=thetaFreqRange(1) & fo<=thetaFreqRange(2))),[],3)));
    thetaPowIntg = squeeze(10.*log10(sum(wavePow(:,:,find(fo>=thetaFreqRange(1) & fo<=thetaFreqRange(2))),3)));
    gammaPowPeak = squeeze(10.*log10(max(wavePow(:,:,find(fo>=gammaFreqRange(1) & fo<=gammaFreqRange(2))),[],3)));
    gammaPowIntg = squeeze(10.*log10(sum(wavePow(:,:,find(fo>=gammaFreqRange(1) & fo<=gammaFreqRange(2))),3)));
    powSpec.yo = 10.*log10(wavePow);
    powSpec.fo = fo;
    
    for k=1:length(selectedChannels)
        crossSpec.yo.(selChanNames{k}) = squeeze(waveXspec(:,k,:,:));

        thetaCohMedian.(selChanNames{k}) = squeeze(median(waveCoh(:,k,:,find(fo>=thetaFreqRange(1) & fo<=thetaFreqRange(2))),4));
        thetaCohMean.(selChanNames{k}) = squeeze(mean(waveCoh(:,k,:,find(fo>=thetaFreqRange(1) & fo<=thetaFreqRange(2))),4));
        gammaCohMedian.(selChanNames{k}) = squeeze(median(waveCoh(:,k,:,find(fo>=gammaFreqRange(1) & fo<=gammaFreqRange(2))),4));
        gammaCohMean.(selChanNames{k}) = squeeze(mean(waveCoh(:,k,:,find(fo>=gammaFreqRange(1) & fo<=gammaFreqRange(2))),4));
        cohSpec.yo.(selChanNames{k}) = squeeze(waveCoh(:,k,:,:));

        thetaPhaseMean.(selChanNames{k}) = squeeze(mean(wavePhase(:,k,:,find(fo>=thetaFreqRange(1) & fo<=thetaFreqRange(2))),4));
        gammaPhaseMean.(selChanNames{k}) = squeeze(mean(wavePhase(:,k,:,find(fo>=gammaFreqRange(1) & fo<=gammaFreqRange(2))),4));
        phaseSpec.yo.(selChanNames{k}) = squeeze(wavePhase(:,k,:,:));
    end
    crossSpec.fo = fo;
    cohSpec.fo = fo;
    phaseSpec.fo = fo;
    
    
    subplot(2,2,2);
    hold on
    pcolor(1:length(time),powSpec.fo,squeeze(powSpec.yo(:,selectedChannels(1),:))');
    shading 'flat'
    set(gca,'clim',[35 75],'ylim',[0,100]);
    colorbar
    plot(1:length(time),thetaFreq(:,selectedChannels(1)),'k')
    
    subplot(2,2,3);
    pcolor(1:length(time),cohSpec.fo,squeeze(cohSpec.yo.(selChanNames{1})(:,selectedChannels(2),:))');
    shading 'flat'
    set(gca,'clim',[0 1],'ylim',[0,100]);
    colorbar
     
    subplot(2,2,4);
    pcolor(1:length(time),phaseSpec.fo,angle(squeeze(phaseSpec.yo.(selChanNames{1})(:,selectedChannels(2),:)))');
    shading 'flat'
    set(gca,'clim',[-pi pi],'ylim',[0,100]);
    colorbar
    
    if ~exist(saveDir,'dir')
        eval(['mkdir ' saveDir])
    end
    infoStruct = setfield(infoStruct,'saveDir',saveDir);
    fprintf('Saving: %s\n',saveDir)
    set(gcf,'name',[fileBase ': ' saveDir]);

    save([saveDir '/infoStruct.mat'],SaveAsV6,'infoStruct');
    save([saveDir '/rawTrace.mat'],SaveAsV6,'rawTrace');
    save([saveDir '/thetaFreq' num2str(thetaFreqRange(1)) '-' num2str(thetaFreqRange(2)) 'Hz.mat'],SaveAsV6,'thetaFreq');
    save([saveDir '/powSpec.mat'],SaveAsV6,'powSpec');
    save([saveDir '/crossSpec.mat'],SaveAsV6,'crossSpec');
    save([saveDir '/cohSpec.mat'],SaveAsV6,'cohSpec');
    save([saveDir '/phaseSpec.mat'],SaveAsV6,'phaseSpec');
    save([saveDir '/day.mat'],SaveAsV6,'day');
    save([saveDir '/time.mat'],SaveAsV6,'time');
    save([saveDir '/eegSegTime.mat'],SaveAsV6,'to');
    save([saveDir '/taskType.mat'],SaveAsV6,'taskType');
    save([saveDir '/trialType.mat'],SaveAsV6,'trialType');
    save([saveDir '/mazeLocation.mat'],SaveAsV6,'mazeLocation');
    save([saveDir '/thetaPowPeak' num2str(thetaFreqRange(1)) '-' num2str(thetaFreqRange(2)) 'Hz.mat'],SaveAsV6,'thetaPowPeak');
    save([saveDir '/thetaPowIntg' num2str(thetaFreqRange(1)) '-' num2str(thetaFreqRange(2)) 'Hz.mat'],SaveAsV6,'thetaPowIntg');
    save([saveDir '/gammaPowPeak' num2str(gammaFreqRange(1)) '-' num2str(gammaFreqRange(2)) 'Hz.mat'],SaveAsV6,'gammaPowPeak');
    save([saveDir '/gammaPowIntg' num2str(gammaFreqRange(1)) '-' num2str(gammaFreqRange(2)) 'Hz.mat'],SaveAsV6,'gammaPowIntg');
    save([saveDir '/thetaCohMedian' num2str(thetaFreqRange(1)) '-' num2str(thetaFreqRange(2)) 'Hz.mat'],SaveAsV6,'thetaCohMedian');
    save([saveDir '/thetaCohMean' num2str(thetaFreqRange(1)) '-' num2str(thetaFreqRange(2)) 'Hz.mat'],SaveAsV6,'thetaCohMean');
    save([saveDir '/gammaCohMedian' num2str(gammaFreqRange(1)) '-' num2str(gammaFreqRange(2)) 'Hz.mat'],SaveAsV6,'gammaCohMedian');
    save([saveDir '/gammaCohMean' num2str(gammaFreqRange(1)) '-' num2str(gammaFreqRange(2)) 'Hz.mat'],SaveAsV6,'gammaCohMean');
    save([saveDir '/thetaPhaseMean' num2str(thetaFreqRange(1)) '-' num2str(thetaFreqRange(2)) 'Hz.mat'],SaveAsV6,'thetaPhaseMean');
    save([saveDir '/gammaPhaseMean' num2str(gammaFreqRange(1)) '-' num2str(gammaFreqRange(2)) 'Hz.mat'],SaveAsV6,'gammaPhaseMean');

    cd ..
    c2 = clock-c1;
    disp(num2str(c2))
end

return
