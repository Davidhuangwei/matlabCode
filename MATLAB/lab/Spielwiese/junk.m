 
 h = 0.02;
 iabi[1]=0.0;
  for(i=1;i<=length;i++)
   nn = sqrt(2.0*h/TAU_I)*gasdev(&idum);
   ia1 = iabi[i-1] - iabi[i-1]*h/TAU_I + nn;
   iabi[i]= iabi[i-1] - 0.5*(ia1+iabi[i-1])*h/TAU_I + nn;
 end
 
 
 
 
 
 
peaks=load('z_peak_0');
rate=load('z_rate_0');

dh = (max(rate(:,1))-min(rate(:,1)))/10000;
BIN = [min(rate(:,1)):dh:max(rate(:,1))];

hh=histcI(peaks(:,1),BIN);
shh = mySmooth(hh,3);

bar(BIN(1:end-1)+dh/2,shh/dh)
hold on
plot(rate(:,1),rate(:,3),'r-');
hold off
    



rate = load('z_rate_0');
peak = load('z_peak_0');

mrate = mean(rate(:,3));
pred = 0.75*(rate(:,3)-mrate) + mrate;


dbins = (max(peak(:,1))-min(peak(:,1)))/2000;
bins = [min(peak(:,1)):dbins:max(peak(:,1))];

ratehist = histcI(peak(:,1),bins)/dbins;
smrate = mySmooth(ratehist,1,1);

clf;
subplot(211)
bar(bins(2:end)-dbins,ratehist)
hold on;
plot(rate(:,1),pred,'r','LineWidth',2);
ylim([0 60])
xlim([1000 1200])

subplot(212)
plot(bins(2:end)-dbins,smrate,'g','LineWidth',2);
hold on;
plot(rate(:,1),pred,'r','LineWidth',2);
ylim([0 60])
xlim([1000 1200])



clf;
plot(rate(:,1),rate(:,2));
hold on;
plot(rate(:,1),(rate(:,3)),'r');


