 fileExt = '_LinNearCSD121.csd'
 fileExt = '.eeg'

tf = LoadDesigVar(fileBaseCell,['RemVsRun06_noExp_MinSpeed5wavParam6Win1250' fileExt],depVarCell{1},trialDesig)

chanMat = LoadVar(['ChanInfo/ChanMat' fileExt])
selChan = Struct2CellArray(LoadVar(['ChanInfo/SelChan' fileExt]),[],1)

subplotHeight = 2;
xyfactor = 1;
for m=1:size(selChan,1)
    figure(m)
    set(gcf,'name',Dot2Underscore(['sm9603_SelChan' fileExt]))
    refSelChan = m;
    behaviors = fieldnames(tf)
    SetFigPos([],[0.5,0.5,subplotHeight*xyfactor*length(behaviors),subplotHeight*size(selChan,1)])
    for k=1:length(behaviors)
        for j=1:size(selChan,1)
            subplot(size(selChan,1),length(behaviors),(j-1)*length(behaviors)+k)
            plot(tf.(behaviors{k})(:,selChan{refSelChan,2}),tf.(behaviors{k})(:,selChan{j,2}),'.')
            set(gca,'xlim',[4 12],'ylim',[4 12])
            title(behaviors{k})
            xlabel(selChan{refSelChan,1})
            ylabel(selChan{j,1})

        end
    end
end

ReportFigSM(1:size(selChan,1),'/u12/smm/public_html/NewFigs/ThetaPaper/FreqCorrelations/')

close all


