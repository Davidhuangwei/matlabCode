% CalcWhitening(Exponent)
% calculates whitening filter by invfreqz

function CalcWhitening(Exponent, order, chan1)

% make filter
f = logspace(-5, 0, 50);
fTraining = f*10000;
wt = [10, 10, ones(1, 48)];
aTraining = fTraining.^Exponent;

% uncomment this is you want to do it the reverse way
 [b a] = invfreqz(1./aTraining, f*pi, 0, order);
% uncomment this if you want to do it the forward way
% [a b] =invfreqz(aTraining, f*pi, order, 0, wt);

% filter data
chan1filt = filter(a, 1, chan1);

% compute spectrum
[pxxnew freq] = psd(chan1filt(20:20000), 4096, 20000);
[pxxold freq] =psd(chan1(20:20000), 4096, 20000);

% calculate freqz
FilterTransfer = abs(freqz(a, 1, freq, 20000));

figure(1);
% plot new spectrum, old spectrum, and new estimate of old spectrum
subplot(2,1,1);
loglog(freq, pxxold, freq, pxxnew, freq, pxxnew./(FilterTransfer.^2));
subplot(2,1,2);
semilogy(freq, pxxold, freq, pxxnew, freq, pxxnew./(FilterTransfer.^2));


figure(2);
% compare inteded frequency response to actual response
subplot(2,1,1);
loglog(fTraining, aTraining, fTraining,1e2*abs(freqz(a, 1, fTraining, 20000)));
subplot(2,1,2);
semilogy(fTraining, aTraining, fTraining,abs(freqz(a, 1, fTraining, 20000)));


%figure(3);
% plot some data
%plot(2000:20000, chan1filt(2000:20000));

disp(a);