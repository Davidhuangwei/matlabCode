function [yy f] = MyPow(t,y,fs,lwin,overlap)

%% length of window
L = lwin;

NFFT = 2^nextpow2(L); % Next power of 2 from length of y
f = fs/2*linspace(0,1,NFFT/2);


if lwin>=length(t)

  Y = fft(y,NFFT)/L;
  yy = 2*abs(Y(1:NFFT/2));

else
  
  %% number of windows
  N = ceil((length(t)-overlap)/(lwin-overlap));
  
  %% adjust overlap
  overlap = ceil((N*lwin-length(t))/(N-1));
  
  SY = zeros(NFFT/2,1);
  for n=1:N
    k = [1:L]+(n-1)*(L-overlap);
    Y = fft(y(k),NFFT)/L;
    SY = SY+2*abs(Y(1:NFFT/2));
  end
  
  yy = SY/N;
end
  
return;
