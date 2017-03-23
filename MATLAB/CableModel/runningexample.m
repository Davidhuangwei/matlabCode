NA=[];
 stp=.01;
[NeuronParams,NA]=setMophology(4,'sCable2',stp);% NA is th
IN.GgabaA=0.1*rand(160,5*10^3);
 IN.GgabaB=0.1*rand(160,5*10^3);IN.Gglu=0.1*rand(160,5*10^3);
%  IN.Gglu(21:25,:)=3*sin(pi/20*repmat([1:1000],5,1));

 vm=zeros(160,10^3);
 %
 cc=zeros(4,40);
 cc(1,11:15)=1; % 10:15
 %%
 for k=1:10
 NA=updateNeuron(NA,zeros(160,1).*cc(:)*(k<10),zeros(160,1),zeros(160,1));%IN.Gglu(:,k),IN.GgabaA(:,k), IN.GgabaB(:,k)
 figure(1);hold on;
 plot(NA.Is(1:4:160)./NA.gs(1:4:160),'r+-')
%  plot(NA.Ca1(1:4:160),'r+-')
%  pause(.1)
 plot(NA.Is(1:4:160)./NA.gs(1:4:160),'b+-')
%  plot(NA.Ca1(1:4:160),'b+-')
 %  NA=updateNeuron(NA,Gglu,GgabaA,GgabaB)
 if sum(isnan(NA.Vm))>0
     fprintf('wrong at %d',k)
     return
 end
 vm(:,k)=NA.Ca2;%sum(NA.Im,2);
 end
  plot(NA.Is(1:4:160)./NA.gs(1:4:160),'r+-')
  figure;imagesc(stp*[1:1000],1:40,vm([1:4:160,2:4:160],:),max(abs(vm(:)))*[-1 1])
 %%
  figure(2);hold on;plot(1:5000,vm,':')
 