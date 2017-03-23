function SVMUPlotFpredict(ALL)
%%
%%

SP = [];
F = [];
EF = [];
MXF = [];
CX = [];
CXT = [];
MCXT = [];
for n=unique(CatAll.file)'
  %% spectra
  SizeSP = size(ALL(n).spectM.spunit);
  SP = [SP ALL(n).spectM.spunit(1:100,:)];
  F = [F repmat(ALL(n).spectM.f(1:100),1,SizeSP(2))];
  %% max
  gf = find(ALL(n).spectM.f>5 & ALL(n).spectM.f<12);
  [ma mi] = max(ALL(n).spectM.spunit(gf,:));
  MXF = [MXF; ALL(n).spectM.f(gf(mi))];
  %% Eeg frequency
  EF = [EF repmat(ALL(n).spectM.feeg,1,SizeSP(2))];
  
  %% x-corr
  SizeCX = size(ALL(n).spectM.xcorr);
  DT = [(SizeCX(1)+1)/2-50:(SizeCX(1)+1)/2+50];
  CX = [CX ALL(n).spectM.xcorr(DT,:)];
  CXT = [CXT repmat(ALL(n).spectM.xct(DT)',1,SizeCX(2))];
  %% max
  gt = find(ALL(n).spectM.xct>-4 & ALL(n).spectM.xct<4);
  [mac mic] = max(ALL(n).spectM.xcorr(gt,:));
  MCXT = [MCXT; ALL(n).spectM.xct(gt(mic))'];
end
 
%% phase
PH = CatAll.spectPh.spunit;
P = CatAll.spectPh.f(:,1);
%% max 
gp = find(P>0.5 & P<1.5);
[map mip] = max(CatAll.spectPh.spunit(gp,:));
MXP = CatAll.spectPh.f(gp(mip));

%% wheel



%% good cells
PC1 = find(CatAll.type.num==2 & CatAll.cells.region<3 & CatAll.spect.good')';
IN1 = find(CatAll.type.num==1 & CatAll.cells.region<3 & CatAll.spect.good')';
   

    
%% PLOT    
figure(1);clf

%% example
f=2;
%% Maze
sig = ALL(f).xcorrlM.std;

SP = ALL(f).spectM;
gf = find(SP.f>5 & SP.f<12);
[mx mi] = max(SP.spunit(gf,:));
mspf = SP.f(gf(mi));

SPP = ALL(f).spectPhM;
gf = find(SPP.f>0.5 & SPP.f<1.5);
[mx mi] = max(SPP.spunit(gf,:));
mspfP = SPP.f(gf(mi));

gsig = sig>0 & SP.good & ALL(f).type.num'==2;
pred = mspf(gsig).*(1-1./(sqrt(2)*pi/1000*sig(gsig)'.*mspf(gsig)));

subplot(2,2,1)
plot(pred,mspf(gsig)./mspfP(gsig),'.')
hold on
plot([5 12],[5 12])
axis tight
subplot(2,2,3)
hist(pred,50)
Lines(SP.feeg,[],[],'--');
Lines(mean(pred),[],'g','--')


%% Wheel
sig = ALL(f).xcorrlW.std;

SP = ALL(f).spectW;
gf = find(SP.f>5 & SP.f<12);
[mx mi] = max(SP.spunit(gf,:));
mspf = SP.f(gf(mi));

SPP = ALL(f).spectPhW;
gf = find(SPP.f>0.5 & SPP.f<1.5);
[mx mi] = max(SPP.spunit(gf,:));
mspfP = SPP.f(gf(mi));

gsig = sig>0 & SP.good & ALL(f).type.num'==2;
pred = mspf(gsig).*(1-1./(sqrt(2)*pi/1000*sig(gsig)'.*mspf(gsig)));

subplot(2,2,2)
plot(pred,mspf(gsig)./mspfP(gsig),'.')
hold on
plot([5 12],[5 12])
axis tight
subplot(2,2,4)
hist(pred,50)
Lines(SP.feeg,[],[],'--');
Lines(mean(pred),[],'g','--')
