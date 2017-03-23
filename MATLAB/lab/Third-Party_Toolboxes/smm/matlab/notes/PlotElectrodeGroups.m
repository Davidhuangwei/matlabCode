function PlotElectrodeGroups(fileBase,chanMat)

parID = fopen([fileBase '.par']);

junk = str2num(fgetl(parID));
nChan = junk(1);
junk = fgetl(parID);
nEl = str2num(fgetl(parID));
%keyboard
ElGroups = {};
figure
for j=1:nEl
    temp = str2num(fgetl(parID));
    ElGroups{j} = temp(2:end)+1;
    subplot(1,nEl,j)
    alterPat = ones(nChan,1);
    alterPat(logical(mod(floor(((1:nChan)-1)/16),2)) & logical(mod(1:nChan,2))) = 2;
    alterPat(~logical(mod(floor(((1:nChan)-1)/16),2)) & ~logical(mod(1:nChan,2))) = 2;
    imagesc(Make2DPlotMat(alterPat',chanMat,ElGroups{j}));
    set(gca,'xtick',[1:6],'ytick',[1:16],'clim',[0 2])
    title(['elec #: ' num2str(j)])
    grid on
end
fclose(parID)

