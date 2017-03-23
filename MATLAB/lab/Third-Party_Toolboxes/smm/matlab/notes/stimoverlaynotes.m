function stimoverlay

begintime = 170 %in seconds
endtime = 360 %in seconds

data = readmulti('sm9608_176.dat',97,[41:48]);
datsampl=20000;
dataseg = data((170*datsampl):(360*datsampl),:);
clear data;

eeg = readmulti('sm9608_176.eeg',97,[41:48]);
eegsampl = 1250;
dataseg = data((170*eegsampl):(360*eegsampl),:);

% calculate stim peaks
for i=1:floor(length(dataseg(:,1))/10/datsampl)
    stims(i) = find(dataseg(:,1)==min(dataseg(((i-1)*10*datsampl+1):i*10*datsampl,1)));
end
stims = floor(stims*eegsampl/datsampl);

lowcut = 4;
highcut = 20;
firfiltb = fir1(2*floor(0.25*sampl),[lowcut/eegsampl*2,highcut/eegsampl*2]);
filtseg = Filter0(firfiltb,eegseg);

plot(dataseg(1:round(datsampl/eegsampl):end,1))
hold on
plot(eegseg(:,1),'r')
plot(filtseg(:,1),'g')
plot(stims,eegseg(stims,1),'.','markersize',10,'color',[0 0 0])

forder = 4;
Ripple = 20;
lowcut = 4;
highcut = 20;
[b a] = Scheby2(forder, Ripple, [lowcut highcut]/eegsampl);
filtseg = Sfiltfilt(b,a,eegseg);

figure(2);
clf
for j=1:4 
    subplot(4,1,j);
    for i=2:length(stims)-1
        hold on; 
        plot(filtseg((stims(i)-5*eegsampl):(stims(i)+5*eegsampl),j)); 
    end
end
figure(3); 
clf
for j=5:8
    subplot(4,1,j-4);
    for i=2:length(stims)-1
        hold on; 
        plot(filtseg((stims(i)-5*eegsampl):(stims(i)+5*eegsampl),j)); 
    end
end
