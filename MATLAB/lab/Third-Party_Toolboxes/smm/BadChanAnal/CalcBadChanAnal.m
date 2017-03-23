function CalcBadChanAnal(animal,behavior,fileBaseCell,beginTimes,nChan,channels,powSimBool,cohBool)
% function CalcBadChanAnal(animal,behavior,fileBaseCell,beginTimes,nChan,channels,powSimBool,cohBool)
% 
% This function calculates the cross-spectral density, coherence, and
% cross-channel power similarity (1-((chanA-ChanB)/(chanA+ChanB)) for all
% channel pairs in each frequency bin.
%
% INPUT VARIABLES
% animal: a string used for file naming.
% behavior: a string used for file naming.
% fileBaseCell: a matrix where each row is a text string that is the
% basename of a .dat file.
% beginTimes: vector containing a begin time (in seconds) corresponding
% to the files in fileBaseCell designating the beginning of the 10 second
% sample on which calculations will be performed.
% nChan: total number of channels in .dat file.
% channels: channels on which calculation is to be performed.
% powSimBool: boolean to determine whether power similarity is calculated
% cohBool: boolean to determine whether coherence and cross-spectral density is calculated

if ~exist('powSimBool','var') | isempty(powSimBool)
    powSimBool = 1;
end
if ~exist('cohBool','var') | isempty(cohBool)
    cohBool = 1;
end

if ~exist('fileBaseCell','var') | isempty(fileBaseCell) | ~exist('beginTimes','var') | isempty(beginTimes)
    load([animal '_' behavior '_BadChanAnal_Segs.mat']);
end

datsampl = 20000; % original sampling rate
downsampl = 4000; % downsampled rate
nFFT = 2^12; % zero padding
winLength = 2^11; % window length for Fourier
NW = 1; % determines number of tapers

if strcmp(animal,'sm9608') | strcmp(animal,'sm9614')
    firstFile = fileBaseCell{1}(8:10);
    lastFile = fileBaseCell{end}(8:10);
elseif strcmp(animal,'sm9603') | strcmp(animal,'sm9601')
    firstFile = fileBaseCell{1}(10:12);
    lastFile = fileBaseCell{end}(10:12);
else
    firstFile = fileBaseCell{1};
    lastFile = fileBaseCell{end};
end

fprintf('\nanimal = %s, behavior = %s\n', animal,behavior);
% calculate the coherence
for i = 1:length(fileBaseCell)
    % load data and resample
    filename = [fileBaseCell{i}];
    fprintf('Processing file: %s\n', filename);
    data = bload(filename, [nChan 10*datsampl], beginTimes(i)*datsampl*2*nChan,'int16');
    data = resample(data', downsampl, datsampl);
    
    if powSimBool
        % Calculate the difference in power
        [yo, fo, ch] = mtcsglong_sm(data(:,channels),nFFT,downsampl,winLength,[],NW);
        powSim = zeros(length(fo),length(channels),length(channels));
        for m=1:length(channels)
            for n=1:length(channels)
                powSim(:,channels(m),channels(n)) = squeeze(mean(1-abs((yo(:,:,channels(m))-yo(:,:,channels(n)))./(yo(:,:,channels(m))+yo(:,:,channels(n)))),1));
            end
        end
        clear yo;
        save([fileBaseCell{i} '_' behavior '_powSim.mat'], 'fo','powSim','channels');
        clear fo;
        clear powSim;
    end

    if cohBool
        % calculate the coherence
        [yo, fo] = mtcsd(data(:,channels),nFFT,downsampl,winLength,[],NW);
        clear data;
        save([fileBaseCell{i} '_' behavior '_csd.mat'], 'fo', 'yo','channels');
        cohYo = Csd2Coherence(yo);
        clear yo;
        save([fileBaseCell{i} '_' behavior '_coh.mat'], 'fo','cohYo','channels');
        clear cohYo;
        clear fo;
    end
end

% average across depths in the brain
fprintf('Averaging across files ...\n')
if powSimBool
    % for the difference in power
    for i = 1:length(fileBaseCell)
        filename = [fileBaseCell{i} '_' behavior '_powSim.mat'];
        load(filename);
        if ~exist('avePowSim','var')
            avePowSim = zeros(size(powSim));
        end
        powSim = powSim./length(fileBaseCell);
        avePowSim = avePowSim + powSim;
        fprintf('PowSim: ');
        fprintf('%i/1, ', avePowSim(1,1,1));
        fprintf('\n');
        clear powSim;
    end
    save([behavior '_powSim_' firstFile '-' lastFile '.mat'], 'fo', 'avePowSim')
    clear avePowSim;
end

if cohBool
    % for the cross spectral density
    for i = 1:length(fileBaseCell)
        filename = [fileBaseCell{i} '_' behavior '_csd.mat'];
        load(filename);
        if ~exist('aveYo','var')
            aveYo = zeros(size(yo));
        end
        yo = yo./length(fileBaseCell);
        aveYo = aveYo + yo;
        clear yo;
    end
    save([behavior '_csd_' firstFile '-' lastFile '.mat'], 'fo', 'aveYo')
    clear aveYo;
    % for coherence
    for i = 1:length(fileBaseCell)
        filename = [fileBaseCell{i} '_' behavior '_coh.mat'];
        load(filename);
        if ~exist('aveCohYo','var')
            aveCohYo = zeros(size(cohYo));
        end
        cohYo = cohYo./length(fileBaseCell);
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


