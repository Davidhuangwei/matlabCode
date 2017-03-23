function cmprs = CompressIndx(FileBase,spt,spi,spx,varargin)
%% function sdfsdfhjh(FileBase,spt,spi,spx,varargin)
%% 
%% compute rge compression index 
%%
%%
[whl,overwrite,cutoffrate,PLOT,poscut,tcut] = DefaultArgs(varargin,{[],0,10,0,[],[]});

[ccg t] = CCG(spt,spi,50,1000);

%% auto-correlogram
Auto = GetDiagonal(ccg);
SAuto = reshape(smooth(Auto,20,'lowess'),size(Auto,1),size(Auto,2));

%% Cross correlograms
[Cros CrosI] = GetOffDiagonal(ccg);
SCros = reshape(smooth(Cros,20,'lowess'),size(Cros,1),size(Cros,2));
S2Cros = reshape(smooth(Cros,200,'lowess'),size(Cros,1),size(Cros,2));

%% compute theta offset:
nt = repmat(t,1,size(SCros,2));
dt = round(100/mean(diff(t)));
Lmins = LocalMinima(reshape(-SCros,prod(size(SCros)),1),dt,-cutoffrate);

mid = find(nt==0);
[xx xi yi] = NearestNeighbour(Lmins,mid,'both',dt);
%% maxdist in NearestNeighbour does not work??

gdist = find(abs(mid(yi)'-xx)<=dt);
dtheta = nt(xx(gdist));

%% compute the large time off-set 
[lmax lmaxt lmaxi] = MaxPeak(t,S2Cros(:,gdist),[],2);
%[b bstat] = Myrobustfit(lmaxt,dtheta);
if ~isempty(tcut)
  in = find(lmaxt>tcut(1) & lmaxt<tcut(2));
  [b bstat] = robustfit(lmaxt(in),dtheta(in),'welsch',0.9);
else
  [b bstat] = robustfit(lmaxt,dtheta,'welsch',0.9);
end
  
cmprs.pair = CrosI(gdist,:);
cmprs.thetat = dtheta;
cmprs.fieldt = lmaxt;
cmprs.cmprt = b;
cmprs.cmprtstat = bstat;


%% lin-pos offset
if isempty(whl)
  cmprs.posx = [];
  cmprs.cmprstt = [];
  cmprs.cmprsttp = [];
else
  gwhl = round(whl(round(whl)>0)); 
  Occ = Accumulate(gwhl,1); 

  ix = round(spx)>0;
  rate = Accumulate([round(spx(ix)) spi(ix)],1)./repmat(Occ(1:max(round(spx(ix)))),1,max(spi)); 
  Srate = [];
  for n=unique(spi)'
    Srate = [Srate smooth(rate(:,n),50,'lowess')];
  end
  [Mrate MrateP] = max(Srate);
  DPos = diff([MrateP(CrosI(gdist,1)); MrateP(CrosI(gdist,2))]);
  %[bp bpstat] = Myrobustfit(DPos,dtheta);
  if ~isempty(poscut)
    in = find(DPos>poscut(1) & DPos<poscut(2));
    [bp bpstat] = robustfit(DPos(in),dtheta(in),'welsch',0.9);
  else
    [bp bpstat] = robustfit(DPos,dtheta,'welsch',0.9);
  end
    
  cmprs.posx = DPos;
  cmprs.cmprp = bp;
  cmprs.cmprpstat = bpstat;
end

if PLOT
  figure(1);clf
  subplot(211)
  cmpr = cmprs;
  plot(cmpr.posx,cmpr.thetat,'o','markersize',5,'markerfacecolor',[1 1 1]*0,'markeredgecolor',[1 1 1]*0)
  hold on
  plot([-200:200],cmpr.cmprp(1)+cmpr.cmprp(2)*[-200:200],'r--')
  axis tight
  xlim([-100 100])
  ylim([-200 200])
  xlabel('\Delta distance [cm]','FontSize',16)
  ylabel('\Delta time [ms]','FontSize',16)
  c = round(cmpr.cmprp(2)*10)/10;
  text(-70,150,['c=' num2str(c) ' [ms/cm]'],'FontSize',16);
  set(gca,'FontSize',16,'TickDir','out')
  box off
  %
  subplot(212)
  cmpr = cmprs;
  plot(cmpr.fieldt,cmpr.thetat,'o','markersize',5,'markerfacecolor',[1 1 1]*0,'markeredgecolor',[1 1 1]*0)
  hold on
  plot([-1000:1000],cmpr.cmprt(1)+cmpr.cmprt(2)*[-1000:1000],'r--')
  axis tight
  xlim([-1000 1000])
  ylim([-100 100])
  xlabel('\Delta time [ms]','FontSize',16)
  ylabel('\Delta time [ms]','FontSize',16)
  c = round(cmpr.cmprt(2)*10)/10;
  text(-900,70,['c=' num2str(c) ' [ms/cm]'],'FontSize',16);
  set(gca,'FontSize',16,'TickDir','out')
  box off
end

return;
%%%%%%%%%%%%%%%%%%%%%%%%%%%

pos = round(whl.lin(WithinRanges([1:length(whl.lin)],trial.itv) & round(whl.lin)>0));
ix = ismember(spike.ind,GoodPC) & WithinRanges(round(spike.t/SampleRate*EegRate),trial.itv) & spike.lpos(:,1)>0 & spike.good;
CompressIndx(FileBase,spike.t(ix),spike.ind(ix),spike.lpos(ix),pos)