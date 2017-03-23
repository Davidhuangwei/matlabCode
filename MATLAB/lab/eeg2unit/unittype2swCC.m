histswcx=cell(13,1);
histswhip=cell(13,1);
histhip2cx=cell(13,1);
tbin=10; %msec
binnum=80;
tbinstr=[num2str(tbin) '-' num2str(binnum) 'shshort'];
 if (exist(tbinstr)~=7)
       mkdir(tbinstr);
 end

for jj=5:length(cxelind)
    %fn=[pwd '/' filename{jj} '/' filename{jj} '.eeg'];
    
    %sw=sdetect_a(fn,chnum(jj),ripchind(jj),200,150,5);
  
   %dbstop
    histswcx{jj}=sw2clusCC(filename{jj},cxelind(jj),1,tbin,binnum,'h','sw2cx');
    
    histswhip{jj}=sw2clusCC(filename{jj},hippelind(jj),1,tbin,binnum,'h','sw2hip');
    
end



for jj=5:length(cxelind)

    histhip2cx{jj}=hip2cxCC(filename{jj},hippelind(jj),cxelind(jj),1,tbin,binnum,'h','hip2cx');
    
end

save thurs