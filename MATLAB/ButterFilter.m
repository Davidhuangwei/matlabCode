function x=ButterFilter(x,wn,FS,passmode)
% function x=ButterFilter(x,wn,FS,passmode)
[z, p, kk] = butter(4,wn/(FS/2),passmode);
[b, a]=zp2sos(z,p,kk);
x = filtfilt(b, a, x);