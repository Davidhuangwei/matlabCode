function CalcThetaPeakTrigRes

firfiltb = fir1(odd(3/filtFreqRange(1)*eegSamp)-1,[filtFreqRange(1)/eegSamp*2,filtFreqRange(2)/eegSamp*2]);
nChan = 
selChan = 

trialDesig = load(['TrialDesig/' glmVersion '/' analRoutine '.mat']);
for j=1:length(fileBaseCell)
    time = LoadDesigVar(fileBaseCell(j),spectAnalDir,'time',trialDesig.trialDesig)

    epochs = Times2Epochs(time,timeWin);

    for k=1:selChan
        eeg = readmulti([SC(fileBaseCell{j}) fileBaseCell{j} 'fileExt'],nChan,k);
        filt = Filter0(firfiltb, eeg);
           

Theta Peak Trig CSD
Input Vars: spectAnalDir, timeWin, fileExt, analRoutine, fileBaseCell, outputDescription, freqRange, maxFreq,eegSamp, glmVersion
load time using LoadDepVar
time2epochs
for each chan
 readmulti eeg
 filt
 LocalMinima
 for each epoch
  find minima w/in epoch
write thetaTrig.res
output thetaPeak_description_fileExt.res