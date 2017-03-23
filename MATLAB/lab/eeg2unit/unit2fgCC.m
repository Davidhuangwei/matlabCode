
histswcx=cell(13,1);
histswhip=cell(13,1);
loadlist
tbin=10; %msec
binnum=50;
tbinstr=[num2str(tbin) '-' num2str(binnum)];
 if (exist(tbinstr)~=7)
       mkdir(tbinstr);
 end

for jj=1:length(cxelind)
    fn=[pwd '/' filename{jj} '/' filename{jj} '.eeg'];
    
    sw=sdetect_a(fn,chnum(jj),ripchind(jj),130,100,5);

    sw=sw(:,2);   
 if ~isempty(sw)  
    histswcx{jj}=sw2clusCC(filename{jj},cxelind(jj),1,tbin,binnum,sw,'sw2cx');
    for k=1:size(histswcx{jj},1)
        histswcx{jj}{k}(:,1)=histswcx{jj}{k}(:,1)/sum(histswcx{jj}{k}(:,1));
    end
    
    histswhip{jj}=sw2clusCC(filename{jj},hippelind(jj),1,tbin,binnum,sw,'sw2hip');
    for k=1:size(histswhip{jj},1)
        histswhip{jj}{k}(:,1)=histswhip{jj}{k}(:,1)/sum(histswhip{jj}{k}(:,1));
    end
end
    
end
save fg
