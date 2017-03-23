function [p,nRips,f,MeanPow] = thetacoherea(FileBase, ThetaPer, ChNums);

if (nargin<3),  fprintf('Usage: (''FileBase'',[ThetaPer],[ChNums])\n'); return; end;

filename = ([FileBase '.eeg']);

[analsum, eeg] = Truncate2(FileBase,ThetaPer,ChNums,1);

asum = round(analsum);
fprintf('\nTotal analysis period = %d\n',asum);

spectrum(eeg(:,1),eeg(:,2),2^10,2^8,2^9,1250);

%plot(F,P(:,1));
%set(gca,'XLim',[0 150]);
%set(gca,'XTick',[10 20 30 40 50 60 70 80 90 100 110 120 130 140 150]);

%Pyy = P(:,1);
%size(P)
%f = (0:128);
%plot(f,Pyy(1:129))
%itle('Frequency content of y')
%xlabel('frequency (Hz)')