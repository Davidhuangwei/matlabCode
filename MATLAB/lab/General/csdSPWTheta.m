
fileBase='ni02-20100818-02-sleep-nlx';

[Data OrigIndex]= LoadBinary([fileBase '.eeg'],1:32,64);
load([fileBase '.sts.REM'])
y = SelectPeriods(Data', ni02_20100818_02_sleep_nlx_sts, 'c', 1);

filty=ButFilter(y(:,10),2,[4 15]/625,'bandpass');
lm=LocalMinima(filty,100,100);
avcycle = TriggeredAv(y,300,300,lm);


rip = ButFilter(Data(10,:)',2,[120 250]/625,'bandpass');
powrip = abs(hilbert(rip));
rpowrip = resample(powrip,1,10);     
srpowrip = smooth(rpowrip);                 
rips = LocalMinima(-srpowrip,5,-500);
avspw = TriggeredAv(powrip,1000,1000,rips*10);
spwav = TriggeredAv(Data',100,100, rips*10);

%PlotTraces(spwav,[-100:100]/1.25,1250,10)
figure
subplot(121)
PlotCSD(spwav,[-100:100]/1.25,[],2,[],5);

subplot(122)
PlotCSD(avcycle,[-300:300]/1.25,[],2);


out=FieldProfile(fileBase);
save([fileBase '.FieldProfile.REM.mat'],'out')
out=FieldProfile(fileBase,'display');
