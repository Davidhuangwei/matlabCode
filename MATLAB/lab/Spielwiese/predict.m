%% function to predict the firing rate response of neuron in vitro
%%
%% (c) 11/2004 Caroline Geisler

clear all

com=sprintf('time=load(''time.dat'');')
eval(com)
                       
com=sprintf('IN=load(''20040218c1f0_input.dat'');')
eval(com)

com=sprintf('OUT=load(''20040218c1f0_output.dat'');'); 
eval(com)

dt = time(2)-time(1);
ll = length(IN);

%% TRANSFER FUNCTION ESTIMATE
%[y,f] = TFESTIMATE(IN,OUT',[],[],[],15000);
%% mtcsd(x,nFFT,Fs,WinLength,nOverlap,NW,Detrend,nTapers)
%[y,f] = mtcsd([IN OUT'],2^12,15000,2^9,[],4,'linear',[],[10 2000]);
[y,f] = mtcsd([IN OUT'],2^12,15000,2^8,2^6,3,'linear',[],[10 2000]);
Txy = sq(y(:,1,2))./abs(sq(y(:,1,1)));

ltf = length(Txy);

freq = f;%[1:ll]'/dt/ll;

amp = abs(Txy);
amp = amp/amp(1,1);
%phi = unwrap(angle(Txy));
phi = (angle(Txy));






%% PARAMETERS
%% Start values/parameters:
exponent = 2.0;
fcut = 200;
delay = 0.8; %%in ms
filter = 0.3;
slope = 0.007;


%%% MODEL PARAMETERS
%%amplitude
%amp(find(freq<fcut),1)=slope*freq(find(freq<fcut))+1-slope;
%amp(find(freq>=fcut),1)=fcut^(exponent)*(slope*fcut+1-slope)./freq(find(freq>=fcut),1).^2;
Mamp(find(freq<fcut),1)=1;
Mamp(find(freq>=fcut),1)=fcut^exponent./(freq(find(freq>=fcut),1)).^exponent;
%Mphi = -2*pi*delay*0.001*freq -exponent*atan(2*pi*freq*filter*0.001);
Mphi = 2*pi*delay*0.001*freq +exponent*atan(2*pi*freq*filter*0.001);

%% prediction
FIN = fft(IN);
fsin = FIN(1:ltf)-mean(FIN);
FOUT = fft(OUT)';
fsout = FOUT(1:ltf);
mrate = mean(OUT);
%%PRED = ifft(amp.*(real(FIN).*cos(phi)-imag(FIN).*sin(phi)) +i*amp.*(imag(FIN).*cos(phi)+real(FIN).*sin(phi)));
%PRED = ifft(Mamp.*(real(fsin).*cos(Mphi)-imag(fsin).*sin(Mphi)) +i*Mamp.*(imag(fsin).*cos(Mphi)+real(fsin).*sin(Mphi)));
PRED = ifft(fsin.*Mamp.*(cos(Mphi) +i*sin(Mphi)));
PRED(find(PRED<0))=0;
%SPRED = (10*(PRED-mean(PRED)) + mean(PRED))*mrate/mean(real(PRED));
SPRED = mrate*(1+slope*(real(PRED)-mean(real(PRED))));




%%%%% PLOT

figure(222)
subplot(3,1,1)
%plot(time,OUT)
plot(time,OUT',time(1:ltf)*1500/544,real(SPRED))
ylabel('rate and prediction [Hz]')
subplot(3,1,2)
plot(time(1:ltf)*1500/544*4,real(SPRED))
ylabel('prediction [Hz]')
subplot(3,1,3)
plot(time,IN)
xlabel('time [s]')
ylabel('input [nA]')


figure(223)
subplot(2,1,1)
loglog(freq(1:ltf),amp,freq(1:ltf),Mamp(1:ltf));

subplot(2,1,2)
semilogx(freq(1:ltf),-unwrap(phi,pi)*180/pi,freq(1:ltf),-unwrap(Mphi(1:ltf),pi)*180/pi);



%%%% TRASH
%>> hist([OUT',real(PRED)],100)
%>> qqplot(OUT,real(PRED))
%>> subplot(211)
%>> qqplot(OUT,real(PRED))
%>> subplot(212)
%>> hist([OUT',real(PRED)],100)
%>> hist([OUT',real(PRED)],40)
