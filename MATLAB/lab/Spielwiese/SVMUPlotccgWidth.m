function SVMUPlotccgWidth(ALL)
%%
%%

CatAll = CatStruct(ALL);

SIZ = [];
SPD = [];
IND = [];
MXF = [];
MXFP = [];
for n=unique(CatAll.file)'
  if isfield(ALL(n),'xcorrlM')
    if isempty(ALL(n).spectM)
      continue
    end
    reg = ALL(n).cells.region;
    typ = ALL(n).type.num;
    gsp = ALL(n).spectM.good;

    dm = ALL(n).xcorrlM.std;
    dm(end:length(gsp)) = 0;

    sped = ALL(n).xcorrlM.speed;
    sped(end:length(gsp)) = 0;
    
    %%CA1
    gg = find(reg==1 & typ == 2 & gsp');
    
    %keyboard
    SIZ = [SIZ; dm(gg)'];
    IND = [IND; repmat([1 1],length(gg),1)];
    SPD = [SPD; sped(gg)'];
    
    %%CA3
    gg = find(reg==2 & typ == 2 & gsp');
    
    SIZ = [SIZ; dm(gg)'];
    IND = [IND; repmat([3 1],length(gg),1)];
    SPD = [SPD; sped(gg)'];
  
    %%%%%%%%%%%%%%%%%%%%%%%%
    %%% SPECT
    gg = find(reg<3 & typ == 2 & gsp');
    SP = ALL(n).spectM.spunit(:,gg);
    %% max
    gf = find(ALL(n).spectM.f>5 & ALL(n).spectM.f<12);
    [ma mi] = max(SP(gf,:));
    MXF = [MXF; ALL(n).spectM.f(gf(mi))];
    %
    SPP = ALL(n).spectPhM.spunit(:,gg);
    %% max
    gf = find(ALL(n).spectPhM.f>0.5 & ALL(n).spectPhM.f<1.5);
    [ma mi] = max(SPP(gf,:));
    MXFP = [MXFP; ALL(n).spectPhM.f(gf(mi))];
    %
   
  end
  
  %if isfield(ALL(n),'xcorrlW')
  %  reg = ALL(n).cells.region;
  %  typ = ALL(n).type.num;
  %  gsp = ALL(n).spectM.good;
  %  
  %  gg = find(reg==1 & typ == 2 & gsp');
  %  
  %  SIZ = [SIZ; ALL(n).xcorrelM.std(gg)'];
  %  IND = [IND; repmat([1 2],1,length(SIZ))];
  %end
end



%% PLOT
figure(3476583);clf
subplot(121)
bin = [0:100:1500];
ca1 = find(SIZ>0 & SIZ<1000);
h=histcI(SIZ(ca1)*sqrt(-log(0.1)),bin);
bar(bin(2:end)-50,h)
xlim([0 1500])
xlabel('time [ms]','FontSize',16)
ylabel('count','FontSize',16)
set(gca,'TickDir','out','FontSize',16,'XTick',[0:500:1500])
box off
%
subplot(122)
bin = [0:10:200];
h=histcI(SIZ(ca1)*sqrt(-log(0.1)).*SPD(ca1)/1000,bin);
bar(bin(2:end)-5,h)
xlim([0 200])
xlabel('distance [cm]','FontSize',16)
ylabel('count','FontSize',16)
set(gca,'TickDir','out','FontSize',16)
box off

PrintFig('ccgWidth',0)

%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(742);clf
ca1 = find(SIZ>0 & SIZ<1000 & MXFP>=-0.9);
plot(1-1./(sqrt(2)*pi*SIZ(ca1).*MXF(ca1)/1000),1./MXFP(ca1),'o', ...
     'markerfacecolor',[1 1 1]*0.5,'markeredgecolor',[1 1 1]*0.5)
hold on
plot([0.8 1.5],[0.8 1.5],'k--')
%b = robustfit(1-1./(sqrt(2)*pi*SIZ(ca1).*MXF(ca1)/1000),1./MXFP(ca1));
%plot([0.85 1],b(1)+b(2)*[0.85 1],'r--')
xlim([0.8 1.2])
ylim([0.6 1.4])
xlabel('F(f_0,\sigma)','FontSize',16)
ylabel('f_\theta/f_0','FontSize',16)
set(gca,'TickDir','out','FontSize',16)
box off
PrintFig('ccgWidthpredict',0)


%keyboard


%keyboard

