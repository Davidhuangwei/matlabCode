function [Rate RBin] = InstantRate(FileBase,spk,spi,varargin)
%% 
%% function Rate = InstantRate(FileBase,spk,spi,varargin)
%% computes instanateous firing rate from spikes spk
%% 
%% optional arguments: 
%%   RateRate:   spike times and sample rate of output rate (default EegRate)
%%   StandDiv:   standard devition of Gaussian kernel in ms (default 20ms)
%%   OutFile:    file extension of saved file
[overwrite, RateRate, StandDiv,OutFile,SAVE] = DefaultArgs(varargin,{0,[],25,'.InstantRate',0});

if ~FileExists([FileBase OutFile]) | overwrite

  Par = LoadPar(FileBase);
  if isempty(RateRate)
    RateRate = Par.lfpSampleRate;
  end
  
  mt = round(spk);
  mt(find(mt==0)) = 1;
  rawRate = Accumulate([mt spi],1,[max(mt) max(spi)]);
  
  s = round(StandDiv*RateRate/1000);
  x = [-10*s:10*s];
  gauss =  exp(-x.^2/(2*s^2))/(s*sqrt(2*pi));
  
  keep = conv(reshape(rawRate,1,max(mt)*max(spi)),gauss);
  MRate = reshape(keep(10*s+1:end-10*s),max(mt),max(spi));
  
  Rate = MRate;
  RBin = ([1:size(MRate,1)])/RateRate;
  
  %SSRate = ButFilter(MRate,1,4/(RateRate/2),'low');
  %Rate = SMRate+repmat(mean(MRate),size(MRate,1),1);
  
  if SAVE 
    save([FileBase OutFile],'Rate','RBin')
  end
  
else
  load([FileBase OutFile],'-MAT')
end

return;