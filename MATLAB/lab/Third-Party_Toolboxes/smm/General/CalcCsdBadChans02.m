function csdBadChan = CalcCsdBadChans(badChans,eegChanMat,csdChanMat)
%function csdBadChan = CalcCsdBadChans(badChans,eegChanMat,csdChanMat)

shift = (size(eegChanMat,1)-size(csdChanMat,1))/2;

padCsdChanMat = [zeros(shift,size(csdChanMat,2)); csdChanMat; zeros(shift,size(csdChanMat,2))];
for j=1:length(badChans)
    indexes(j) = find(badchans(j) == eegChanMat(:);
end
csdBadChan = padCsdChanMat(indexes);

% shift = (EEGnChanPerShank-CSDnChanPerShank)/2;
% csdBadChan = badChans(mod(badChans,EEGnChanPerShank)+shift<=EEGnChanPerShank & mod(badChans,EEGnChanPerShank)-shift>0);
% csdBadChan = csdBadChan-shift*floor(csdBadChan/EEGnChanPerShank)-shift*ceil(csdBadChan/EEGnChanPerShank);
