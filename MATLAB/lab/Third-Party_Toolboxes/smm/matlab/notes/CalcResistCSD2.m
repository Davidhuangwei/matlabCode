 
startTime = 8*60+45;
nChan = 97;
bps = 2;
datSamp = 20000;
freq = 13;
fileName = 'sm9603m2_254_s1_300.dat';
allDat = bload(fileName,[nChan datSamp*55],startTime*datSamp*bps*nChan);
offset(:,1) = median(allDat,2)

startChans = [1 17 33 49 65 81];
refChans = [1 17 33 49 65 81];
refChan = 33; 
for j=1:6
    lMins = LocalMinima(allDat(refChan,:),datSamp/freq,0);
    figure(1)
    clf
    hold on
    plot(dat(refChan,:))
    plot(lMins,zeros(size(lMins)),'r.')
    
    minDat = allDat(:,lMins);
    for i=1:nChan
        medAdjMins(i,:) = median(minDat(i,:)-offset(i,1),2);
    end
y2 = InterpLinExtrapNear(y,MakeChanMat(6,16),badChan)
    
for i=1:nChan
    adjDat(i,:) = allDat(i,:)-offset(i);
end



    
dat = allDat(33:48,:); 
refChan = 1;

lMins = LocalMinima(dat(refChan,:),1500,0);
figure(1)
clf
hold on
plot(dat(refChans(j),:))
plot(lMins,zeros(size(lMins)),'r.')

%meanDat = mean(dat(1:16,:),2)
medDat = median(dat(1:16,:),2)

for i=1:16
    adjDat(i,:) = dat(i,:)-median(dat(i,:));
end
%for i=1:15
%    diffDat(i,:) = adjDat(refChan+i,lMins) - adjDat(refChan,lMins);
%end

%plot(diffDat(2,:),'r.')ad
%hold on
%plot(diffDat(1,:),'b.')
%plot(diffDat(3,:),'g.')


%meanDiffDat = mean(diffDat,2);
medAdjDat = median(-adjDat(:,lMins),2);
figure
hold on
plot(medAdjDat)
b = regress(medAdjDat,[ones(size(1:16)); 1:16]');
plot([0 16],[b(1) b(1)+b(2)*16],'k')

for i=1:16
    corrections(i) = (b(1)+b(2)*i)/medAdjDat(i);
end
corrections
for i=1:16
    corrDat(i,:) = adjDat(i,:)*corrections(i);
end

medCorrDat = median(-corrDat(:,lMins),2)
plot(medCorrDat,'r')

uncorrCSD = CSD1D(dat,{{1:16},[1]});
corrCSD = CSD1D(corrDat,{{1:16},[1]});

figure
hold on
for i=1:14
    plot(uncorrCSD(i,:)-i*1000,'k')    
    plot(corrCSD(i,:)-i*1000,'r')
end

