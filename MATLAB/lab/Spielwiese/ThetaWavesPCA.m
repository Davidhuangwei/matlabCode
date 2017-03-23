% function y = ThetaWavePCA(FileBase,Waves)
%
% -clusters waveshaps using PCA
% -opens 'Klusters' 
%
% FileBase:    e.g 'sm9608_490';
% Waves:       Matrix [nFet x Trials x Channels]
% nFet:        number of datapoints per theta wave (e.g. 32)
% Trials:      number of waves per channel (e.g. 800)
% Channels:    number of channels
% nPCA:        number of principal components (e.g. 3) 
%
% (c) Caroline Geisler  12/2004
%
%
% usage example: ThetaWavesPCA('sm9603m2_209_s1_252',Waves,3,[],34)
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
function ThetaWavesPCA(FileBase, Waves, nPCA, varargin)

[EegFs, nFet] =  DefaultArgs(varargin, {1250, 32});

%FileBase = 'sm9603m2_209_s1_252';
%EEegFs=1250;
%nFet=32;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Dim = size(Waves,1);
Trial = size(Waves,2);
Channels = size(Waves,3);

% matrix into two dim: dimxtrial
y=reshape(permute(Waves,[1 3 2]),Dim*Channels,[]);

% covariant matrix
[u,s,v] = svd(y',0); 

%clear RSegW;
%sv=diag(s); sv = sv./sum(sv);
%EigVal(:) = sv;
%EigVec = v;

AllFet(:,:) =u(:,1:nPCA);
AllFet = round(AllFet*2^15/max(abs(AllFet(:))));

clu = KlustaKwik(AllFet,5);

for i=1:Channels;
  FFet(:,:,i) =u(:,1:nPCA);
end

Kluster([FileBase '.wav'],{FFet,round(2^14*permute(Waves(:,:,:),[3,1,2])), [1:Trial]',clu},'klusters',EegFs);

return
