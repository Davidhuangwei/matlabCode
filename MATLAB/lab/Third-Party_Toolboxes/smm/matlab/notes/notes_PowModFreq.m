pyr = readmulti('sm9603m2_241_s1_287.eeg',97,50);
pyr = pyr./(max(pyr));
wavwrite([radiatum],1250,16,'/u12/smm/radiatum1.wav')
pyr10 = resample(pyr,10000,1250);
dgfilt1_5 = Filter0(firfiltb1_5, dg); 
firfiltb150_250 = fir1(200,[150/20000*2,250/20000*2]);  

radpow = radpow./100;

pyrpow = readmulti('sm9603m2_241_s1_287_6-14Hz.eeg.100DBpow',97,34);
radpow = readmulti('sm9603m2_241_s1_287_6-14Hz.eeg.100DBpow',97,37);
molpow = readmulti('sm9603m2_241_s1_287_6-14Hz.eeg.100DBpow',97,41);
dggpow = readmulti('sm9603m2_241_s1_287_6-14Hz.eeg.100DBpow',97,59);

powmats = [pyrpow,radpow,molpow,dggpow];
names = ['pyr';'rad';'mol';'dgg'];
freqs = [110;220;440];
for a = 1:4
    powmat = powmats(:,a);
    for b=1:3
        meanPow = mean(powmat);
        len = length(powmat);
        sr = 44100;
        %ts = [0:1/sr:2*len/1250]';
        %toneA = sawtooth(pi * 2 * freqs(b) * ts)*0.99;
        toneB = zeros(size([0:1/sr:len/1250]'));
        %freqmodmat = zeros(size(toneA));
        i = 0;
        j = 1;
        k = 1;
        
        while j<=length(toneB) & floor(k*1250/sr) <=length(powmat) % & i<=length(toneA)
            freqmod = ceil(powmat(max([1,floor(k*1250/sr)]))-meanPow);
            if freqmod >= 0
                %toneB(j) = toneA(i);
                toneB(j) = sawtooth(pi * 2 * freqs(b) * i/sr)*0.99;
                i = i + freqmod;
            end
            if freqmod < 0
                for l = 1:abs(freqmod)
                    %toneB(j) = toneA(i);
                    toneB(j) = sawtooth(pi * 2 * freqs(b) * i/sr)*0.99;
                    j = j + 1;
                end
            end
            %freqmodmat(i) = freqmod;
            i = i+1;
            j = j+1;
            k = k+1;
        end
        filename = ['/BEEF1/smm/eegsounds/new/powModFreq_' names(a,:) '_' num2str(freqs(b)) '_15.wav'];
        wavwrite([toneB],sr,16,filename);
    end
end


for a = 1:4
    powmat = powmats(:,a);
    for b=1:3
        meanPow = mean(powmat);
        len = length(powmat);
        sr = 44100;
        ts = [0:1/sr:len/1250]';
        toneA = sawtooth(pi * 2 * freqs(b) * ts)*0.99;
        toneB = zeros(size(toneA));
        %freqmodmat = zeros(size(toneA));
        i = 1;
        j = 1;
        while i<length(toneA) & j<length(toneB)
            freqmod = round(powmat(max([1,floor(i*1250/sr)]))-meanPow);
            if freqmod >= 0
                toneB(j) = toneA(i);
                i = i + freqmod;
            end
            if freqmod < 0
                for k = 1:abs(freqmod)
                    toneB(j) = toneA(i);
                    j = j + 1;
                end
            end
            %freqmodmat(i) = freqmod;
            i = i+1;
            j = j+1;
        end
        filename = ['/BEEF1/smm/eegsounds/new/powModFreq_' names(a,:) '_' num2str(freqs(b)) '_12.wav'];
        wavwrite([toneB],sr,16,filename);
    end
end

powmats = powmats./100;

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
                    toneB(outIndex) = sawtooth(pi * 2 * freqs(b) * toneIndex/sr)*0.99;
                    outIndex = outIndex + 1;
                    toneIndex = toneIndex + 1 + freqmod;
                end
            end
            if freqmod < 0
                for j=1:timewindow*sr
                    toneB(outIndex) = sawtooth(pi * 2 * freqs(b) * toneIndex/sr)*0.99;
                    outIndex = outIndex + 1;
                    if mod(j,abs(freqmod)) == 0
                        toneIndex = toneIndex + 1;
                    end
                end
            end
        end
        filename = ['/BEEF1/smm/eegsounds/new/powModFreq_' names(a,:) '_' num2str(freqs(b)) '_DB.wav'];
        wavwrite([toneB],sr,16,filename);
    end
end
             
for a = 1:4
    powmat = powmats(:,a);
    for b=1:3
        meanPow = mean(powmat);
        len = length(powmat);
        sr = 44100;
        eegsamp = 1250;
        timewindow = 0.04 %sec
        %ts = [0:1/sr:2*len/1250]';
        %toneA = sawtooth(pi * 2 * freqs(b) * ts)*0.99;
        toneB = zeros(size([0:1/sr:len/1250]'));
        %freqmodmat = zeros(size(toneA));
        tonalInterval = 8;
        toneIndex = 1;
        outIndex = 1;
        for i=1:timewindow*eegsamp:len-timewindow*eegsamp
            freqmod = round(mean(powmat(i:i-1+timewindow*eegsamp)-meanPow));
            if freqmod >= 0
                sampleWave = sawtooth(pi * 2 * freqs(b)*(freqmod+1)/tonalInterval * [1:ceil(sr/freqs(b))]*0.99;
                phaseOffset = find(sampleWave == min(sampleWave-toneB(max(outIndex-1,0))));
                toneB(outIndex:outIndex-1+timewindow*sr) = sawtooth(pi * 2 * freqs(b) * [toneIndex/sr)*0.99;
                for j=1:timewindow*sr
                    toneB(outIndex) = sawtooth(pi * 2 * freqs(b) * toneIndex/sr)*0.99;
                    outIndex = outIndex + 1;
                    toneIndex = toneIndex + 1 + freqmod;
                end
            end
            if freqmod < 0
                for j=1:timewindow*sr
                    toneB(outIndex) = sawtooth(pi * 2 * freqs(b) * toneIndex/sr)*0.99;
                    outIndex = outIndex + 1;
                    if mod(j,abs(freqmod)) == 0
                        toneIndex = toneIndex + 1;
                    end
                end
            end
        end
        filename = ['/BEEF1/smm/eegsounds/new/powModFreq_' names(a,:) '_' num2str(freqs(b)) '_18.wav'];
        wavwrite([toneB],sr,16,filename);
    end
end
        while j<=length(toneB) & floor(k*1250/sr) <=length(powmat) % & i<=length(toneA)
            freqmod = round(powmat(max([1,floor(k*1250/sr)]))-meanPow);
            if freqmod >= 0
                %toneB(j) = toneA(i);
                toneB(j) = sawtooth(pi * 2 * freqs(b) * i/sr)*0.99;
                i = i + freqmod;
            end
            if freqmod < 0
                for l = 1:abs(freqmod)
                    %toneB(j) = toneA(i);
                    toneB(j) = sawtooth(pi * 2 * freqs(b) * i/sr)*0.99;
                    j = j + 1;
                end
            end
            %freqmodmat(i) = freqmod;
            i = i+1;
            j = j+1;
            k = k+1;
        end
        filename = ['/BEEF1/smm/eegsounds/new/powModFreq_' names(a,:) '_' num2str(freqs(b)) '_13.wav'];
        wavwrite([toneB],sr,16,filename);
    end
end

