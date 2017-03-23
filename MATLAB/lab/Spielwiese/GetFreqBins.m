function f=GetFreqBins(nFFT,Fs,FreqRange)
%%
%% get frequey bins

if rem(nFFT,2),    %% nfft odd
  select = [1:(nFFT+1)/2];
else               %% nfft even
  select = [1:nFFT/2+1];
end

f = (select - 1)'*Fs/nFFT;
nFreqRanges = size(FreqRange,1);

if nFreqRanges==1
  select = find(f>FreqRange(1) & f<FreqRange(end));
  f = f(select);
  nFreqBins = length(select);
else
  select=[];
  for i=1:nFreqRanges
    select=cat(1,select,find(f>FreqRange(i,1) & f<FreqRange(i,2)));
  end
  f = f(select);
  nFreqBins = length(select);
end

return
