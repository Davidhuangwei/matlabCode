figure
letterlayoutl
lagleft=0.2;
lagright=0.4;
cnt=0;
for jj=1:length(cxelind)
    fn=[pwd '/' filename{jj} '/' filename{jj}];
    ll=length(cxelind);
    cnt=cnt+1;    
    subplotfit(cnt,ll);
    eeg1=readsinglech(strcat(fn,'.eeg'),chnum(jj),spndchind(jj));    
    eeg2=readsinglech(strcat(fn,'.eeg'),chnum(jj),ripchind(jj));
    eeg=[eeg1 eeg2];
    clear eeg1 eeg2
    sw=load(strcat(fn,'.swa'));
    sw=sw(:,1);  
    [Avs StdErr] = TriggeredAv(eeg, lagleft*1250,lagright*1250, sw*1250/20000 );    
    clear eeg
    %PlotWithErr([-lagleft*1250:lagright*1250]/1.25,Avs(:,1),StdErr(:,1),'b');
    plot([-lagleft*1250:lagright*1250]/1.25,Avs(:,1),'b')
    hold on
    %PlotWithErr([-lagleft*1250:lagright*1250]/1.25,Avs(:,2),StdErr(:,2),'g');
    plot([-lagleft*1250:lagright*1250]/1.25,Avs(:,2),'g:')
    tit=[filename{jj} '.' num2str(cxelind(jj)) ];
    title(tit);
    filename{jj}
end
    pictname = ['anal/swtreeg' filename{jj} ]; 
    letterlayoutl
    print ('-f','-depsc',pictname); 
    %close

