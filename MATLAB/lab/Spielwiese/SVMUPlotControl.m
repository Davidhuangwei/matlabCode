function SVMUPlotControl(ALL)

k=0;
for f=[6 7 8 9 30]%1:length(ALL)
  if ~isempty(ALL(f).info)
    if ALL(f).info.Wheel==1 & ALL(f).info.BehNum==4
      %ALL(f).info.FileBase
      
      gcell = ALL(f).type.num==2;     
      %ggcell = ALL(f).type.num>1;     
      ggcell = ALL(f).type.num==2 & ALL(f).spectW.good';     
      fggcell = find(ggcell);
      
      length(find(ggcell))/length(find(gcell))
      
      k=k+1;
      figure(k);clf
      subplot(221)
      imagesc(ALL(f).spectW.f,[],unity(ALL(f).spectW.spunit(:,ggcell))')
      hold on
      plot(ALL(f).spectW.f,ALL(f).spectW.speeg/max(ALL(f).spectW.speeg)*length(find(ggcell)),'k','LineWidth',2)
      xlim([5 12])
      Lines(ALL(f).spectW.feeg,[],'k','--');      
      axis xy
      %
      subplot(222)
      gf = find(ALL(f).spectPhW.f>0.4 & ALL(f).spectPhW.f<1.6);
      imagesc(ALL(f).spectPhW.f,[],unity(ALL(f).spectPhW.spunit(gf,ggcell))')
      axis xy
      Lines(1,[],'k','--');
      xlim([0.5 1.5])
      %
      subplot(223)
      [so si] = sort(ALL(f).PhH.th0(ggcell));
      %so = ALL(f).PhH.th0(ggcell);
      %si = [1:length(so)];
      imagesc(ALL(f).PhH.phbin*180/pi,[],unity(ALL(f).PhH.sphhist(:,fggcell(si)))')
      hold on
      plot([so so-2*pi]*180/pi,repmat([1:length(so)],1,2),'k.')
      gp = find(ALL(f).PhH.pval(fggcell(si))<0.05);
      plot(so(gp)*180/pi,gp,'o')
      axis xy
      
    end
  end
end


CatAll = CatStruct(ALL([6 7 8 9 30]));
gcell = CatAll.type.num==2;
ggcell = CatAll.type.num==2 & CatAll.spectW.good';

%% hist
phbin = CatAll.PhH.phbin(:,1);
phhist = CatAll.PhH.sphhist(:,ggcell);
th0 = CatAll.PhH.th0(ggcell);
[st sti] = sort(th0);

%% rel. spect
rf = CatAll.spectPhW.f(:,1);
rspect = CatAll.spectPhW.spunit(:,ggcell);
%% max
gf = find(rf>0.5 & rf<1.5);
[maxx maxt Idx] = MaxPeak(rf,rspect,[0.5 1.5],3);
[sp spi] = sort(maxt);

figure(k+1);clf
subplot(221)
imagesc(phbin,[],unity(phhist(:,sti))')
%imagesc(phbin,[],(phhist(:,sti))')
axis xy
hold on
plot(th0(sti),[1:length(th0)],'k.')
%
subplot(223)
imagesc(rf(gf),[],unity(rspect(gf,sti))')
axis xy
Lines(1,[],'k','--');
hold on
plot(maxt(sti),[1:length(maxt)],'k.')
%%
subplot(222)
imagesc(phbin,[],unity(phhist(:,spi))')
axis xy
hold on
plot(th0(spi),[1:length(th0)],'k.')
%
subplot(224)
imagesc(rf(gf),[],unity(rspect(gf,spi))')
axis xy
Lines(1,[],'k','--');
hold on
plot(maxt(spi),[1:length(maxt)],'k.')
%


figure(k+2);clf
rose(th0)



return


%% 
f = [6 7 8 9 30]



n=1;plot(ALL(f).PhH.phbin(:,1)*180/pi,ALL(f).PhH.sphhist(:,fggcell(si(n))));Lines(ALL(f).PhH.th0(fggcell(si(n)))*180/pi);

for n=1:length(ALL(6).PhH.th0)
  figure(1);clf
  plot(ALL(6).PhH.phbin,ALL(6).PhH.phhist(:,n))
  sm = smooth(ALL(6).PhH.phhist(:,n));
  hold on
  plot(ALL(6).PhH.phbin,ALL(6).PhH.sphhist(:,n),'r')
  plot(ALL(6).PhH.phbin,sm,'g')
  Lines(ALL(6).PhH.th0(n));
  WaitForButtonpress
end
