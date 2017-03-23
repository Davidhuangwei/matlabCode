function BrowseCells(FileBase,type,varargin)
[elc] = DefaultArgs(varargin,{[]});
%% 
%% browse one file at the time


%% load spikeshape features
load([FileBase '.NeuronQuality.mat'],'-MAT')
NQ = CatStruct(OutArgs);

%% get the auto correlograms
load([FileBase '.s2s'],'-MAT')

load([FileBase '.ThRip'],'-MAT')
%% get theta-phase - sleep
ThHistS = ThPh.Hist(find(ThPh.Ind(:,1)==1),:);
ThStsS = ThPh.Sts.th0(find(ThPh.Ind(:,1)==1));
%% shift cell num to [1....n]
cellind = ThPh.Ind(:,2)-min(ThPh.Ind(:,2))+1;


%% add all theta-phase histograms for run
ThHistR = zeros(length(unique(cellind)),size(ThPh.Hist,2));
for n=unique(cellind)'
  for m=unique(ThPh.Ind(find(cellind==n),1))'
    if m==1 
      continue
    end
    ThHistR(n,:) = ThHistR(n,:) + ThPh.Hist(find(ThPh.Ind(:,1)==m & cellind==n),:);
  end
  ThStsR(n) = angle(sum(ThHistR(n,:).*exp(i*ThPh.Bin/180*pi)));
end

%% add all hist of all sessions
RpHist = zeros(length(unique(cellind)),size(Rip.Hist.histCtr,2));
for n=unique(cellind)'
  for m=unique(ThPh.Ind(find(cellind==n),1))'
    RpHist(n,:) = RpHist(n,:) + Rip.Hist.histCtr(find(ThPh.Ind(:,1)==m & cellind==n),:);
  end
end

if isempty(elc)
  xx = find(NQ.ElNum);
else
  xx = find(ismember(NQ.ElNum,elc));
end
X = NQ.SpkWidthR(xx);
Y = NQ.AmpSym(xx);

figure(53453);clf
colormap('default');
subplot(4,3,[4:12])
scatter(X,Y,50,type.act,'filled')
xlabel('spike width');
ylabel('amplitude symmetry');
hold on

%colormap('default');
%scatter(X(find(type.act)),Y(find(type.act)),50,type.act(find(type.act)),'filled')
cc = colormap; 
ccnew = cc([1:8:64],:);
ccnew(1,:) = [0 0 0]; 
colormap(ccnew);
%colorbar
caxis([0 9]);
%colormap(cc);
Lines([],0,[0 0 0],'--');
Lines(0.5,[],[0 0 0],'--');

xlm = get(gca,'XLim');
ylm = get(gca,'YLim');

cx=plot(10*xlm(2),10*ylm(2),'+','markersize',40,'markeredgecolor',[0 0 0]);
xlim(xlm)
ylim(ylm)


while 1
  figure(53453)
  subplot(4,3,[4:12])
  selct = ginput(1);
  if selct(1)>xlm(2) |  selct(1)<xlm(1)  
    break
  end
  if selct(2)>ylm(2) |  selct(2)<ylm(1)  
    break
  end
  [d ind] = sort(sqrt((X-selct(1)).^2 + (Y-selct(2)).^2)); 
  pnt = ind(1);
  set(cx,'XData',X(pnt),'YData',Y(pnt))
  
  subplot(441)
  bar(s2s.tbin,s2s.ccg(:,pnt,pnt,4))
  xlabel('time [ms]')
  title(['cell ' num2str(ThPh.Ind(pnt,2)) ' : (' num2str(NQ.ElNum(xx(pnt))) '|' num2str(NQ.Clus(xx(pnt))) ')'])
  axis tight
  
  if ~isempty(ThHistR)
    subplot(442)
    bar(ThPh.Bin,ThHistR(pnt,:))
    Lines(mod(ThStsR(pnt),2*pi)*180/pi,[],'r',2);
    xlabel('phase [deg]')
    title('theta - run')
    axis tight
  end
  
  if ~isempty(ThHistS)
    subplot(443)
    bar(ThPh.Bin,ThHistS(pnt,:))
    Lines(mod(ThStsS(pnt),2*pi)*180/pi,[],'r',2);
    xlabel('phase [deg]')
    title('theta - sleep')
    axis tight
  end
  
  subplot(444)
  bar(Rip.Hist.bin(1,:),RpHist(pnt,:))
  xlabel('time [ms]')
  title('ripples')
  axis tight
  

  figure(283627);clf
  bar(Rip.Hist.bin(1,:),RpHist(pnt,:))
  hold on
  if sum(Rip.Hist.histEval(pnt,:))>0
    plot(Rip.Hist.binEval,Rip.Hist.histEval(pnt,:)/max(Rip.Hist.histEval(pnt,:))*max(RpHist(pnt,:)),'k-o')
  else
    plot(Rip.Hist.binEval,Rip.Hist.histEval(pnt,:),'k-o')
  end
  axis tight
  smRHist = smooth(RpHist(pnt,:),10,'lowess');
  plot(Rip.Hist.bin(1,:),smRHist,'b','LineWidth',2);
  Lines(Rip.Sts.max(pnt),[],'g','-',2);
  Lines([],Rip.Sts.n(pnt),'r','-',2);
  %Lines(Rip.
  xlabel('time [ms]')
  ylabel('count')
  title('ripples')
  
end

return;