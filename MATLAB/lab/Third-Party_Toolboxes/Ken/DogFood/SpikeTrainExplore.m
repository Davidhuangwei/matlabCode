% SpikeTrainExplore(Res, SampleRate, Epochs, Options)
%
% plots various graphs pertaining to a spike train
%
% Epochs = time chunks within which spikes might have
% been collected (used for restricting to REM etc, also
% for calculating firing rates.
%
% if arg 1 is {Res,Clu}, it will loop thru all cells
% if it's {Res,Clu,CellNos} it will loop thru specified cells
% if it's {FileBase} it will load that.
% if it's {FileBase, CluNos} .. u get the idea
%
% also returns an array of statistics.
%
% Options can be 'nopause' in which case ... it won't pause.

function stats = SpikeTrainExplore(aRes, fs, Epochs,Options)

if nargin<2
    fs = 20000;
    warning('Using 20kHz sample rate');
end

if nargin<3
    Epochs = [];
end

if nargin<4
    Options='';
end


if iscell(aRes)
    if isstr(aRes{1})
        Res = load([aRes{1} '.res']);
        Clu = LoadClu([aRes{1} '.clu']);
        if length(aRes)>1
            ToDo = aRes{2};
        else 
            ToDo = 2:max(Clu);
        end
    else
        Res = aRes{1};
        Clu = aRes{2};
        
        if length(aRes)>=3
            ToDo = aRes{3};
        else
            ToDo = 2:max(Clu);
        end
    end
    for c=ToDo(:)'
        MyRes = Res(find(Clu==c));
        fprintf('Cell %d: firing rate %f\n', c, fs*length(MyRes)/(max(Res)-min(Res)));
        out = SpikeTrainExplore(Res(find(Clu==c)),fs,Epochs,Options);
        if ~isempty(out)
            stats(c) = out;
            fprintf('Press return.\n');
            if ~strcmp(Options, 'nopause')
                pause
            end
        end
    end
    return;
end


if isempty(Epochs)
    Epochs = [0 max(aRes)];
end


BinSizems = 15; % CCG bin size in ms
BurstThresh = 25; % in ms
CCGTotWidth = 0.5; % in seconds
PsdBinSize = 1;
ReturnMapSize = 500; % in ms
CCGExpand = 10; % show on an expanded and contracted scale by this factor
RateViewTime = 2; % in seconds
MinSpikes = 50;

% tMax = mRes/fs;
TotTime = sum(diff(Epochs,[],2))/fs; % in seconds

aWhichEpoch = WithinRanges(aRes,Epochs,1:size(Epochs,1),'vector');
Res = aRes(find(aWhichEpoch));
WhichEpoch = aWhichEpoch(find(aWhichEpoch));

if length(Res)<MinSpikes
    fprintf('Not enough Spikes!\n');
    stats = [];
    return;
end

CCGBinSize = fs*BinSizems/1000; % bin size in sample units

[ccg t pairs] = CCG(Res,2,CCGBinSize,floor(fs*CCGTotWidth*0.999/CCGBinSize),fs, 2, 'scale', Epochs);
 
nSpk = length(Res);

% compute ISIs - only for pairs within a single Epoch
GoodPairs = find(diff(WhichEpoch)==0);
dRes = diff(Res)/fs*1000; % in ms
isi = dRes(GoodPairs); % ISI in ms
fRate = length(Res)/TotTime;

% return map
figure(1)
set(gcf, 'position', [5   703   318   249]);
plot(isi(1:length(isi)-1),isi(2:end), '.', 'markersize', 1);
axis([0 ReturnMapSize 0 ReturnMapSize]);
xlabel('isi 1 (ms)');
ylabel('isi 2 (ms)');
title('return map');
h = msline(100,'r');
drawnow

figure(2); clf
set(gcf, 'position', [ 5   336   678   286]);
subplot(2,1,1); hold on
Myt = find(t>=0);
MyACG = ccg(Myt);
bar(t(Myt),MyACG);
xlim([0 max(t(Myt))]);
grid on
xlabel('time (ms)');
ylabel('ACG');   
% interpolate
intt = 0:500;
intACG = interp1(t(Myt), MyACG, intt, 'spline');
h1 = plot(intt, intACG, 'b');

% ACG error bars:
eb = sqrt(TotTime*fs/(nSpk^2*CCGBinSize));
h2 = plot(xlim, [1 1], 'r', xlim, [1 1]+eb, 'r:', xlim, [1 1]-eb, 'r:');    

% renewal predicted ACG
[predacg tpred] = ISI2ACG(isi,4,128);
%     intr = 0:.1:tall(Myt(end));
%     plot(intr, interp1(tpred, predacg/fRate, intr, 'spline'), 'g');
good = find(tpred<1000);
h3 = plot(tpred(good), predacg(good)/fRate, 'g.-');
drawnow

%     legend([h1(1) h2(1) h3(1)], 'interpolated', 'constant', 'renewal prediction');

% psd
subplot(2,1,2)
fr = 2:.5:50;
[p psdmu psdsd] = PointPsd(Res/fs, fr,PsdBinSize, Epochs/fs);
hold off; bar(fr,p/psdmu);
xlabel('f (Hz)')
ylabel('spike train psd');
xlim([0 max(fr)]);
hold on; plot(xlim, [1 1], 'r', xlim, [1 1]+psdsd/psdmu, 'r:', xlim, [1 1]-psdsd/psdmu, 'r:');
grid on
drawnow

% ISI histo
nbi = isi(find(isi>BurstThresh)); % non-bursts ISIs
figure(3)
set(gcf, 'position', [ 5    55   676   198]);
% fit a log-normal distribution
[mu sig] = normfit(log(nbi));
% fit exponential distribution
dx = 2;
xr = 0:dx:ceil(max(isi));
subplot(2,1,1)
% linear scale
hold off; hist(isi,xr);
hold on; plot(xr, length(isi)*lognpdf(xr,mu,sig)*dx, 'r');
xlim([0 1000]);        
xlabel('ISI (ms)');
ylabel('count');
subplot(2,1,2)
% log scale
dlx = 0.02;
lxr = dlx:dlx:log(max(isi));
hold off; hist(log(isi)/log(10),lxr);
hold on; plot(lxr/log(10), length(isi)*normpdf(lxr,mu,sig)*dlx*log(10), 'r');
%     plot(lxr/log(10), length(isi)*exppdf(lxr,expmu)*dlx*log(10), 'g');
 xlim([0 4]);
if 0
    xlab = [1:9 10:10:90 100:100:900 1000:1000:10000];
    set(gca, 'xtick', log10(xlab));
    Eight = {'','','','','','','',''};
    set(gca, 'xticklabel', {'1', Eight{:}, '10', Eight{:}, '10^2', Eight{:}, '10^3', Eight{:}, '10^4'});
else
    LogTicks('x', 10);
end
grid on;
xlabel('ISI (ms)')

drawnow

% fano factors
figure(4)
set(gcf, 'position', [331   704   414   248]);
br = 25.*(2.^[0:.5:16]); % bin sizes
ff = FanoFactor(Res,br,Epochs);
loglog(br/25,ff, '.-')
xlabel('Bin size (ms');
ylabel('Fano Factor');
ylim([.1 10]); grid on

% ACGs at various scales
figure(5)
set(gcf, 'position', [752   704   541   248]);
subplot(1,2,1)
[ccg1 t1] = CCG(Res,2,CCGBinSize/CCGExpand,floor(fs*CCGTotWidth*0.999/CCGBinSize),fs, 2, 'scale', Epochs);
bar(t1,ccg1)
xlabel('ms'); ylabel('ACG')
axis tight
if 1
subplot(1,2,2)
[ccg2 t2] = CCG(Res,2,CCGBinSize,floor(fs*CCGTotWidth*0.999/CCGBinSize),fs, 2, 'scale', Epochs);
bar(t2/1000,ccg2);
axis tight
xlabel('s'); ylabel('ACG')
end
fprintf('log skew %f log kurt %f ', skewness(log10(isi)), kurtosis(log10(isi)));
fprintf('ISI CoV %f\n', std(isi)/mean(isi));
drawnow

% firing rate thru time, 1s intervals
figure(6) 
set(gcf, 'position', [689   406   591   217]);
[Starts Bin] = FitEvenlySpacedBins(RateViewTime,Epochs/fs,Res/fs);
hold off
Cnt = Accumulate(Bin(find(Bin>0)),1,length(Starts));
bar(Starts,Cnt/RateViewTime);
hold on
plot(Starts,0,'r.');
xlim([min(Starts) max(Starts)]);
fRate = sum(Bin>0)/length(Starts)/RateViewTime;
plot(xlim, [1 1]*fRate, 'g');
xlabel('time');
ylabel('firing rate');

% make stats
stats.fRate = fRate;
stats.MedISI = median(isi);
stats.Frac6 = sum(isi<=6)/nSpk;
stats.Frac25 = sum(isi<=25)/nSpk;
stats.MeanISI = mean(nbi);
stats.StdISI = std(nbi);
stats.CovISI = std(nbi)/mean(nbi);
stats.MeanLogISI = mean(log10(nbi));
stats.StdLogISI = std(log10(nbi));
stats.SkewLogISI = skewness(log10(nbi));
stats.KurtLogISI = kurtosis(log10(nbi));    
stats.TimeTo1 = intt(min(find(intACG>1)));
Peaks = LocalMinima(-intACG,3,-1-eb*norminv(.95));
MyPeak = Peaks(min(find(intt(Peaks)>25)));
if isempty(MyPeak)
    stats.FirstPeak = 0;
    stats.PeakHeight = 1;
    stats.zPeak = 0;
else
    stats.FirstPeak = intt(MyPeak);
    stats.PeakHeight = intACG(MyPeak);
    stats.zPeak = (intACG(MyPeak)-1)/eb;
end
stats.ACG1s = MyACG(end);    
stats.ACGSum25 = sum(MyACG(find(t(Myt)<=25)));
stats.ACGSum100 = sum(MyACG(find(t(Myt)<=100)));
stats.ACGSum250 = sum(MyACG(find(t(Myt)<=250)));
stats.ACGSum500 = sum(MyACG(find(t(Myt)<=500)));
[stats.FFMin FFMinPos] = min(ff);
stats.FFMint = br(FFMinPos)/25;
stats.FF10s = ff(end);
[stats.PsdMax pf] = max(p/psdmu);
stats.Freq = fr(pf);
stats.zPsd = psdmu*(stats.PsdMax - 1)/psdsd;
