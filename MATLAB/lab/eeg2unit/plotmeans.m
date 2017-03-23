
for jj=5:length(cxelind)
    
    for k=1:size(histswcx{jj},1)
      %histswcx{jj}{k}=rightaveraging(histswcx{jj}{k});
       histswcx{jj}{k}(:,2)=histswcx{jj}{k}(:,2)/sum(abs(histswcx{jj}{k}(:,1)));
       histswcx{jj}{k}(:,1)=histswcx{jj}{k}(:,1)/sum(abs(histswcx{jj}{k}(:,1)));
    end
   
    for k=1:size(histswhip{jj},1)
      %  histswhip{jj}{k}=rightaveraging(histswhip{jj}{k});
        histswhip{jj}{k}(:,2)=histswhip{jj}{k}(:,2)/sum(abs(histswhip{jj}{k}(:,1)));
        histswhip{jj}{k}(:,1)=histswhip{jj}{k}(:,1)/sum(abs(histswhip{jj}{k}(:,1)));
    end
    
     for k=1:size(histhip2cx{jj},1)
       %  histhip2cx{jj}{k}=rightaveraging(histhip2cx{jj}{k});
        histhip2cx{jj}{k}(:,2)=histhip2cx{jj}{k}(:,2)/sum(abs(histhip2cx{jj}{k}(:,1)));
         histhip2cx{jj}{k}(:,1)=histhip2cx{jj}{k}(:,1)/sum(abs(histhip2cx{jj}{k}(:,1)));
              
    end
    
    
end




avhistall=[];
avhistint=[];
avhistpyr=[];
avhisthip=[];
avhistburst=[];
avhistrs=[];
avhisthip2cxin=[];
avhisthip2cxout=[];
avhisthip2cxall=[];

errhistall=[];
errhistint=[];
errhistpyr=[];
errhisthip=[];
errhistburst=[];
errhistrs=[];
errhisthip2cxin=[];
errhisthip2cxout=[];
errhisthip2cxall=[];


inttype=  {[4,7],[], [],     [2,3,4],  [3],    [2,3,4] , [2],   [2,3,4,5,9], [3,4,6], [2,3,4], [3],     [3],  [3] };
bursttype={[],   [], [3,6,9],[],        [],    [],       [3,5],  [6,7],      [5,7],  [],      [4,5],    [],  [4,5,6] };
rstype =  {[],   [], [],     [6,7],     [2,4],  [],       [],     [],        [],      [],       [2,5,6], [2],  [2] };
pyrtype=cell(13,1);

for i=[5,8:13]
  %  fn=[filename{i} '/' filename{i} '.clu.' num2str(cxelind(i))] ;
  %  clunum=load(fn);
  %  clunum=clunum(1);
  for k=2:size(histswcx{i},1)
      if (~ismember(k,inttype{i}))
          pyrtype{i}(end+1)=k;
      end
  end
  
  avhistall=[avhistall histswcx{i}{1}(:,1) ];
  errhistall=[errhistall histswcx{i}{1}(:,2).^2 ];
  if length(inttype{i})~=0
      for j=1:length(inttype{i})
          avhistint=[avhistint histswcx{i}{j}(:,1)];
          errhistint=[errhistint histswcx{i}{j}(:,2).^2];
      end
  end
  
  if length(pyrtype{i})~=0
    for j=1:length(pyrtype{i})
          avhistpyr=[avhistpyr histswcx{i}{j}(:,1)];
           errhistpyr=[errhistpyr histswcx{i}{j}(:,2).^2];
    end
  end
  
  if length(bursttype{i})~=0
    for j=1:length(bursttype{i})
          avhistburst=[avhistburst histswcx{i}{j}(:,1)];
          errhistburst=[errhistburst histswcx{i}{j}(:,2).^2];
    end
  end
  
  if length(rstype{i})~=0
    for j=1:length(rstype{i})
          avhistrs=[avhistrs histswcx{i}{j}(:,1)];
          errhistrs=[errhistrs histswcx{i}{j}(:,2).^2];
    end
  end

  avhisthip2cxin=[avhisthip2cxin histhip2cx{i}{2}(:,1)];
  avhisthip2cxout=[avhisthip2cxout histhip2cx{i}{3}(:,1)];
  avhisthip2cxall=[avhisthip2cxall histhip2cx{i}{1}(:,1)];
  
  errhisthip2cxin=[errhisthip2cxin histhip2cx{i}{2}(:,2).^2];
  errhisthip2cxout=[errhisthip2cxout histhip2cx{i}{3}(:,2).^2];
  errhisthip2cxall=[errhisthip2cxall histhip2cx{i}{1}(:,2).^2];
  
  
  
  avhisthip=[avhisthip histswhip{i}{1}(:,1) ];
  errhisthip=[errhisthip histswhip{i}{1}(:,2).^2 ];
end

meanhipcxall=mean(avhisthip2cxall,2);
meanhipcxin=mean(avhisthip2cxin,2);
meanhipcxout=mean(avhisthip2cxout,2);
stdhipcxall=std(avhisthip2cxall,0,2);
stdhipcxin=std(avhisthip2cxin,0,2);
stdhipcxout=std(avhisthip2cxout,0,2);
errhipcxall=sqrt(mean(errhisthip2cxall,2))/2;
errhipcxin=sqrt(mean(errhisthip2cxin,2))/2;
errhipcxout=sqrt(mean(errhisthip2cxout,2))/2;

meanhistall=mean(avhistall,2);
stdhistall=std(avhistall,0,2);
errhistall=sqrt(mean(errhistall,2))/2;

meanhistint=mean(avhistint,2);
stdhistint=std(avhistint,0,2);
errhistint=sqrt(mean(errhistint,2))/2;

stdhistpyr=std(avhistpyr,0,2);
meanhistpyr=mean(avhistpyr,2);
errhistpyr=sqrt(mean(errhistpyr,2))/2;


stdhisthip=std(avhisthip,0, 2);
meanhisthip=mean(avhisthip,2);
errhisthip=sqrt(mean(errhisthip,2))/2;

stdhistburst=std(avhistburst,0,2);
meanhistburst=mean(avhistburst,2);
errhistburst=sqrt(mean(errhistburst,2))/2;

stdhistrs=std(avhistrs,0,2);
meanhistrs=mean(avhistrs,2);
errhistrs=sqrt(mean(errhistrs,2))/2;

display('I am ready to plot!!! ');
pause

trange= [-binnum:binnum]*tbin;  %histswhip{1}{1}(:,2);
inttrange=linspace(trange(1),trange(end),3*(2*binnum+1));

figure

subplot(3,2,2)
what=meanhistall;
whaterr=stdhistall;
bar(trange,what,'b');
hold on
plot(inttrange,spline(trange,what,inttrange),'r');
%errorbar(trange,what,whaterr,'.g')
plot(trange,errhistall,'g--');
plot(trange,-errhistall,'g--');
tit='all';
title(tit);

subplot(3,2,1)
what=meanhisthip;
whaterr=stdhisthip;
bar(trange,what,'b');
hold on
plot(inttrange,spline(trange,what,inttrange),'r');
%errorbar(trange,what,whaterr,'.g')
plot(trange,errhisthip,'g--');
plot(trange,-errhisthip,'g--');
tit='hippocampus';
title(tit);

subplot(3,2,3)
what=meanhistint;
whaterr=stdhistint;
bar(trange,what,'b');
hold on
plot(inttrange,spline(trange,what,inttrange),'r');
%errorbar(trange,what,whaterr,'.g')
plot(trange,errhistint,'g--');
plot(trange,-errhistint,'g--');
tit='interneurons (FS)';
title(tit);

subplot(3,2,4)
what=meanhistpyr;
whaterr=stdhistpyr;
bar(trange,what,'b');
hold on
plot(inttrange,spline(trange,what,inttrange),'r');
%errorbar(trange,what,whaterr,'.g')
plot(trange,errhistpyr,'g--');
plot(trange,-errhistpyr,'g--');
tit='pyramidal'
title(tit);


subplot(3,2,5)
what=meanhistburst;
whaterr=stdhistburst;
bar(trange,what,'b');
hold on
plot(inttrange,spline(trange,what,inttrange),'r');
%errorbar(trange,what,whaterr,'.g')
plot(trange,errhistburst,'g--');
plot(trange,-errhistburst,'g--');
tit='bursty (IB)'
title(tit);


subplot(3,2,6)
what=meanhistrs;
whaterr=stdhistrs;
bar(trange,what,'b');
hold on
plot(inttrange,spline(trange,what,inttrange),'r');
%errorbar(trange,what,whaterr,'.g')
plot(trange,errhistrs,'g--');
plot(trange,-errhistrs,'g--');
tit='regular spiking (RS)'
title(tit);

figure

subplot(311)
what=meanhipcxall;
whaterr=stdhipcxall;
whaterr1=errhipcxall;
bar(trange,what,'b');
hold on
plot(inttrange,spline(trange,what,inttrange),'r');
%errorbar(trange,what,whaterr,'.g')
plot(trange,whaterr1,'g--');
plot(trange,-whaterr1,'g--');
tit='All CA1 spikes vs cortical spikes'
title(tit);

subplot(312)
what=meanhipcxin;
whaterr=stdhipcxin;
whaterr1=errhipcxin;
bar(trange,what,'b');
hold on
plot(inttrange,spline(trange,what,inttrange),'r');
%errorbar(trange,what,whaterr,'.g')
plot(trange,whaterr1,'g--');
plot(trange,-whaterr1,'g--');
tit='CA1 spikes within ripples vs cortical spikes'
title(tit);

subplot(313)
what=meanhipcxout;
whaterr=stdhipcxout;
whaterr1=errhipcxout;
bar(trange,what,'b');
hold on
plot(inttrange,spline(trange,what,inttrange),'r');
%errorbar(trange,what,whaterr,'.g')
plot(trange,whaterr1,'g--');
plot(trange,-whaterr1,'g--');
tit='CA1 spikes outside ripples vs cortical spikes'
title(tit);

