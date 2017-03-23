% [Res, Clu, Whl] = FakeData(TotTime, nCells);
% makes a simulated data set based on a Poisson x Von Mises model
% at a sample rate of 20 kHz
%
% input TotTime in seconds.

function [Res, Clu, Whl] = FakeData(TotTime, nCells)

%if nargin<1
%	TotTime = 600;
%end

% MAKE SIMULATED EEG

% Noise component
nEeg = TotTime*1250;
% Noise = filter(1,[1 -.97], randn(nEeg,1));
% 
% % Theta component of variable frequency
% InterpPoints = 1:625:nEeg+1250;
% InstFreq = interp1(InterpPoints, (6+4*rand(size(InterpPoints)))/1250, 1:nEeg)';
% InstPh = 2*pi*cumsum(InstFreq);
% ThetaOsc = cos(InstPh);
% 
% % sum, multiply, and round
% Eeg = round(Noise*1e4 + ThetaOsc*5e4);

% NOW MAKE SIMULATED TRAJECTORY
EnvSize=256;
% its a random walk
dPos = normrnd(0,1e-3,nEeg,2);
uPos = filter(1,conv([1 -1],[1 -.999]), dPos);
%Reflection boundary conditions
Pos = ceil(abs(mod(uPos,EnvSize*2)-EnvSize));
Whl = Pos(1:32:end,:);

ResU = []; CluU = [];
for c=1:nCells
	% SIMULATED PLACE FIELD
	Cloud = Cloudz(EnvSize*2,1,4);
	PlaceMap = Cloud(1:EnvSize,1:EnvSize);
	PlaceMap = 3*PlaceMap/mean(PlaceMap(:));
%  	imagesc(PlaceMap); colorbar;
	
% 	% MAKE FIRING RATE FUNCTION
% 	k = .5; % von mises concentration parameter
% 	Phi0 = -pi/2; %phase is concentrated on rising phase.
% 	fPos = PlaceMap(sub2ind([EnvSize EnvSize], Pos(:,1), Pos(:,2)));
% 	fPhase = exp(k*cos(InstPh-Phi0))/besseli(0,k);
% 	f = fPos .* fPhase;
    f = PlaceMap(sub2ind([EnvSize EnvSize], Pos(:,1), Pos(:,2)));

	% NOW SIMULATE A SPIKE TRAIN
	nSpikes = poissrnd(f*16/20000);
	% Need to accumulate array
	Res0 = [];
	for n=1:max(nSpikes)
		Res0 = [Res0 ; find(nSpikes>=n)];
	end
    
    ResU = [ResU; Res0];
    CluU = [CluU; (c+1)*ones(size(Res0))];
end

[Res ind] = sort(ceil((ResU+rand(size(ResU)))*16));
Clu = CluU(ind);