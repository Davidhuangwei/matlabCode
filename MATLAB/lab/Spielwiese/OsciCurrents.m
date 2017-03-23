function OsciCurrents
%%
%%

x=[1:100]/100;
cc=colormap('lines');
gray = [1 1 1]*0.3;

figure(1);clf
f0 = 3;
phi = pi/2; 
plot(x,[sin(2*pi*f0*x)-1],'--','color',cc(2,:),'LineWidth',2); 
hold on; 
plot(x,[;0.5*sin(2*pi*f0*x+phi)],'--','color',cc(3,:),'LineWidth',2); 
plot(x,[sin(2*pi*f0*x)-1+1.5*sin(2*pi*f0*x+phi)],'color',gray,'LineWidth',2); 
hold off
axis off
text(-0.07,-2.2,'Inh(t)','color',cc(2,:),'FontSize',20)
text(-0.07,-1.7,'Exc(t)','color',cc(3,:),'FontSize',20)
text(-0.14,-1.2,'Exc(t) + Inh(t)','color',gray,'FontSize',20)
%Lines([0.37 0.37],[0 0.8],'k');
Lines([0.37],[-0.2 1],'k','-',2);
annotation('arrow',[0.45 0.42],[0.72 0.72],'LineWidth',3,'color','k');
PrintFig('/u12/caro/tex/present/Tuebingen/OsciCurrents1',1)

figure(2);clf
f0=3;
phi=-pi/2;
plot(x,[sin(2*pi*f0*x)-1],'--','color',cc(2,:),'LineWidth',2); 
hold on; 
plot(x,[0.5*sin(2*pi*f0*x+phi)],'--','color',cc(3,:),'LineWidth',2); 
plot(x,[sin(2*pi*f0*x)-1+1.5*sin(2*pi*f0*x+phi)],'color',gray,'LineWidth',2); 
hold off
axis off
text(-0.07,-0.2,'Inh(t)','color',cc(2,:),'FontSize',20)
text(-0.07,0.3,'Exc(t)','color',cc(3,:),'FontSize',20)
text(-0.14,0.8,'Exc(t) + Inh(t)','color',gray,'FontSize',20)
Lines([0.47],[-0.2 1],'k','-',2);
annotation('arrow',[0.45 0.49],[0.72 0.72],'LineWidth',3,'color','k');
PrintFig('/u12/caro/tex/present/Tuebingen/OsciCurrents2',1)
%colormap('default');

