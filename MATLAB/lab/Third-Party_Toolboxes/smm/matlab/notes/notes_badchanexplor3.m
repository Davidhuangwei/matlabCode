animal = 'sm9603';

for j=1:2
    if j == 1
        behavior = 'sws';
        filebasemat = [];
        begintime = [];
        if strcmp(animal,'sm9603')
            filebasemat = [filebasemat; 'sm9603m2_012_s1_024'];
            begintime = [begintime; 3*60+50];
            filebasemat = [filebasemat; 'sm9603m2_021_s1_040'];
            begintime = [begintime; 0*60+14];
            filebasemat = [filebasemat; 'sm9603m2_039_s1_063'];
            begintime = [begintime; 0*60+32];
            filebasemat = [filebasemat; 'sm9603m2_068_s1_094'];
            begintime = [begintime; 0];
        end
        if strcmp(animal,'sm9608')
            if 0
                filebasemat = [filebasemat; 'sm9608_015'];
                begintime = [begintime; 0];
                filebasemat = [filebasemat; 'sm9608_018'];
                begintime = [begintime; 0];
                filebasemat = [filebasemat; 'sm9608_020'];
                begintime = [begintime; 0];
                filebasemat = [filebasemat; 'sm9608_022'];
                begintime = [begintime; 40];
                filebasemat = [filebasemat; 'sm9608_025'];
                begintime = [begintime; 0];
                filebasemat = [filebasemat; 'sm9608_033'];
                begintime = [begintime; 35];
            end
            filebasemat = [filebasemat; 'sm9608_039'];
            begintime = [begintime; 3*60+25];
            filebasemat = [filebasemat; 'sm9608_050'];
            begintime = [begintime; 0];
            filebasemat = [filebasemat; 'sm9608_052'];
            begintime = [begintime; 4*60+10];
            filebasemat = [filebasemat; 'sm9608_058'];
            begintime = [begintime; 40];
            filebasemat = [filebasemat; 'sm9608_070'];
            begintime = [begintime; 5];
            filebasemat = [filebasemat; 'sm9608_080'];
            begintime = [begintime; 5];
            filebasemat = [filebasemat; 'sm9608_085'];
            begintime = [begintime; 0];
            filebasemat = [filebasemat; 'sm9608_095'];
            begintime = [begintime; 0];
            filebasemat = [filebasemat; 'sm9608_115'];
            begintime = [begintime; 0];
            filebasemat = [filebasemat; 'sm9608_152'];
            begintime = [begintime; 3*60+30];
            filebasemat = [filebasemat; 'sm9608_165'];
            begintime = [begintime; 1*60+15];
            filebasemat = [filebasemat; 'sm9608_208'];
            begintime = [begintime; 0];
            filebasemat = [filebasemat; 'sm9608_253'];
            begintime = [begintime; 20];
            filebasemat = [filebasemat; 'sm9608_272'];
            begintime = [begintime; 35];
            filebasemat = [filebasemat; 'sm9608_298'];
            begintime = [begintime; 20];
        end
    end
    if j==2
        behavior = 'rem';
        filebasemat = [];
        begintime = [];
        if strcmp(animal,'sm9603')
            filebasemat = [filebasemat; 'sm9603m2_012_s1_024'];
            begintime = [begintime; 0];
            filebasemat = [filebasemat; 'sm9603m2_021_s1_040'];
            begintime = [begintime; 8*60+29];
            filebasemat = [filebasemat; 'sm9603m2_039_s1_063'];
            begintime = [begintime; 0];
            filebasemat = [filebasemat; 'sm9603m2_068_s1_094'];
            begintime = [begintime; 5*60+50];
        end
        if strcmp(animal,'sm9608')
            filebasemat = [filebasemat; 'sm9608_039'];
            begintime = [begintime; 0];
            filebasemat = [filebasemat; 'sm9608_050'];
            begintime = [begintime; 9*60];
            filebasemat = [filebasemat; 'sm9608_052'];
            begintime = [begintime; 15];
            filebasemat = [filebasemat; 'sm9608_058'];
            begintime = [begintime; 3*60+40];
            filebasemat = [filebasemat; 'sm9608_070'];
            begintime = [begintime; 45];
            filebasemat = [filebasemat; 'sm9608_080'];
            begintime = [begintime; 3*60];
            filebasemat = [filebasemat; 'sm9608_085'];
            begintime = [begintime; 1*60+15];
            filebasemat = [filebasemat; 'sm9608_095'];
            begintime = [begintime; 2*60+35];
            filebasemat = [filebasemat; 'sm9608_115'];
            begintime = [begintime; 1*60+15];
            filebasemat = [filebasemat; 'sm9608_165'];
            begintime = [begintime; 8*60+44];
            filebasemat = [filebasemat; 'sm9608_208'];
            begintime = [begintime; 3*60+45];
            filebasemat = [filebasemat; 'sm9608_253'];
            begintime = [begintime; 5*60+30];
            filebasemat = [filebasemat; 'sm9608_272'];
            begintime = [begintime; 2*60+35];
            filebasemat = [filebasemat; 'sm9608_298'];
            begintime = [begintime; 1*60+30];
        end
    end
    datsampl = 20000;
    downsampl = 4000;
    channels = [1:96];
    
    if strcmp(animal,'sm9608')
        firstfile = filebasemat(1,8:10);
        lastfile = filebasemat(end,8:10);
    end
    if strcmp(animal,'sm9603')
        firstfile = filebasemat(1,10:12);
        lastfile = filebasemat(end,10:12);
    end
    % calculate the coherence
    for i = 1:size(filebasemat,1)
        filename = [filebasemat(i,:) '.dat'];
        data = bload(filename, [97 10*datsampl], begintime(i)*datsampl*2*97,'int16');
        data = resample(data', downsampl, datsampl);
        [yo, fo] = mtcsd(data(:,channels),2^12,downsampl,2^11,[],1);
        clear data;
        cohYo = Csd2Coherence(yo);
        save([filebasemat(i,:) '_' behavior '_coh.mat'], 'fo','cohYo');
        clear cohYo;
        save([filebasemat(i,:) '_' behavior '_csd.mat'], 'fo', 'yo');
        clear yo;
        clear fo;
    end
    % calculate the power difference
    for i = 1:size(filebasemat,1)
        filename = [filebasemat(i,:) '.dat'];
        data = bload(filename, [97 10*datsampl], begintime(i)*datsampl*2*97,'int16');
        data = resample(data', downsampl, datsampl);
        [yo, fo, ch] = mtcsglong_sm(data(:,channels),2^12,downsampl,2^11,[],1);
        powDiff = zeros(length(fo),96,96);
        for m = 1:96
            for n = 1:96
               powDiff(:,m,n) = squeeze(mean(1-(((yo(:,:,m)-yo(:,:,n))./(yo(:,:,m)+yo(:,:,n))).^2).^(1/2),1));
            end
        end
        clear yo;
        save([filebasemat(i,:) '_' behavior '_powDiff.mat'], 'fo','powDiff');
        clear powDiff;
    end
% average across depths in the brain
    for i = 1:size(filebasemat,1)
        filename = [filebasemat(i,:) '_' behavior '_coh.mat'];
        load(filename);
        if ~exist('avecohYo','var')
            avecohYo = zeros(size(cohYo));
        end
        cohYo = cohYo./length(filebasemat);
        avecohYo = avecohYo + cohYo;
        avecohYo(1,1,1)
        clear cohYo;
    end
    save([behavior '_coh_' firstfile '-' lastfile '.mat'], 'fo', 'avecohYo')
    clear avecohYo;
    
    for i = 1:size(filebasemat,1)
        filename = [filebasemat(i,:) '_' behavior '_csd.mat'];
        load(filename);
        if ~exist('aveYo','var')
            aveYo = zeros(size(yo));
        end
        yo = yo./length(filebasemat);
        aveYo = aveYo + yo;
        aveYo(1,1,1)
        clear yo;
    end
    save([behavior '_csd_' firstfile '-' lastfile '.mat'], 'fo', 'aveYo')
    clear aveYo;
    
    for i = 1:size(filebasemat,1)
        filename = [filebasemat(i,:) '_' behavior '_powDiff.mat'];
        load(filename);
        if ~exist('avePowDiff','var')
            avePowDiff = zeros(size(powDiff));
        end
        powDiff = powDiff./length(filebasemat);
        avePowDiff = avePowDiff + powDiff;
        avePowDiff(1,1,1)
        clear powDiff;
    end
    save([behavior '_powDiff_' firstfile '-' lastfile '.mat'], 'fo', 'avePowDiff')
    clear avePowDiff;

    
end


behavior = 'sws+rem';
measure = 'powDiff'

if strcmp(behavior,'sws') 
    load(['sws_coh_' firstfile '-' lastfile '.mat']);
    %swsfullavecohYo = avecohYo;
end
if strcmp(behavior,'rem') 
    load(['rem_coh_' firstfile '-' lastfile '.mat']);
    %remavecohYo = avecohYo;
end
if strcmp(behavior,'sws+rem')
    load(['sws_coh_' firstfile '-' lastfile '.mat']);
    swsavecohYo = avecohYo;
    load(['rem_coh_' firstfile '-' lastfile '.mat']);
    remavecohYo = avecohYo;
    avecohYo = (swsavecohYo + remavecohYo)./2;
end

if strcmp(behavior,'sws+rem')
    load(['sws_powDiff_' firstfile '-' lastfile '.mat']);
    swsavePowDiff = avePowDiff;
    load(['rem_powDiff_' firstfile '-' lastfile '.mat']);
    remavePowDiff = avePowDiff;
    avecohYo = (remavePowDiff + swsavePowDiff)./2;
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
                imagesc(tril(abs(squeeze(mean(avecohYo(find(fo>lb & fo<hb),chans(k,:),chans(k,:)),1))),-1));
            else
                imagesc(tril(real(squeeze(mean(avecohYo(find(fo>lb & fo<hb),chans(k,:),chans(k,:)),1))),-1));
            end
        else
            if onlyreal == 0;
                imagesc(abs(squeeze(mean(avecohYo(find(fo>lb & fo<hb),chans(k,:),chans(k,:)),1))));
            else
                imagesc(real(squeeze(mean(avecohYo(find(fo>lb & fo<hb),chans(k,:),chans(k,:)),1))));
            end
        end
        title([measure ': ' behavior ' files ' firstfile '-' lastfile ', ch ' num2str(chans(k,1)) '-' num2str(chans(k,end)) ', freq=' num2str(lb)],'fontsize',7);
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
                imagesc(tril(abs(squeeze(mean(avecohYo(find(fo>lb & fo<hb),chans(k,:),chans(k,:)),1))),-1));
            else
                imagesc(tril(real(squeeze(mean(avecohYo(find(fo>lb & fo<hb),chans(k,:),chans(k,:)),1))),-1));
            end
        else
            if onlyreal == 0;
                imagesc(abs(squeeze(mean(avecohYo(find(fo>lb & fo<hb),chans(k,:),chans(k,:)),1))));
            else
                imagesc(real(squeeze(mean(avecohYo(find(fo>lb & fo<hb),chans(k,:),chans(k,:)),1))));
            end
        end
        title([measure ': ' behavior ' files ' firstfile '-' lastfile ', ch ' num2str(chans(k,1)) '-' num2str(chans(k,end)) ', freq=' num2str(lb)],'fontsize',7);
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
        firstfile = '039';
        lastfile = '298';
        behavior = 'rem';
        avecohYo = remavecohYo;
    end
    if j==2
        firstfile = '015';
        lastfile = '298';
        behavior = 'sws';
        avecohYo = swsavecohYo;
    end
    if j==3
        firstfile = '015';
        lastfile = '298';
        behavior = 'sws';
        avecohYo = swsremavecohYo;
    end
    
    
    if j==1
        firstfile = '015';
        lastfile = '298';
        behavior = 'sws';
        avecohYo = swsfullavecohYo;
    end

    if j==2
        firstfile = '039';
        lastfile = '298';
        behavior = 'sws';
        avecohYo = swsavecohYo;
    end



    if j==1
        onlyreal = 1;
    end
    if j==2
        onlyreal = 0;
    end


load sws_coh_015-298.mat
swsfullavecohYo = avecohYo;

load sws_coh_039-298.mat
swsavecohYo = avecohYo;

load rem_coh_039-298.mat
remavecohYo = avecohYo;

swsremavecohYo = (swsavecohYo + remavecohYo)./2;


imagesc(abs(squeeze(mean(avecohYo(find(fo>150 & fo<200),:,:),1))));

