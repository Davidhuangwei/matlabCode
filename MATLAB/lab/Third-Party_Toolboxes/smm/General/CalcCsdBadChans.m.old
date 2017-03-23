function csdBadChan = CalcCsdBadChans(badChans,EEGnChanPerShank,CSDnChanPerShank)
% function csdBadChan = CalcCsdBadChans(badChans,EEGnChanPerShank,CSDnChanPerShank)
shift = (EEGnChanPerShank-CSDnChanPerShank)/2;
csdBadChan = badChans(mod(badChans,EEGnChanPerShank)+shift<=EEGnChanPerShank & mod(badChans,EEGnChanPerShank)-shift>0);
csdBadChan = csdBadChan-shift*floor(csdBadChan/EEGnChanPerShank)-shift*ceil(csdBadChan/EEGnChanPerShank);
