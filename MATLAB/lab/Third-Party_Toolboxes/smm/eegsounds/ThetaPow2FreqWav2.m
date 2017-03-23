function ThetaPow2FreqWav2(nOctaves,npo,timeWindow,frequencies,waveFunc)

if ~exist('nOctaves','var') | isempty(nOctaves)
    nOctaves = [2];
end
if ~exist('npo','var') | isempty(npo)
    npo = [12];
end
if ~exist('timeWindow','var') | isempty(timeWindow)
    timeWindow = [200];
end
if ~exist('frequencies','var') | isempty(frequencies)
    frequencies = [440];
end
if ~exist('waveFunc','var') | isempty(waveFunc)
    waveFunc = 'sawtooth';
end

timeWindow = timeWindow/1000; % convert to sec

pyrpow = readmulti('sm9603m2_241_s1_287_6-14Hz.eeg.100DBpow',97,34);
radpow = readmulti('sm9603m2_241_s1_287_6-14Hz.eeg.100DBpow',97,37);
molpow = readmulti('sm9603m2_241_s1_287_6-14Hz.eeg.100DBpow',97,41);
dggpow = readmulti('sm9603m2_241_s1_287_6-14Hz.eeg.100DBpow',97,59);

names = ['pyr';'rad';'mol';'dgg'];
powmats = [pyrpow,radpow,molpow,dggpow];
%powmats = [pyrpow];%,radpow,molpow,dggpow];

%powmats = powmats./33;
for x=1:length(nOctaves)
    for y=1:length(npo)
        for z=1:length(timeWindow)
            powmats = (nOctaves(x)*npo(y)/1000).*powmats; % assumes average file has variation about +-1000 to set +- nOctaves(x)
            for a = 1:4
                powmat = powmats(:,a);
                for b=1:3
                    meanPow = mean(powmat);
                    len = length(powmat);
                    sr = 44100;
                    eegsamp = 1250;

                    toneB = zeros(size([0:1/sr:60]'));
                    %toneB = zeros(size([0:1/sr:len/eegsamp]'));
                    %for i=1:timeWindow(z)*eegsamp:len-timeWindow(z)*eegsamp
                    for i=1:timeWindow(z)*sr:sr*60
                        freqmod = round(mean(powmat(max(1,floor(i*eegsamp/sr)):max(1,floor(i*eegsamp/sr-1+timeWindow(z)*eegsamp)))-meanPow));
                        if strcmp(waveFunc,'sawtooth');
                            waveSeg = sawtooth(pi * 2 * (frequencies(b)*2^(freqmod/npo(y))) * [0:1/sr:timeWindow(z)*10]')*0.99;
                        else
                            waveFunc
                            NO_SUCH_WAVE_FUNCTION
                        end
                        if i==1
                            toneB(i:i-1+timeWindow(z)*sr) = waveSeg(1:timeWindow(z)*sr);
                        else
                            samePhase = find(abs(waveSeg(1:end-timeWindow(z)*sr)-toneB(i-1))==min(abs(waveSeg(1:end-timeWindow(z)*sr)-toneB(i-1))));
                            toneB(i:i-1+timeWindow(z)*sr) = waveSeg(samePhase(1):samePhase(1)-1+timeWindow(z)*sr);
                        end
                    end
                    filename = ['/BEEF1/smm/eegsounds/' waveFunc '/ThetaPowModFreq2_' waveFunc '_' names(a,:) '_' num2str(frequencies(b)) 'Hz_DB_Oct' num2str(nOctaves(x)) '_npo' num2str(npo(y)) '_time' num2str(timeWindow(z)*1000) '.wav'];
                    fprintf('\nwriting %s', filename);
                    wavwrite([toneB],sr,16,filename);
                    %plot(toneB(1:sr))
                end
            end
        end
    end
end
return
        %timeWinBegin = zeros(size([0:1/sr:len/1250]'));
        %phaseOffset = zeros(size([0:1/sr:len/1250]'));
        %freqmodmat = zeros(size(toneA));
        toneIndex = 1;
        outIndex = 1;
       %ts = [0:1/sr:2*len/1250]';
        %toneA = sawtooth(pi * 2 * frequencies(b) * ts)*0.99;
                
                %fprintf('%s,',num2str(freqmod));
                %fprintf('%s,',num2str(samePhase(1)));
                %fprintf('%s,',num2str(min(abs(waveSeg(1:end-timeWindow(z)*sr)-toneB(end)))));
                %keyboard
                %timeWinBegin(i) = samePhase(1);
                %phaseOffset(i) = min(abs(waveSeg(1:end-timeWindow(z)*sr)-toneB(end)));



                