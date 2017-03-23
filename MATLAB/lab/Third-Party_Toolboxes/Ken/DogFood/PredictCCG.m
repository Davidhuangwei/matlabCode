% [CCG t] = PredictCCG(Res, Clu, Whl, WhichClu)
%
% predicts what the CCGs should be for cells from their
% place fields.  See also CCG - and use it if you want to
% calculate CCGs. Don't use this.
%
% assumes sample rate of 20kHz, etc.
%
% bin size for ccg is .eeg unit: 16 samples
%
% ThPh should be passed in eeg file units (16 samples)
% if it's empty, phase shift won't be used

function [CCG, t] = PredictCCG(Res, Clu, Whl, ThPh, WhichClu, MaxLags)

if nargin<4
    ThPh=[];
end
if nargin<5
    WhichClu = 2:max(Clu);
end
if nargin<6
    MaxLags = 200;
end

EnvSize = 350;
Smooth = 10;
nGrid = 64;
nClu = length(WhichClu);

% compute integer position, where you can
IsGood = Whl(:,1)>=0;
Good = find(IsGood);
iPosGood = 1+floor(nGrid*Whl(Good,1:2)/(EnvSize+eps));
nWhl = size(Whl,1);

% make place fields and predicted firing rates.

if ~isempty(ThPh)
    % make upsampled .whl file to .eeg timebase
    WhlU(:,1) = reshape(repmat(Whl(:,1),1,32)', [size(Whl,1)*32 1]);
    WhlU(:,2) = reshape(repmat(Whl(:,2),1,32)', [size(Whl,1)*32 1]);    
end
nU = min(size(WhlU,1),length(ThPh));
IsGoodU = WhlU(1:nU,1)>=0;
GoodU = find(IsGoodU);
PosGoodU = WhlU(GoodU,1:2)/(EnvSize+eps);
iPosGoodU = 1+floor(PosGoodU*nGrid);

Smooth = .01*[1 1];
for c=1:nClu
    figure(c)
	MyRes = Res(find(Clu==WhichClu(c)));

	PredFR{c} = zeros(nU,1);
    if isempty(ThPh)
        PF{c} = NuPlaceField(MyRes, Whl, EnvSize, Smooth, nGrid);
    	PredFR{c}(Good) = PF{c}(sub2ind([nGrid nGrid], iPosGood(:,1), iPosGood(:,2)));
    else
        SpkCnt = Accumulate(1+floor(MyRes/16),1,nU);
        [PF{c}, dummy, Phf{c}, kf{c}]  = PPhF(PosGoodU, ThPh(GoodU), SpkCnt(GoodU,:), Smooth, nGrid, [1e-12 1]);
        MyPF = PF{c}(sub2ind([nGrid nGrid], iPosGoodU(:,1), iPosGoodU(:,2)));
        MyPh = Phf{c}(sub2ind([nGrid nGrid], iPosGoodU(:,1), iPosGoodU(:,2)));
        Myk = kf{c}(sub2ind([nGrid nGrid], iPosGoodU(:,1), iPosGoodU(:,2)));
        PredFR{c}(GoodU) = MyPF .* VonMisesPdf(ThPh(GoodU), MyPh, Myk)*2*pi;
    end

%     imagesc(PF{c}); colorbar; pause;
end

% compute total number of good lags
dt = 16/20000;
Denom = Sxcorr(IsGoodU, IsGoodU, MaxLags);
t = (-MaxLags:MaxLags)*.8; % in ms, given that eeg samp rate is .8ms.

% now compute ccgs
figure(1+nClu)
for c1 = 1:nClu
	for c2=c1:nClu
		CCG(:,c2,c1) = Sxcorr(PredFR{c1}, PredFR{c2}, MaxLags)./Denom/dt^2;
		CCG(:,c1,c2) = flipud(CCG(:,c2,c1));
	end
end