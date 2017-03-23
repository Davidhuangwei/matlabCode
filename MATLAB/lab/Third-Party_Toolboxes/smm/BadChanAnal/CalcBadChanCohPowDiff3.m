function BadChanCohPowDiff(animal,behavior,nChan,channels,powDiffBool,cohBool)

if ~exist('powDiffBool','var') | isempty(powDiffBool)
    powDiffBool = 1;
end
if ~exist('cohBool','var') | isempty(cohBool)
    cohBool = 1;
end

load([animal '_' behavior '_ordering_segs.mat']);

datsampl = 20000;
downsampl = 4000;
nFFT = 2^12;
winLength = 2^11;
NW = 1;

if strcmp(animal,'sm9608')
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
        %yo = 10.*log10(yo);
        [m n o] = size(yo);
        yo4D(:,:,:,1) = yo;
        yo4DT(:,:,1,:) = yo;
        yo4DRep = repmat(yo4D,[1,1,1,size(yo,3)]);
        yo4DTRep = repmat(yo4DT,[1,1,size(yo,3),1]);
        powDiff = squeeze(mean(1-abs((yo4DRep-yo4DTRep)./(yo4DRep+yo4DTRep)),1));
        keyboard
        clear yo;
        clear yo4D;
        clear yo4DT;
        clear yo4DRep;
        clear yo4DTRep;
        if 0
            powDiff = zeros(length(fo),length(channels),length(channels));
            for m=1:length(channels)
                for n=1:length(channels)
                    %powDiff(:,channels(m),channels(n)) = squeeze(mean(1-(((yo(:,:,channels(m))-yo(:,:,channels(n))).^2)./(yo(:,:,channels(m))+yo(:,:,channels(n))).^2).^(1/2),1));
                    powDiff(:,channels(m),channels(n)) = squeeze(mean(1-abs((yo(:,:,channels(m))-yo(:,:,channels(n)))./(yo(:,:,channels(m))+yo(:,:,channels(n)))),1));
                end
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



behavior = 'sws+rem';
measure = 'powDiff'

if strcmp(behavior,'sws') 
    load(['sws_coh_' firstFile '-' lastFile '.mat']);
    %swsfullaveCohYo = aveCohYo;
end
if strcmp(behavior,'rem') 
    load(['rem_coh_' firstFile '-' lastFile '.mat']);
    %remaveCohYo = aveCohYo;
end
if strcmp(behavior,'sws+rem')
    load(['sws_coh_' firstFile '-' lastFile '.mat']);
    swsaveCohYo = aveCohYo;
    load(['rem_coh_' firstFile '-' lastFile '.mat']);
    remaveCohYo = aveCohYo;
    aveCohYo = (swsaveCohYo + remaveCohYo)./2;
end

if strcmp(behavior,'sws+rem')
    load(['sws_powDiff_' firstFile '-' lastFile '.mat']);
    swsavePowDiff = avePowDiff;
    load(['rem_powDiff_' firstFile '-' lastFile '.mat']);
    remavePowDiff = avePowDiff;
    aveCohYo = (remavePowDiff + swsavePowDiff)./2;
end


onlyreal = 0;
diag = 1;
printBool = 1;
%% for shanks individually %%
chans = [1:16;17:32;33:48;49:64;65:80;81:96];
frequencies = [4; 10; 50; 100; 180; 300; 700; 1000; 1900];
figure(1)
for k=1:size(chans,1)
    for i=1:length(frequencies)
        subplot(ceil(sqrt(length(frequencies))),ceil(sqrt(length(frequencies))),i)
        lb=frequencies(i);
        hb=lb+1;
        if diag == 0;
            if onlyreal == 0;
                imagesc(tril(abs(squeeze(mean(aveCohYo(find(fo>lb & fo<hb),chans(k,:),chans(k,:)),1))),-1));
            else
                imagesc(tril(real(squeeze(mean(aveCohYo(find(fo>lb & fo<hb),chans(k,:),chans(k,:)),1))),-1));
            end
        else
            if onlyreal == 0;
                imagesc(abs(squeeze(mean(aveCohYo(find(fo>lb & fo<hb),chans(k,:),chans(k,:)),1))));
            else
                imagesc(real(squeeze(mean(aveCohYo(find(fo>lb & fo<hb),chans(k,:),chans(k,:)),1))));
            end
        end
        title([measure ': ' behavior ' files ' firstFile '-' lastFile ', ch ' num2str(chans(k,1)) '-' num2str(chans(k,end)) ', freq=' num2str(lb)],'fontsize',7);
        set(gca,'xtick',[1:length(chans(k,:))],'xticklabel',chans(k,:),'ytick',[1:length(chans(k,:))],'yticklabel',chans(k,:),'fontsize',5);
        colorbar;
    end
    if printBool
        print([measure '_' behavior num2str(chans(k,1)) '-' num2str(chans(k,end))], '-dpng', '-r125');
    end
end

%% for all shanks %%
chans = [1:96];
for k=1:size(chans,1)
    for i=1:length(frequencies)
        figure(i)
        clf
        lb=frequencies(i);
        hb=lb+1;
        if diag == 0;
            if onlyreal == 0;
                imagesc(tril(abs(squeeze(mean(aveCohYo(find(fo>lb & fo<hb),chans(k,:),chans(k,:)),1))),-1));
            else
                imagesc(tril(real(squeeze(mean(aveCohYo(find(fo>lb & fo<hb),chans(k,:),chans(k,:)),1))),-1));
            end
        else
            if onlyreal == 0;
                imagesc(abs(squeeze(mean(aveCohYo(find(fo>lb & fo<hb),chans(k,:),chans(k,:)),1))));
            else
                imagesc(real(squeeze(mean(aveCohYo(find(fo>lb & fo<hb),chans(k,:),chans(k,:)),1))));
            end
        end
        title([measure ': ' behavior ' files ' firstFile '-' lastFile ', ch ' num2str(chans(k,1)) '-' num2str(chans(k,end)) ', freq=' num2str(lb)],'fontsize',7);
        set(gca,'xtick',[1:2:length(chans(k,:))],'xticklabel',[1:2:length(chans(k,:))],'ytick',[1:2:length(chans(k,:))],'yticklabel',[1:2:length(chans(k,:))],'fontsize',4);
        colorbar;
        if printBool
            print([measure '_' behavior num2str(chans(k,1)) '-' num2str(chans(k,end)) '_' num2str(frequencies(i)) 'Hz'], '-dpng', '-r150');
        end
    end
end


    freqs = [4 10 50 100 180 300 700 1000 1900];


    if j==1
            freqs = [4 10 20 50 100 150 180 200 250];
    end
    if j==2
          freqs = [300 350 400 500 600 700 800 900 1000];
    end
    if j==3
        freqs = [1100 1200 1300 1400 1500 1600 1700 1800 1900];
    end  

        freqs = [4 50 100 180 250 350 500 700 1000];

    
    if j==1
        firstFile = '039';
        lastFile = '298';
        behavior = 'rem';
        aveCohYo = remaveCohYo;
    end
    if j==2
        firstFile = '015';
        lastFile = '298';
        behavior = 'sws';
        aveCohYo = swsaveCohYo;
    end
    if j==3
        firstFile = '015';
        lastFile = '298';
        behavior = 'sws';
        aveCohYo = swsremaveCohYo;
    end
    
    
    if j==1
        firstFile = '015';
        lastFile = '298';
        behavior = 'sws';
        aveCohYo = swsfullaveCohYo;
    end

    if j==2
        firstFile = '039';
        lastFile = '298';
        behavior = 'sws';
        aveCohYo = swsaveCohYo;
    end



    if j==1
        onlyreal = 1;
    end
    if j==2
        onlyreal = 0;
    end


load sws_coh_015-298.mat
swsfullaveCohYo = aveCohYo;

load sws_coh_039-298.mat
swsaveCohYo = aveCohYo;

load rem_coh_039-298.mat
remaveCohYo = aveCohYo;

swsremaveCohYo = (swsaveCohYo + remaveCohYo)./2;


imagesc(abs(squeeze(mean(aveCohYo(find(fo>150 & fo<200),:,:),1))));

