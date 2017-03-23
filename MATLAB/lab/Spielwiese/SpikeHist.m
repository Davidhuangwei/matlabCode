function SpikeHist(spiket,Rat,nt)

%% SpikeHist(spiket(find(spikeind==i)),Rat)

Res = spiket;
NRes = round(Res/512);
NNRes = NRes(find(NRes>=nt(1) & NRes<=nt(2)));
Rat(NNRes,2);
clf
x = [0:10:360];
h=histcI(Rat(NNRes,2),x);
bar(x(1:end-1)+5,h);
set(gca,'XTick',[0:90:360])
xlim([0 360])
grid on;

