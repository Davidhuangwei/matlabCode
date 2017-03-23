function ThetaPow2FreqWav(DB100,waveFunc)

pyrpow = readmulti('sm9603m2_241_s1_287_6-14Hz.eeg.100DBpow',97,34);
radpow = readmulti('sm9603m2_241_s1_287_6-14Hz.eeg.100DBpow',97,37);
molpow = readmulti('sm9603m2_241_s1_287_6-14Hz.eeg.100DBpow',97,41);
dggpow = readmulti('sm9603m2_241_s1_287_6-14Hz.eeg.100DBpow',97,59);

names = ['pyr';'rad';'mol';'dgg'];
freqs = [110;220;440];
powmats = [pyrpow,radpow,molpow,dggpow];

if ~DB100
    powmats = powmats./100;
end

for a = 1:4
    powmat = powmats(:,a);
    for b=1:3
        meanPow = mean(powmat);
        len = length(powmat);
        sr = 44100;
        eegsamp = 1250;
        timewindow = 0.04; %sec
        %ts = [0:1/sr:2*len/1250]';
        %toneA = sawtooth(pi * 2 * freqs(b) * ts)*0.99;
        toneB = zeros(size([0:1/sr:len/1250]'));
        %freqmodmat = zeros(size(toneA));
        toneIndex = 1;
        outIndex = 1;
        for i=1:timewindow*eegsamp:len-timewindow*eegsamp
            freqmod = round(mean(powmat(i:i-1+timewindow*eegsamp)-meanPow));
            if freqmod >= 0
                for j=1:timewindow*sr
                    if strcmp(waveFunc, 'sawtooth')
                        toneB(outIndex) = sawtooth(pi * 2 * freqs(b) * toneIndex/sr)*0.99;
                    end
                    if strcmp(waveFunc, 'square')
                        toneB(outIndex) = square(pi * 2 * freqs(b) * toneIndex/sr)*0.99;
                    end
                    outIndex = outIndex + 1;
                    toneIndex = toneIndex + 1 + freqmod;
                end
            end
            if freqmod < 0
                for j=1:timewindow*sr
                    if strcmp(waveFunc, 'sawtooth')
                        toneB(outIndex) = sawtooth(pi * 2 * freqs(b) * toneIndex/sr)*0.99;
                    end
                    if strcmp(waveFunc, 'square')
                        toneB(outIndex) = square(pi * 2 * freqs(b) * toneIndex/sr)*0.99;
                    end
                    outIndex = outIndex + 1;
                    if mod(j,abs(freqmod)) == 0
                        toneIndex = toneIndex + 1;
                    end
                end
            end
        end
        if DB100
            filename = ['/BEEF1/smm/eegsounds/' waveFunc '/ThetaPowModFreq_' waveFunc '_' names(a,:) '_' num2str(freqs(b)) 'Hz_DB100.wav'];
        else
            filename = ['/BEEF1/smm/eegsounds/' waveFunc '/ThetaPowModFreq_' waveFunc '_' names(a,:) '_' num2str(freqs(b)) 'Hz_DB.wav'];
        end
        wavwrite([toneB],sr,16,filename);
    end
end