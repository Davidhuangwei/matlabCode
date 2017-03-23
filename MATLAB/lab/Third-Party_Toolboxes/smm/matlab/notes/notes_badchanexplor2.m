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
    
    for i = 1:length(filebasemat)
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

    for i = 1:length(filebasemat)
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
    save([behavior '_coh_' filebasemat(1,8:10) '-' filebasemat(end,8:10) '.mat'], 'fo', 'avecohYo')
    clear avecohYo;
end


imagesc(abs(squeeze(mean(avecohYo(find(fo>150 & fo<200),:,:),1))));

behavior = 'sws+rem';

if strcmp(animal,'sm9608')
    firstfile = filebasemat(1,8:10);
    lastfile = filebasemat(end,8:10);
end
if strcmp(animal,'sm9603')
    firstfile = filebasemat(1,10:12);
    lastfile = filebasemat(end,10:12);
end

if strcmp(behavior,'sws') 
    load(['sws_coh_' num2str(firstfile) '-' num2str(lastfile) '.mat']);
    swsfullavecohYo = avecohYo;
end
if strcmp(behavior,'rem') 
    load(['rem_coh_' num2str(firstfile) '-' num2str(lastfile) '.mat']);
    remavecohYo = avecohYo;
end
if strcmp(behavior,'sws+rem')
    load(['sws_coh_' num2str(firstfile) '-' num2str(lastfile) '.mat']);
    swsfullavecohYo = avecohYo;
    load(['rem_coh_' num2str(firstfile) '-' num2str(lastfile) '.mat']);
    remavecohYo = avecohYo;
    avecohYo = (swsavecohYo + remavecohYo)./2;
end

onlyreal = 0;
diag = 1;
chans = [1:16];
chans = [17:32];
chans = [33:48];
chans = [49:64];
chans = [65:80];
chans = [81:96];
%freqs = [4; 10; 50; 100; 180; 300; 700; 1000; 1900];
for j=1:length(freqs)
    
    if j==1
        freqs = [4];
    end
    if j==2
        freqs = [10];
    end
    if j==3
        freqs = [50];
    end
    if j==4
        freqs = [100];
    end
    if j==5
        freqs = [180];
    end
    if j==6
        freqs = [300];
    end
    if j==7
        freqs = [700];
    end
    if j==8
        freqs = [1000];
    end
    if j==9
        freqs = [1900];
    end
    figure(j)
    for i=1:length(freqs)
        subplot(ceil(sqrt(length(freqs))),ceil(sqrt(length(freqs))),i)
        lb=freqs(i);
        hb=lb+1;
        if diag == 0;
            if onlyreal == 0;
                imagesc(tril(abs(squeeze(mean(avecohYo(find(fo>lb & fo<hb),chans,chans),1))),-1));
            else
                imagesc(tril(real(squeeze(mean(avecohYo(find(fo>lb & fo<hb),chans,chans),1))),-1));
            end
        else
            if onlyreal == 0;
                imagesc(abs(squeeze(mean(avecohYo(find(fo>lb & fo<hb),chans,chans),1))));
            else
                imagesc(real(squeeze(mean(avecohYo(find(fo>lb & fo<hb),chans,chans),1))));
            end
        end
        title(['coh: ' behavior ' files ' firstfile '-' lastfile ', chs ' num2str(chans(1)) '-' num2str(chans(end)) ', freq=' num2str(lb)],'fontsize',7);
        set(gca,'xtick',[1:length(chans)],'xticklabel',chans,'ytick',[1:length(chans)],'yticklabel',chans,'fontsize',7);
        colorbar;
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
