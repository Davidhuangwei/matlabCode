% local ripple vs local firing rate analysis.

% load sharpwaves 

sampling_rate = 1250;

SW = load('sm0012sp.sw')/8; % divisor=8 for 100 microsecond recording

chselect = [0:7]+1;
if ~exist('eeg');
eeg = readmulti('sm0012sp.eeg',8,chselect);
end;

% find isolated ripple
% minimum isolation period

min_isolation_period = 0.7;


min_ip = min_isolation_period * 1250;

sw = SW(:,2);

dsw = diff(sw);

disw = find(dsw > min_ip);

isw = disw+1;

isolated_sharpwave = SW(:,2);% sw(isw);

% powerspectrum measurement definition

www = 256;
wwwb = www/2;
wwwe = www/2-1;

fftaxis = [0:sampling_rate/www:sampling_rate/2];

ripple_range = [120,200];
rr = [min(find(fftaxis>120)):max(find(fftaxis<200))];

%%% Power Spectrum Measurement %%%

RP = zeros(length(isolated_sharpwave),length(chselect));
for ii=1:length(isolated_sharpwave)
  for jj=1:length(chselect)
    rdata = eeg(isolated_sharpwave(ii)-wwwb:...
		isolated_sharpwave(ii)+wwwe,jj);
    rdata = detrend(rdata);
    fdata = fft(rdata);
    pdata = abs(fdata).^2;
    ripplepower = sum(pdata(rr));
    RP(ii,jj) = ripplepower;
  end
end

%%% Coherence measurement %%% 
CXX = zeros(length(chselect),length(chselect),length(rr));
CYY = zeros(length(chselect),length(chselect),length(rr));
CXY = zeros(length(chselect),length(chselect),length(rr));

for ii=1:length(isolated_sharpwave)

rdata = eeg(isolated_sharpwave(ii)-wwwb:...
		isolated_sharpwave(ii)+wwwe,:);
    rdata = detrend(rdata);
    fdata = fft(rdata);
    for jj=1:length(chselect)
      for kk=1:length(chselect)
	ripplexspec = fdata(rr,jj).*conj(fdata(rr,kk));
	ripplespecx = abs(fdata(rr,jj)).^2;
	ripplespecy = abs(fdata(rr,kk)).^2;
	CXY(jj,kk,:) = CXY(jj,kk,:) +  reshape(ripplexspec,1,1,length(rr));
	CXX(jj,kk,:) = CXX(jj,kk,:) +  reshape(ripplespecx,1,1,length(rr));
	CYY(jj,kk,:) = CYY(jj,kk,:) +  reshape(ripplespecy,1,1,length(rr));
      end
    end
end


COH = (abs(CXY).^2)./(CXX.*CYY);

figure(1);
clf
subplot(1,2,1);
imagesc(corrcoef(RP),[0,1]);
set(gca,'PlotBoxAspectRatio',[1,1,1]);
colorbar
xlabel('tetrode #');
ylabel('tetrode #');
title('ripple (120-200Hz) power correlation');

COHM = mean(COH,3);
subplot(1,2,2);
imagesc(COHM,[0,1]);
set(gca,'PlotBoxAspectRatio',[1,1,1]);
colorbar
xlabel('tetrode #');
ylabel('tetrode #');
title('ripple(120-200Hz) coherence ');