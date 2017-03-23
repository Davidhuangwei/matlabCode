for jj=1:length(cxelind)
    fn=[pwd '/' filename{jj} '/' filename{jj}];
    cxclu=load([fn '.clu.' num2str(cxelind(jj))]);
    cxclu=cxclu(1);
    figure
    letterlayoutl
    ll=cxclu;
    for ii=1:ll
    subplotfit(ii,ll);
    CCsw2unit(filename{jj},cxelind(jj),ii,0.05,20);
    tit=[filename{jj} '.' num2str(cxelind(jj)) '.' num2str(ii)];
    title(tit);
    
    end 
    pictname = strcat(filename{jj},'_sw2clus'); 
    letterlayoutl
    print ('-f','-deps',pictname); 
    close
end