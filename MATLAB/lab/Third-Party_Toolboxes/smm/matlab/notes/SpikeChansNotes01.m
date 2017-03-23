for j=1:20
    temp(j,1) = length(LocalMinima(filt8,0,-std(filt8)*j));
    temp(j,2) = length(LocalMinima(filt23,0,-std(filt8)*j));
end
temp2 = (temp+1)./repmat(mean(temp+1,2),1,size(temp,2));
plot(temp2)

filt = Filter0(firfiltb,data);

plot(temp)

ch23 = readmulti('sm9603m2_206_s1_249.dat',97,23);
filt23 = Filter0(firfiltb,ch23);
for j=1:6
    temp(j,2) = length(LocalMinima(filt23,0,-std(filt8)*j));
end

plot(filt23(1000:1000000),'g')


firfiltb = fir1(2/1000*20000,1000/20000*2,'high');
chans = 49:64;
for j=1:length(chans)
    data = readmultiSM('sm9603m2_247_s1_293.dat',97,chans(j));
    filt = Filter0(firfiltb,data);
    if j==1
        stdDev = std(filt);
    end
    for k=1:25
        spikes(k,j) = length(LocalMinima(filt,10,-stdDev*(k-1)));
    end
end
plot((spikes+1)./repmat(mean(spikes+1,2),1,size(spikes,2)));

normSpikes = (spikes+1)./repmat(mean(spikes+1,2),1,size(spikes,2));
clf
for j=1:length(chans)
    subplot(length(chans),1,j)
    hold on
plot(normSpikes(:,j));
%plot((spikes(:,j)+1)./mean(spikes+1,2));
plot([1 25],[1 1],'r')
set(gca,'xlim',[1 25])%,'ylim',[0 max(max(normSpikes))])
end

data = readmultiSM('sm9603m2_247_s1_293.dat',97,chans(5));
filt = Filter0(firfiltb,data);
clf
plot(data(1:1000000))
hold on
plot(filt(1:1000000),'r')


