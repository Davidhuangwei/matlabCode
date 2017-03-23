function [spt, spf, spy] = EegSegChan2(FileBase,varargin)

[chan,win,overlap,overwrite,FIGURE,band] = DefaultArgs(varargin,{[4 12 20 28],2^10,2^9,0,0,'th'});

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

if FileExists([FileBase '.eeg.' band 't'])...
      & FileExists([FileBase '.eeg.' band 'f'])...
      & FileExists([FileBase '.eeg.' band 'y'])...  
      & ~overwrite
      
  spt = load([FileBase '.eeg.' band 't'],'-MAT');
  spf = load([FileBase '.eeg.' band 'f'],'-MAT');
  spy = load([FileBase '.eeg.' band 'y'],'-MAT');
else
  
  for i=1:length(chan)
    fprintf(['channel ' num2str(chan(i)) '...']);
    eeg  = readsinglech([FileBase '.eeg'],Par.nChannels,chan(i));
    %% whiten signal
    weeg = WhitenSignal(eeg);
    %% power spectrum of each segment
    [spy1,spf,spt] = mtchglong(weeg,2^11,1250,win,[],1.5,'linear',[],[1 100]);
    spy(:,:,i) = spy1(:,:);

    if FIGURE  
      cfigure(FIGURE)
      imagesc(spt,spf,spy(:,1:100)',[0 10^5]); shading interp;
      %pcolor(y(1:100,:)');
      set(gca, 'ydir', 'normal')
      colorbar;
    end
  end
  save([FileBase '.eeg.' band 't'],'spt','-MAT');
  save([FileBase '.eeg.' band 'f'],'spf','-MAT');
  save([FileBase '.eeg.' band 'y'],'spy','-MAT');
end
  
return