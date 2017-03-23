function CC = SVMUca1ca3(CatAll)

pc = CatAll.type.num==2;
good = CatAll.PhH.pval<0.05;

ca1 = CatAll.cells.region==1;
ca3 = CatAll.cells.region==2;

m=0; count=0;
aTh1 = []; aTh3 = [];
idx1 = []; idx3 = [];

figure(7583);clf;
for n=unique(CatAll.file)'
  
  %keyboard
  
  file = CatAll.file==n;
  
  if isempty(find(ca3&file))
    continue;
  end
  
  th01 = CatAll.PhH.th0(pc&good&ca1&file);
  th03 = CatAll.PhH.th0(pc&good&ca3&file);
  
  aTh1 = [aTh1; th01];
  aTh3 = [aTh3; th03];
  
  idx1 = [idx1; find(pc&good&ca1&file)];
  idx3 = [idx3; find(pc&good&ca3&file)];
  
  
  m=m+1;
  
  %%%%%%%%
  %% Stats
  
  %% number of cells
  CC.n(m,:) =  [length(th01) length(th03)];
  
  %% mean phase for each:
  CC.mph(m,:) = mod([circmean(th01) circmean(th03)],2*pi);
    
  %% circ anova
  CC.canv(m) = CircAnova({th01,th03});
  
  
  %%%%%% FIG 1 %%%%%%%%
  PLOT = 1;
  if PLOT
    %figure(7583);clf;
    subplot(5,6,2*m-1)
    r=rose(th01);
    set(r,'color',[0.5 0 0],'LineWidth',2)
    %set(r,'FontSize',16)
    %xlabel('CA1','FontSize',16)
    %ylabel(num2str(m),'FontSize',16,'rotation',0)
    ylabel(num2str(CC.canv(m)),'FontSize',16,'rotation',0)
    if m<4; title('ca1','FontSize',16);end
    %
    subplot(5,6,2*m)
    r=rose(th03);
    set(r,'color',[0 0 0.5],'LineWidth',2)
    %set(r,'FontSize',16)
    %xlabel('CA3','FontSize',16)
    if m<4; title('ca3','FontSize',16);end
    
    %PrintFig(['SVMUca1ca3S.' num2str(m)],0)
    
  end
  
end

Ph1 =  CatAll.PhH.th0(pc&good&ca1);
Clu1 = CatAll.file(pc&good&ca1);
dummy = myPhaseOfTrain(Ph1,Clu1);
CC.statca1 = CatStruct(dummy([1:12 14]));

Ph2 =  CatAll.PhH.th0(pc&good&ca3);
Clu2 = CatAll.file(pc&good&ca3);
dummy = myPhaseOfTrain(Ph2,Clu2);
CC.statca3 = CatStruct(dummy([1:12 14]));

%% overall
%% mean phase for each:
CC.amph = mod([circmean(aTh1) circmean(aTh3)],2*pi);
%% circ anova
CC.acanv = CircAnova({aTh1,aTh3});


%% print table
a = round(CC.mph*180/pi);
for n=1:13
  fprintf([num2str(n) ' & ' num2str(CC.n(n,1)) ' & ' num2str(a(n,1)) ' & ' num2str(CC.n(n,2)) ' & ' num2str(a(n,2)) ' & ' num2str(round(CC.canv(n)*100)/100)]);  
  if CC.canv(n) > 0.05
    fprintf(' &   hline \n')
  else
    fprintf(' & * hline \n')
  end
end
fprintf(['All & ' num2str(sum(CC.n(:,1))) ' & ' num2str(round(CC.amph(1)*180/pi)) ' & ' num2str(sum(CC.n(:,2))) ' & ' num2str(round(CC.amph(2)*180/pi)) ' & ' num2str(round(CC.acanv*100)/100) '\n']); 


%%%% FIG 2 %%%%%%%%%
figure(7582);clf;
subplot(221)
HH1 = CatAll.PhH.phhist(:,idx1);
for n=1:size(HH1,2)
  SHH1(:,n) = smooth(HH1(:,n),5,'lowess');
end
imagesc(CatAll.PhH.phbin(:,1)*180/pi,[],unity(SHH1)');
axis xy
Lines(CC.amph(1)*180/pi,[],'r','--',2);
Lines(CC.amph(1)*180/pi-360,[],'r','--',2);
Lines(180,[],'k','--',2);
Lines(180-360,[],'k','--',2);
set(gca,'FontSize',16,'TickDir','out','XTick',[-360:180:360])
xlabel('phase','FontSize',16)
ylabel('cell #','FontSize',16)
title('CA1 pyramidal cells','FontSize',16)
box off
%
subplot(222)
HH3 = CatAll.PhH.phhist(:,idx3);
for n=1:size(HH3,2)
  SHH3(:,n) = smooth(HH3(:,n),5,'lowess');
end
imagesc(CatAll.PhH.phbin(:,1)*180/pi,[],unity(SHH3)');
axis xy
Lines(CC.amph(1)*180/pi,[],'r','--',2);
Lines(CC.amph(1)*180/pi-360,[],'r','--',2);
Lines(180,[],'k','--',2);
Lines(180-360,[],'k','--',2);
set(gca,'FontSize',16,'TickDir','out','XTick',[-360:180:360])
xlabel('phase','FontSize',16)
ylabel('cell #','FontSize',16)
title('CA3 pyramidal cells','FontSize',16)
box off
%
subplot(223)
r=rose(aTh1);
set(r,'color',[0 0 0],'LineWidth',2)
%set(r,'FontSize',16)
xlabel('CA1','FontSize',16)
%
subplot(224)
r=rose(aTh3);
set(r,'color',[0 0 0],'LineWidth',2)
%set(r,'FontSize',16)
xlabel('CA3','FontSize',16)

PrintFig(['SVMUca1ca3'],0)


%%%%%%%% FIG 3 %%%%%%%%




return;

