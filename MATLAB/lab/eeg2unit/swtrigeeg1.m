figure(1)
figure(2)
%figure(3)
%figure(4)
letterlayoutl
lagleft=0.5;
lagright=1;
samplesnum=(lagleft+lagright)*1250+1;
Avs=cell(length(cxelind),1);
StdErr=cell(length(cxelind),1);
CSD=cell(length(cxelind),1);
sw=cell(length(cxelind),1);
for jj=1:length(cxelind)
    fn=[pwd '/' filename{jj} '/' filename{jj}];
    ll=length(cxelind);
    
    eeg=readmulti(strcat(fn,'.eeg'),chnum(jj),[1:16]);    
    swtmp=load(strcat(fn,'.swa'));
    sw{jj}=swtmp(:,1);  
    [Avs{jj} StdErr{jj}] = TriggeredAv(eeg, lagleft*1250,lagright*1250, sw{jj}*1250/20000 );    
    CSD{jj}=diff(Avs{jj}(:,[1:end-2]),2,2);
    clear eeg

    figure(1)
    subplotfit(jj,ll);
    %PlotWithErr([-lagleft*1250:lagright*1250]/1.25,Avs{jj}(:,8),StdErr{jj}(:,1),'b');
    plot([-lagleft*1250:lagright*1250]/1.25,Avs{jj}(:,8),'b')
    hold on
    %PlotWithErr([-lagleft*1250:lagright*1250]/1.25,Avs{jj}(:,16),StdErr{jj}(:,2),'g');
    plot([-lagleft*1250:lagright*1250]/1.25,Avs{jj}(:,16),'g')
    fAvs=filtereeg(Avs{jj}(:,8),1,100);
    plot([-lagleft*1250:lagright*1250]/1.25,fAvs,'r')
   
    %figure(2)
    %subplotfit(jj,ll);
    %plot([-lagleft*1250:lagright*1250]/1.25,Avs{jj}/1000-repmat([10:10:160],samplesnum,1));
    
    %figure(3)
    %subplotfit(jj,ll);
    %plot([-lagleft*1250:lagright*1250]/1.25,CSD{jj}/1000-repmat([10:10:120],samplesnum,1));
    
    figure(2)
    subplotfit(jj,ll);
    pcolor([-lagleft*1250:lagright*1250]/1.25,[1:12]*(-1),CSD{jj}');
    shading('interp'); 
    
   
       
    tit=[filename{jj} '.' num2str(cxelind(jj))];
    ForAllFig('title(tit)',tit);
            
    %pictname = strcat(filename{jj},'_sw2clus'); 
    ForAllFigures('letterlayoutl');
    %print ('-f','-deps',pictname); 
    
end
save spwtrigeeg.mat Avs StdErr CSD sw