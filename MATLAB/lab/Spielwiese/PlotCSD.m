function PlotCSD(y)

figure
avcsd = sq(mean(y,2));
pcolor(avcsd'); shading interp;
set(gca,'YDir','rev');
ForAllSubplots('caxis([-1500        1500])');
