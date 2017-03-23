behavior = 'sws';
filebasemat = 'sm9608_015';
begintime = 0;
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

datsampl = 20000;
downsampl = 4000;
cohYomat = zeros(16,16,6);
yomat = zeros(16,16,6);
fomat = [];
for i = 1:length(filebasemat)
    for j=1:6
        channels = ((j-1)*16+1):(j*16);
        filename = [filebasemat(i,:) '.dat'];
        data = bload(filename, [97 10*datsampl], begintime(i)*datsampl*2,'short');
        data = resample(data', downsampl, datsampl);
        [yomat(:,:,j), fo] = mtcsd(data(:,channels),downsampl*2,downsampl,downsampl);
        %yomat(:,:,j) = yo;
        fomat = [fomat; fo];
        cohYomat(:,:,j) = Csd2Coherence(yomat(:,:,j));
        %save([filebasemat(i,:) '_' behavior '_coh.mat'], fo, yo, cohYo);
    end
end

imagesc(abs(squeeze(mean(cohYo(find(fo>150 & fo<200),:,:),1))));


