% [Res, Clu, Whl, ThPh, f] = FakeDataLinear(TotTime, nCells, MaxRate, MaxK, Width, Spacing, PhaseWidth,kWidth);
% makes a simulated linear track data set based on a Poisson x Von Mises model
% at a sample rate of 20 kHz
% f(t,c) is an array giving instantaneous intensity for each cell, at eeg sampling rate.
%
% input TotTime in seconds.
% nCells number of cells to produce
% MaxRate peak firing rate in place field center
% MaxK value of k (von mises concentration) at place field start (it decays to 0)
% Width place field width (Environment size is 256)
% Spacing - distance between PFs (they are regular)

function [Res, Clu, Whl, ThPh, fOut] = FakeDataLinear(TotTime, nCells, MaxRate, MaxK, Width, Spacing, PhaseWidth,kWidth)

if nargin<1
	TotTime = 600; 
end
if nargin<2
    nCells = 2;
end
if nargin<3
    MaxRate = 20;
end
if nargin<4
    MaxK = 2;
end
if nargin<5
    Width = 20;
end
if nargin<6
    Spacing = 20;
end
if nargin<7
    PhaseWidth = Width;
end
if nargin<8
    kWidth = Width;
end
    
% MAKE EEG as pure sine wave plus jitter

nEeg = TotTime*1250;
JitAmp = 0/1250;
ThPh = 2*pi*(1:nEeg)'*8/1250 + filter(hamming(10),[1 -1],randn(nEeg,1)*JitAmp);

% NOW MAKE SIMULATED TRAJECTORY
% unidirectional, 0.25 m/s
EnvSize=256; Speed = .25;
Pos = mod((1:nEeg)*EnvSize*Speed/1250, EnvSize)';
Whl = Pos(1:32:end,:);
Whl = [Whl, ones(size(Whl))*EnvSize/2];

ResU = []; CluU = [];
for c=1:nCells
    % place field of width 20 cm
%    PFCenter = rand(1)*EnvSize;
    PFCenter = EnvSize/2 - (c-1)*Spacing;
    Rate = MaxRate * exp(-(Pos-PFCenter).^2/Width.^2/2);
    MeanPh = pi+atan((PFCenter-Pos)/PhaseWidth);
    k = MaxK./(1+exp((Pos-PFCenter)/kWidth));
	
 	% MAKE FIRING RATE FUNCTION
    f = Rate .* VonMisesPdf(ThPh,MeanPh,k)*2*pi;
    fOut(:,c) = f;

    % NOW SIMULATE A SPIKE TRAIN
	nSpikes = poissrnd(f(:)*16/20000);
	% Need to "reverse accumulate" array
	Res0 = [];
	for n=1:max(nSpikes)
		Res0 = [Res0 ; find(nSpikes>=n)];
	end
    
    ResU = [ResU; Res0];
    CluU = [CluU; (c+1)*ones(size(Res0))];
end

[Res ind] = sort(ceil((ResU+rand(size(ResU)))*16));
Clu = CluU(ind);

return
% to plot it ...
MyRes = Res(find(Clu==2));
plot(Whl(1+floor(MyRes/512)), mod(ThPh(1+floor(MyRes/16)),2*pi), '.');
