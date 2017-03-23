function [p,nRips,f,MeanPow] = pspecplots(FileBase, ThetaPer, ChNums);

if (nargin<3),  fprintf('Usage: (''FileBase'',[ThetaPer],[ChNums])\n'); return; end;

filename = ([FileBase '.eeg']);

[analsum, eeg] = Truncate(FileBase,ThetaPer,ChNums,1);

asum = round(analsum);
fprintf('\nTotal analysis period = %d\n',asum);

pmax = 0;

for i = 1:8
    [P, F] = spectrum(eeg(:,i),2^10,2^8,2^9,1250);
    if(max(P(:,1)) > pmax) 
        pmax = max(P(:,1));
    end
    subplot(2,4,i), plot(F,log10(P(:,1)));
    xlabel('frequency (Hz)');
    ylabel('log10(power)');
    title([i]);
end

for i = 1:8
    subplot(2,4,i);
    set(gca,'XLim',[0 200]);
    set(gca,'YLim',[2 6.5]);
end

letterlayoutl;

%figure;

%for i = 5:8
 %   [P, F] = spectrum(eeg(:,i),2^10,2^8,2^9,1250);
 %   subplot(2,2,i-4), plot(F,P(:,1));
 %   set(gca,'XLim',[0 500]);
 %   set(gca,'YLim',[0 10^6]);
 %end


%plot(F,P(:,1));
%set(gca,'XLim',[0 150]);
%set(gca,'XTick',[10 20 30 40 50 60 70 80 90 100 110 120 130 140 150]);

%Pyy = P(:,1);
%size(P)
%f = (0:128);
%plot(f,Pyy(1:129))
%itle('Frequency content of y')
%xlabel('frequency (Hz)')