function CalcBadChanCohPowDiff4(animal,behavior,fileBaseMat,beginTimeMat,nChan,channels,powDiffBool,cohBool)

if ~exist('powDiffBool','var') | isempty(powDiffBool)
    powDiffBool = 1;
end
if ~exist('cohBool','var') | isempty(cohBool)
    cohBool = 1;
end

if ~exist('fileBaseMat','var') | isempty(fileBaseMat) | ~exist('beginTimeMat','var') | isempty(beginTimeMat)
    load([animal '_' behavior '_BadChanAnal_Segs.mat']);
end

datsampl = 20000;
downsampl = 4000;
nFFT = 2^12;
winLength = 2^11;
NW = 1;

if strcmp(animal,'sm9608') | strcmp(animal,'sm9614')
    firstFile = fileBaseMat(1,8:10);
    lastFile = fileBaseMat(end,8:10);
end
if strcmp(animal,'sm9603') | strcmp(animal,'sm9601')
    firstFile = fileBaseMat(1,10:12);
    lastFile = fileBaseMat(end,10:12);
end

fprintf('\nanimal = %s, behavior = %s\n', animal,behavior);
% calculate the coherence
for i = 1:size(fileBaseMat,1)
    % load data and resample
    filename = [fileBaseMat(i,:)];
    fprintf('Processing file: %s\n', filename);
    data = bload(filename, [nChan 10*datsampl], beginTimeMat(i)*datsampl*2*nChan,'int16');
    data = resample(data', downsampl, datsampl);
    
    if powDiffBool
        % Calculate the difference in power
        [yo, fo, ch] = mtcsglong_sm(data(:,channels),nFFT,downsampl,winLength,[],NW);
        powDiff = zeros(length(fo),length(channels),length(channels));
        for m=1:length(channels)
            for n=1:length(channels)
                powDiff(:,channels(m),channels(n)) = squeeze(mean(1-abs((yo(:,:,channels(m))-yo(:,:,channels(n)))./(yo(:,:,channels(m))+yo(:,:,channels(n)))),1));
            end
        end
        clear yo;
        save([fileBaseMat(i,:) '_' behavior '_powDiff.mat'], 'fo','powDiff','channels');
        clear fo;
        clear powDiff;
    end

    if cohBool
        % calculate the coherence
        [yo, fo] = mtcsd(data(:,channels),nFFT,downsampl,winLength,[],NW);
        clear data;
        save([fileBaseMat(i,:) '_' behavior '_csd.mat'], 'fo', 'yo','channels');
        cohYo = Csd2Coherence(yo);
        clear yo;
        save([fileBaseMat(i,:) '_' behavior '_coh.mat'], 'fo','cohYo','channels');
        clear cohYo;
        clear fo;
    end
end

% average across depths in the brain
fprintf('Averaging across files ...\n')
if powDiffBool
    % for the difference in power
    for i = 1:size(fileBaseMat,1)
        filename = [fileBaseMat(i,:) '_' behavior '_powDiff.mat'];
        load(filename);
        if ~exist('avePowDiff','var')
            avePowDiff = zeros(size(powDiff));
        end
        powDiff = powDiff./size(fileBaseMat,1);
        avePowDiff = avePowDiff + powDiff;
        fprintf('PowDiff: ');
        fprintf('%i/1, ', avePowDiff(1,1,1));
        fprintf('\n');
        clear powDiff;
    end
    save([behavior '_powDiff_' firstFile '-' lastFile '.mat'], 'fo', 'avePowDiff')
    clear avePowDiff;
end

if cohBool
    % for the cross spectral density
    for i = 1:size(fileBaseMat,1)
        filename = [fileBaseMat(i,:) '_' behavior '_csd.mat'];
        load(filename);
        if ~exist('aveYo','var')
            aveYo = zeros(size(yo));
        end
        yo = yo./size(fileBaseMat,1);
        aveYo = aveYo + yo;
        clear yo;
    end
    save([behavior '_csd_' firstFile '-' lastFile '.mat'], 'fo', 'aveYo')
    clear aveYo;
    % for coherence
    for i = 1:size(fileBaseMat,1)
        filename = [fileBaseMat(i,:) '_' behavior '_coh.mat'];
        load(filename);
        if ~exist('aveCohYo','var')
            aveCohYo = zeros(size(cohYo));
        end
        cohYo = cohYo./size(fileBaseMat,1);
        aveCohYo = aveCohYo + cohYo;
        fprintf('Coh: ');
        fprintf('%i/1, ', aveCohYo(1,1,1));
        fprintf('\n');
        clear cohYo;
    end
    save([behavior '_coh_' firstFile '-' lastFile '.mat'], 'fo', 'aveCohYo')
    clear aveCohYo;
end

return


