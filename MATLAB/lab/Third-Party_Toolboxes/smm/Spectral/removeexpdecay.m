function uckfay(filename,numch,chno)

eeg = readmulti([filename '.eeg'],numch,chno);

[p,f] = spectrum(eeg,2^12,2^9,2^10,1250);

[beta,ee] = hajexpfit(f,log(p));

plot(f,ee);)
