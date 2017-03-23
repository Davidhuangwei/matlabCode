function CalcBadChanAnal2(animal,behavior,nChan,channels,varargin)
% function CalcBadChanAnal2(animal,behavior,nChan,channels,powSimBool,cohBool,datSampl)
% 
% This function calculates the cross-spectral density, coherence, and
% cross-channel power similarity (1-((chanA-ChanB)/(chanA+ChanB)) for all
% channel pairs in each frequency bin.
%
% INPUT VARIABLES
% animal: a string used for file naming.
% behavior: a string used for file naming.
% nChan: total number of channels in .dat file.
% channels: channels on which calculation is to be performed.
% powSimBool: boolean to determine whether power similarity is calculated
% cohBool: boolean to determine whether coherence and cross-spectral density is calculated
% datSampl: original sampling rate, default=20000 samp/sec.
% 
%REQUIRED FILE
% A .mat file with the name [animal '_' behavior '_BadChanAnal_Segs.mat']
% containing the variables:
% fileNamesCell: a cell array containing a file name in each cell.
% beginTimes: vector containing a begin time (in seconds) corresponding
% to the files in fileNamesCell designating the beginning of the 10 second
% sample on which calculations will be performed.

[powSimBool cohBool datSampl] = DefaultArgs(varargin,{1,1,20000});

load([animal '_' behavior '_BadChanAnal_Segs.mat']);

%datSampl = 20000; % original sampling rate
downsampl = 4000; % downsampled rate
nFFT = 2^12; % zero padding
winLength = 2^11; % window length for Fourier
NW = 1; % determines number of tapers

if strcmp(animal,'sm9608') | strcmp(animal,'sm9614')
    firstFile = fileNamesCell{1}(8:10);
    lastFile = fileNamesCell{end}(8:10);
elseif strcmp(animal,'sm9603') | strcmp(animal,'sm9601')
    firstFile = fileNamesCell{1}(10:12);
    lastFile = fileNamesCell{end}(10:12);
else
    firstFile = fileNamesCell{1};
    lastFile = fileNamesCell{end};
end

fprintf('\nanimal = %s, behavior = %s\n', animal,behavior);
% calculate the coherence
for i = 1:length(fileNamesCell)
    % load data and resample
    filename = [fileNamesCell{i}];
    fprintf('Processing file: %s\n', filename);
    data = bload(filename, [nChan 10*datSampl], beginTimes(i)*datSampl*2*nChan,'int16');
    data = resample(data', downsampl, datSampl);
    
    if powSimBool
        % Calculate the difference in power
        [yo, fo, ch] = mtcsglong(data(:,channels),nFFT,downsampl,winLength,[],NW);
        powSim = zeros(length(fo),length(channels),length(channels));
        for m=1:length(channels)
            for n=1:length(channels)
                powSim(:,channels(m),channels(n)) = squeeze(mean(1-abs((yo(:,:,channels(m))-yo(:,:,channels(n)))./(yo(:,:,channels(m))+yo(:,:,channels(n)))),1));
            end
        end
        clear yo;
        save([fileNamesCell{i} '_' behavior '_' num2str(beginTimes(i)) '_powSim.mat'], 'fo','powSim','channels');
        clear fo;
        clear powSim;
    end

    if cohBool
        % calculate the coherence
        [yo, fo] = mtcsd(data(:,channels),nFFT,downsampl,winLength,[],NW);
        clear data;
        %save([fileNamesCell{i} '_' behavior '_' num2str(beginTimes(i)) '_csd.mat'], 'fo', 'yo','channels');
        cohYo = Csd2Coherence(yo);
        clear yo;
        save([fileNamesCell{i} '_' behavior '_' num2str(beginTimes(i)) '_coh.mat'], 'fo','cohYo','channels');
        clear cohYo;
        clear fo;
    end
end

% average across depths in the brain
fprintf('Averaging across files ...\n')
if powSimBool
    % for the difference in power
    for i = 1:length(fileNamesCell)
        filename = [fileNamesCell{i} '_' behavior '_' num2str(beginTimes(i)) '_powSim.mat'];
        load(filename);
        if ~exist('avePowSim','var')
            avePowSim = zeros(size(powSim));
        end
        powSim = powSim./length(fileNamesCell);
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
    if 0
        % for the cross spectral density
        for i = 1:length(fileNamesCell)
            filename = [fileNamesCell{i} '_' behavior '_' num2str(beginTimes(i)) '_csd.mat'];
            load(filename);
            if ~exist('aveYo','var')
                aveYo = zeros(size(yo));
            end
            yo = yo./length(fileNamesCell);
            aveYo = aveYo + yo;
            clear yo;
        end
        save([behavior '_csd_' firstFile '-' lastFile '.mat'], 'fo', 'aveYo')
        clear aveYo;
    end
    % for coherence
    for i = 1:length(fileNamesCell)
        filename = [fileNamesCell{i} '_' behavior '_' num2str(beginTimes(i)) '_coh.mat'];
        load(filename);
        if ~exist('aveCohYo','var')
            aveCohYo = zeros(size(cohYo));
        end
        cohYo = cohYo./length(fileNamesCell);
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


