function FST = FStats(Perigr,f,Tapers,varargin)
[PLOT,WinLength,p,goodf] = DefaultArgs(varargin,{0,[],0.05,[4 12]});
%% 
%% computing F-Statistics
%% following Chronux Toolbox mtpowerandfstatc.m and ftestc.m
%% 
%% t :   # time bins
%% f :   # frequency bins
%% K :   # tapers
%% nCh : # channels
%% nS :  # chunks
%%
%% input: 
%%    Perigr: periodogram [t x K x nCh x nS] of odd tapers
%%    Tapers: tapers [t x K]
%%         f: frequency

% PP : f x K x nCh x nS
% H0 : f x K x nCh x nS (sum across t)  

nFreqBins = length(f);
K = size(Tapers,2);
nChannelsAll = size(Perigr,3);
nFFTChunks = size(Perigr,4);

H0 = repmat(sum(Tapers(:,1:2:end)),[nFreqBins,1,nChannelsAll,nFFTChunks]); 

% compute K x nS
Kp = size(Perigr,2);

% P : f x C - this is the power
P = squeeze(sum(Perigr.*conj(Perigr),2))/Kp;

% devide in odd and even
PP = Perigr(:,1:2:end,:,:);
PPeven = Perigr(:,2:2:end,:,:);

Kp1 = size(PP,2);
Kp2 = size(PP,4);

% H0sp : f x nCh 
H0sq=sum(H0.*H0,2); % sum of squares of H0^2 across taper and segment indices

% JpH0 : f x nCh
JpH0=sum(PP.*H0,2); % sum of the product of PP and H0 across taper and segment indices

% A : f x nCh 
A=squeeze(JpH0./H0sq); % amplitudes for all frequencies and channels

% A : f x K x nCh x nS
Ap=permute(repmat(A,[1,1,1,Kp1]),[1 4 2 3]); % add the taper index to C

% fitted value for the fft
% Jhat : f x K x nCh x nS
Jhat=Ap.*sq(H0); 

num = (K-1).*(abs(A).^2).*squeeze(H0sq); % numerator for F-statistic
den = squeeze(sum(abs(sq(PP)-Jhat).^2,2))+sq(sum(abs(PPeven).^2,2)); % denominator for F-statistic
fstat=(num./den); % F-statisitic

Mfstat = nanmean(fstat,length(size(fstat))); 

Spect = nanmean(P,length(size(fstat)));

% significance
sig = finv(1-p,2,2*Kp-2); 
var = den./(Kp*squeeze(H0sq));
sd = sqrt(var);

Msd = nanmean(sd,3);


%%%%%%%%%%%
FST = Mfstat;
%%%%%%%%%%%






if PLOT
 
  figure(753);clf
  %
  subplot(221)
  plot(f,10*log(Spect(:,1)))
  subplot(222)
  plot(f,10*log(Spect(:,2)))
  %
  subplot(223)
  plot(f,Mfstat(:,1))
  Lines([],sig)
  subplot(224)
  plot(f,Mfstat(:,2))
  Lines([],sig)

end



return;







J=squeeze(sum(fourier.*data_proj))/Fs; 

Kodd=1:2:K;
Keven=2:2:K;
tapers=tapers(:,:,ones(1,C)); % add channel indices to the tapers - t x K x C
H0 = squeeze(sum(tapers(:,Kodd,:),1)); % calculate sum of tapers for even prolates - K x C

if C==1; H0=H0'; J=J'; end;
P=squeeze(mean(J.*conj(J),1));
Jp=J(Kodd,:); % drop the even ffts
H0sq=sum(H0.*H0,1); % sum of squares of H0^2 across taper indices - dimensions C
JpH0=sum(Jp.*H0,1); % sum of the product of Jp and H0 across taper indices - f x C\
A=squeeze(JpH0./H0sq); % amplitudes for all frequencies and channels
Kp=size(Jp,1); % number of even prolates
Ap=A(ones(1,Kp),:); % add the taper index to C
Jhat=Ap.*H0; % fitted value for the fft
 
num=(K-1).*(abs(A).^2).*squeeze(H0sq); % numerator for F-statistic
den=squeeze(sum(abs(Jp-Jhat).^2,1)+sum(abs(J(Keven,:)).^2,1)); % denominator for F-statistic
Fstat=num./den; % F-statisitic












H0 = repmat(sum(Tapers(:,1:2:end)),[nFreqBins,1,nChannelsAll,nFFTChunks]); 

% compute K x nS
Kp=size(PP,2)*size(PP,4); 
Kp1 = size(PP,2);
Kp2 = size(PP,4);

% P : f x C - this is the power 
P = squeeze(sum(sum(PP.*conj(PP),2),4))/Kp;

% H0sp : f x nCh
H0sq=sum(sum(H0.*H0,2),4); % sum of squares of H0^2 across taper and segment indices

% JpH0 : f x nCh
JpH0=sum(sum(PP.*H0,2),4); % sum of the product of PP and H0 across taper and segment indices

% A : f x nCh 
A=squeeze(JpH0./H0sq); % amplitudes for all frequencies and channels

% A : f x K x nCh x nS
Ap=permute(repmat(A,[1,1,Kp1,Kp2]),[1 3 2 4]); % add the taper index to C

% fitted value for the fft
% Jhat : f x K x nCh x nS
Jhat=Ap.*H0; 

num = (K-1).*(abs(A).^2).*squeeze(H0sq); % numerator for F-statistic
den = squeeze(sum(sum(abs(PP-Jhat).^2,2),4)+sum(sum(abs(PPeven).^2,2),4)); % denominator for F-statistic
fstat=num./den; % F-statisitic
