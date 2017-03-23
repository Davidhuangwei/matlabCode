
eegSamp = 1250;
whlSamp = 39.065;

cd /beef2/smm/sm9603_Analysis/analysis03
addpath /u12/smm/matlab/MazeBehavior

fileBase = 'sm9603m2_210_s1_253';
whl = LoadMazeTrialTypes('sm9603m2_210_s1_253');


plot(whl(:,1)~=-1,'.')

eeg39 = readmulti('sm9603m2_210_s1_253.eeg',97,39);
points = diff(whl(:,1)~=-1);
begining = find(points==1);
ending = find(points==-1);


plot(eeg39(begining(1):ending(1)));

eegBegin = round(begining*eegSamp/whlSamp)
eegEnd = round(ending*eegSamp/whlSamp)

plot(eeg39(eegBegin(1):eegEnd(1)));

addpath /u12/smm/matlab/

firfiltb = fir1(626,[6/1250*2,30/1250*2]);
filt39 = Filter0(firfiltb, eeg39');

plot(filt39(eegBegin(:):eegEnd(:)));


mins39 = LocalMinima(filt39,1250/15,0);

plot(eeg39)
hold on
plot(mins39,ones(length(mins39)),'.')

set(gca,'xlim',[eegBegin(1) eegEnd(1)])
segs = [];


interv = round(0.3*1250);
segs = [];
for j=1:length(eegBegin)
    begining = find(mins39>eegBegin(j),1,'first');
    ending = find(mins39<eegEnd(j),1,'last');
    for i=begining:ending
        eegSeg = bload([fileBase '.eeg'],[97 interv],round(mins39(i)-interv/2)*97*2,'int16');
        filtSeg = Filter0(firfiltb, eegSeg');

        segs = cat(3,segs,filtSeg');
        %segs = [segs eeg39(i-.2*1250:i+.2*1250)];
    end
end

plot(segs(39,:,1))

aveSeg = mean(segs,3);
%        outputMat(:,x) = interp1(find(~isnan(outputMat(:,x))),outputMat(find(~isnan(outputMat(:,x))),x),[1:nChanY],interpFunc)';

channels = 65:80;
channels = 81:96;
channels = 17:32;
channels = 65:80;
channels = 81:96;
channels = 17:32;
channels = 33:48;
channels = 49:64;


badchan = load('sm9603EEGBadChan.txt');
goodChan = [];
for i=1:length(channels)
    if isempty(find(channels(i)==badchan))
        goodChan = [goodChan channels(i)];
    end
end

interpSeg = interp1(goodChan,aveSeg(goodChan,:),1:length(channels),'linear');

figure(1)
clf
shankcsd = diff(aveSeg(channels,:),2);

pcolor(flipud(shankcsd))
shading interp
hold on

hold on
normVal = 2000;
for i=1:length(channels)
    plot(aveSeg(channels(i),:)./normVal+length(channels)-i)
end
set(gca,'xtick',[0:93.75:375])
set(gca,'xticklabel',[0:93.75:375]/1.250-187.5/1.250)
hold off

figure(2)
clf
%shankcsd = diff(interpSeg(1:16,:),2);

pcolor(shankcsd)
shading interp
hold on

normVal = 2000;
for i=1:length(channels)
    plot(aveSeg(channels(i),:)./normVal+length(channels)-i)
end

set(gca,'xtick',[0:93.75:375])
set(gca,'xticklabel',[0:93.75:375]/1.250-187.5/1.250)
set(gca,'FontSize',12)

hold off




clf
pcolor(shank3csd)
shading interp
figure
plot(shank3csd(7,:))
plot(aveSeg(39,:))
segs = [];

