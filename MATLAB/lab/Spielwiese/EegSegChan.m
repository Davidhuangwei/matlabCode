function [spt, spf, spy] = EegSegChan(FileBase,varargin)

[chan,win,overlap,FIGURE] = DefaultArgs(varargin,{[4 12 20 28],2^10,2^9,0});

%% chan = [4 12 20 28];  %% channel numbers
%% win = 2^10;           %% window size
%% noverlap = 2^9;       %% overlap: dt appox. 200-500ms
%% FIGURE = 0;

%% get the eeg and compute the frequency content for each bin
Par =LoadPar([FileBase '.par']);
ChanMax = Par.nChannels; 
if max(chan)>ChanMax
  error('this channel does not exsist');
end

for i=1:length(chan)
  fprintf(['channel ' num2str(chan(i)) '...']);
  eeg  = readsinglech([FileBase '.eeg'],Par.nChannels,chan(i));
  %% whiten signal
  weeg = WhitenSignal(eeg);
  %% power spectrum of each segment
  [spy1,spf,spt] = mtchglong(weeg,2^11,1250,win,overlap,1.5,'linear',[],[1 100]);
  spy(:,:,i) = spy1(:,:);
  
  if FIGURE  
    cfigure(FIGURE)
    imagesc(spt,spf,spy(:,1:100)',[0 10^5]); shading interp;
    %pcolor(y(1:100,:)');
    set(gca, 'ydir', 'normal')
    colorbar;
  end
end
  
return