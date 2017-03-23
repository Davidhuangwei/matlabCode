function CalcRemSpectra(taskType,fileExt,nChan,winLength,nOverlap,thetaNW,thetaFreqRange,gammaNW,gammaFreqRange)


thetaYo = [];
gammaYo = [];
tempYo = [];
%figure;
%hold on;



addpath /u12/antsiro/matlab/General

thetaFreq = [];
times = [];
fileNames = [];
whlSamp = 39.065;
eegSamp = 1250;
bps = 2;
yoFreqRange = [0 120];

load('RemTimes')
for i=1:length(remTimes)
    fileBaseMat(i,:) = remTimes(i).fileName;
end

for j=1:size(fileBaseMat,1)
    fileBase = fileBaseMat(j,:);
    fprintf('Loading: %s%s %i:%i\n',fileBase,fileExt,remTimes(j).times(1),remTimes(j).times(2));
    eeg = bload([fileBaseMat(j,:) fileExt],[nChan eegSamp*(remTimes(j).times(2)-remTimes(j).times(1))],...
        remTimes(j).times(1)*eegSamp*nChan*bps,'int16')';

    [thetaY, thetaF, thetaT] = mtpsg(eeg,2*winLength,eegSamp,winLength,nOverlap,thetaNW,[],[],yoFreqRange);
    [gammaY, gammaF, gammaT] = mtpsg(eeg,2*winLength,eegSamp,winLength,nOverlap,gammaNW,[],[],yoFreqRange);
    thetaYo = cat(3,thetaYo,permute(thetaY,[1,3,2])); %[f,sample,chan] -> [f,chan,sample]
    gammaYo = cat(3,gammaYo,permute(gammaY,[1,3,2])); %[f,sample,chan] -> [f,chan,sample]
    
    [thetaFreqY,thetaFreqF,thetaFreqT] = mtpsg(eeg,winLength*2,eegSamp,winLength,nOverlap,1,[],[],thetaFreqRange);
    [peakThetaPow thetaFreqIndexes] = max(thetaFreqY,[],1);
    thetaFreqF = repmat(thetaFreqF,size(thetaFreqIndexes));%1,size(thetaFreqIndexes,2),size(thetaFreqIndexes,3));
    thetaFreq = cat(2,thetaFreq, squeeze(thetaFreqF(thetaFreqIndexes))');

    if  (exist('thetaFo') & thetaFo ~= thetaF) | (exist('gammaFo') & gammaFo ~= gammaF)
        fprintf('\nPROBLEM fo~=f\n')
        keyboard
    end
    thetaFo=thetaF;
    gammaFo=gammaF;

    fileNames = cat(1,fileNames,mat2cell(repmat(fileBaseMat(j,:),size(thetaT)),ones(size(thetaT)),size(fileBaseMat(j,:),2)));
    if thetaT~=gammaT
        fprintf('thetaT~=gammaT');
        keyboard
    else
        times = [times; thetaT+remTimes(j).times(1)];
    end
    size(thetaYo)
    size(gammaYo)
end

clear eeg
clear thetaY
clear thetaFreqF
clear thetaFreqY
clear gammaY

thetaPowPeak = squeeze(10.*log10(max(thetaYo(find(thetaFo>=thetaFreqRange(1) & thetaFo<=thetaFreqRange(2)),:,:),[],1)));
thetaPowIntg = squeeze(10.*log10(sum(thetaYo(find(thetaFo>=thetaFreqRange(1) & thetaFo<=thetaFreqRange(2)),:,:),1)));
gammaPowPeak = squeeze(10.*log10(max(gammaYo(find(gammaFo>=gammaFreqRange(1) & gammaFo<=gammaFreqRange(2)),:,:),[],1)));
gammaPowIntg = squeeze(10.*log10(sum(gammaYo(find(gammaFo>=gammaFreqRange(1) & gammaFo<=gammaFreqRange(2)),:,:),1)));

thetaYo = 10.*log10(thetaYo);
gammaYo = 10.*log10(gammaYo);

figure
hold on
load SelectedChannels
imagesc(1:length(times),thetaFo,squeeze(thetaYo(:,selectedChannels(1),:)));

%imagesc(squeeze(thetaYo(:,selectedChannels(1),:)));
%imagesc(squeeze(10.*log10(thetaYo(:,selectedChannels(1),:))));

%imagesc(10.*log10(squeeze(10.^(thetaYo(:,selectedChannels(1),:)./10)).*repmat(thetaF.^2,1,size(thetaYo,3))));
%set(gca,'clim',[60 110]);
set(gca,'clim',[30 75]);
colorbar
%keyboard
hold on
plot(1:length(thetaFreq),thetaFreq(selectedChannels(1),:),'k')

outName = [taskType '_Meas' 'Win' num2str(winLength) ...
    'thetaNW' num2str(thetaNW) 'gammaNW' num2str(gammaNW) '.mat'];
fprintf('Saving: %s\n',outName)
set(gcf,'name',outName);

remMeasStruct = [];
remMeasStruct = setfield(remMeasStruct,'thetaYo',thetaYo);
remMeasStruct = setfield(remMeasStruct,'thetaFo',thetaFo);
remMeasStruct = setfield(remMeasStruct,'thetaFreq',thetaFreq);
remMeasStruct = setfield(remMeasStruct,'gammaYo',gammaYo);
remMeasStruct = setfield(remMeasStruct,'gammaFo',gammaFo);
remMeasStruct = setfield(remMeasStruct,'time',times);
remMeasStruct = setfield(remMeasStruct,'fileName',fileNames);
remMeasStruct = setfield(remMeasStruct,'thetaPowPeak',thetaPowPeak);
remMeasStruct = setfield(remMeasStruct,'thetaPowIntg',thetaPowIntg);
remMeasStruct = setfield(remMeasStruct,'gammaPowPeak',gammaPowPeak);
remMeasStruct = setfield(remMeasStruct,'gammaPowIntg',gammaPowIntg);
%remMeasStruct = setfield(remMeasStruct,'info','channels',channels);
remMeasStruct = setfield(remMeasStruct,'info','thetaNW',thetaNW);
remMeasStruct = setfield(remMeasStruct,'info','gammaNW',gammaNW);
remMeasStruct = setfield(remMeasStruct,'info','winLength',winLength);
remMeasStruct = setfield(remMeasStruct,'info','nOverlap',nOverlap);
remMeasStruct = setfield(remMeasStruct,'info','fileBaseMat',fileBaseMat);
remMeasStruct = setfield(remMeasStruct,'info','fileExt',fileExt);
remMeasStruct = setfield(remMeasStruct,'info','saveName',outName);
remMeasStruct = setfield(remMeasStruct,'info','thetaFreqRange',thetaFreqRange);
remMeasStruct = setfield(remMeasStruct,'info','gammaFreqRange',gammaFreqRange);

save(outName, 'remMeasStruct');
return


