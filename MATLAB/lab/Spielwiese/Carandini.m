function Carandini

t=[-1000:1000];

y = -[exp(-t/200)- exp(-t/100)];
y(1:1000) = 0;

figure(2);clf
mplot = 6;
for n=1:mplot

  x = exp(-t.^2/(n*100)^2)/sum(exp(-t.^2/(n*100)^2))*100;
  
  [c l] = xcorr(y,x);
  gl = l>=-1000 & l<=1000;
  
  CC(:,n) = c(gl)'; 
  
  subplot(mplot,2,n*2-1)
  bar(t/10,[x]);
  hold on
  plot(t/10,[y],'k')
  xlim([-100 100])
  ylim([-0.5 1])
  set(gca,'TickDir','out','FontSize',12)
  ylabel('amplitude | rate','FontSize',12)
  box off
  
  if n==1
    [ma mi] = max(-c(gl));
  end
  
  [mc(n) mt(n) idx] = MaxPeak(l',-c',[],4);
  
  subplot(mplot,2,n*2)
  plot(l(gl)/10,c(gl))
  xlim([-100 100])
  ylim([-30 10])
  Lines(mt(n)/10,[],'g');
  Lines(t(mi)/10);
  set(gca,'TickDir','out','FontSize',12)
  ylabel('amplitude','FontSize',12)
  box off
    
end

subplot(mplot,2,n*2-1)
xlabel('time','FontSize',12)
subplot(mplot,2,n*2)
xlabel('time','FontSize',12)


%% for comp
for n=1:50

  x = exp(-t.^2/(n*10)^2)/sum(exp(-t.^2/(n*10)^2))*100;
  
  [c l] = xcorr(y,x);
  gl = l>=-1000 & l<=1000;
  
  if n==1
    [ma mi] = max(-c(gl));
  end
  
  [mc(n) mt(n) idx] = MaxPeak(l',-c',[],4);
end


figure(3)
subplot(211)
plot(l(gl)/10,CC)
Lines(0,[],'k','--');
set(gca,'TickDir','out','FontSize',12)
xlabel('time','FontSize',12)
ylabel('amplitude','FontSize',12)
box off
%
subplot(413)
plot([1:length(mt)]/10,mt/10,'.')
set(gca,'TickDir','out','FontSize',12)
ylabel('time lag','FontSize',12)
box off
axis tight
%
subplot(414)
plot([1:length(mt)]/10,mc,'.')
set(gca,'TickDir','out','FontSize',12)
xlabel('distance','FontSize',12)
ylabel('amplitude','FontSize',12)
box off
axis tight



return





