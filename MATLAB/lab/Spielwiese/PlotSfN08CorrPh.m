AA = CatStruct(ALL(7:10));

AA.type=AA.type(1:end-1);

for n=1:length(AA.type)
  SX(:,n) = smooth(AA.xcorrlPh.uccg(:,n),5,'lowess');
end

SXP = SX(:,PC);
SXI = SX(:,IN);


AXP = [];
AXI = [];
for n=7:10
  AXP = [AXP ALL(n).xcorrlPh.uccg(:,ALL(n).goodn{2})];
  AXI = [AXI ALL(n).xcorrlPh.uccg(:,ALL(n).goodn{1})];
end



f = ALL(n).spect.f;
gf = find(f>4 & f<10);
MFP = [];
MFI = [];
for n=7:10
  SP = ALL(n).spect.spunit(:,ALL(n).goodn{2});
  [MSP MI] = max(SP(gf,:));
  MFP = [MFP; f(gf(MI))-ALL(n).spect.feeg];
end


figure(3213);clf
subplot(121)
imagesc(AA.xcorrlPh.t(:,1),[],unity(AXP)')
axis xy
xlabel('rel. phase','FontSize',16)
ylabel('cell #','FontSize',16)
Lines([1 2],[],'k','--',2);
set(gca,'FontSize',16,'TickDir','out')
box off
title('phase correlation','FontSize',16)
%
subplot(122)
hi = [-1.5:0.2:1.5];
[hh] = histcI(MFP,[-1.5:0.2:1.5]);
bar(hi(2:end)-0.1,hh)
xlabel('rel. frequency','FontSize',16)
ylabel('count','FontSize',16)
set(gca,'FontSize',16,'TickDir','out')
Lines(mean(MFP),[],'r','--',2);
box off
title('oscillation freqeuncy','FontSize',16)

PrintFig('SfN08PhaseCorr',0)