function SpeedPowAncova(controlDir,expDir,fileNamesFile,chan,minSpeed,winLength,NW,lowCut,highCut)
%keyboard
cd(controlDir);
load(fileNamesFile);
yoTotal = [];
speedTotal = [];
integPowTotal = [];
peakPowTotal = [];
fileBaseMat = alterFiles;
for i=1:size(fileBaseMat,1)
    inName = [fileBaseMat(i,:) '_Speed_mtSpect_Win_' num2str(winLength) '_NW_' num2str(NW) '.mat'];
    fprintf('\nLoading: %s\n',inName);
    load(inName);
    
    integPow = sum(log(yo(find(fo>=lowCut & fo<=highCut),:,:)));
    peakPow = max(log(yo(find(fo>=lowCut & fo<=highCut),:,:)));

    yoTotal = [yoTotal yo];
    speedTotal = [speedTotal ; speed];
    integPowTotal = [integPowTotal integPow];
    peakPowTotal = [peakPowTotal peakPow];   
end

controlSpeed = speedTotal;
controlPeakPow = peakPowTotal;
controlGroup = zeros(size(controlSpeed));

cd(expDir);
load(fileNamesFile);
yoTotal = [];
speedTotal = [];
integPowTotal = [];
peakPowTotal = [];
fileBaseMat = alterFiles;
for i=1:size(fileBaseMat,1)
    inName = [fileBaseMat(i,:) '_Speed_mtSpect_Win_' num2str(winLength) '_NW_' num2str(NW) '.mat'];
    fprintf('\nLoading: %s\n',inName);
    load(inName);
    
    integPow = sum(log(yo(find(fo>=lowCut & fo<=highCut),:,:)));
    peakPow = max(log(yo(find(fo>=lowCut & fo<=highCut),:,:)));

    yoTotal = [yoTotal yo];
    speedTotal = [speedTotal ; speed];
    integPowTotal = [integPowTotal integPow];
    peakPowTotal = [peakPowTotal peakPow];   
end
expSpeed = speedTotal;
expPeakPow = peakPowTotal;
expGroup = ones(size(expSpeed));

speed = [controlSpeed; expSpeed];
pow = [squeeze(controlPeakPow(:,:,find(channels==chan))) squeeze(expPeakPow(:,:,find(channels==chan)))]';
group = [controlGroup; expGroup];
figure
set(gcf,'name',['ANOCOVA_Distribution_Plots_minSpeed=' num2str(minSpeed) '_chan=' num2str(chan)])
subplot(2,2,1)
hist(log10(expSpeed(expSpeed>minSpeed)))
title('expSpeed')
subplot(2,2,2)
hist(log10(controlSpeed(controlSpeed>minSpeed)))
title('controlSpeed')
subplot(2,2,3)
hist(log10(expPeakPow(expSpeed>minSpeed)))
title('expPeakPow')
subplot(2,2,4)
hist(log10(controlPeakPow(controlSpeed>minSpeed)))
title('controlPeakPow')
aoctool(log10(speed(speed>minSpeed)),pow(speed>minSpeed),group(speed>minSpeed),0.05,'log(Speed)','Log(Power)')



