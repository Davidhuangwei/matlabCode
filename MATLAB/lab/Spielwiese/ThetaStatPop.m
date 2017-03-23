%% function ThetaStatPop({dirnames})
%% compare statistics across trials
%% input: directory array (the dir name is the same as the FileBase

%function ThetaStatPop(DirName)

%DirName = {'sm9608_490' 'sm9608_492'}
%DirName = ['sm9608_490' 'sm9608_492']

Base = 'sm';
Rat = '9608'
Trial = [490 492 495 496 498 502 505 509 512 513 515 517 518 519 520 ...
	524 527 528 530];
%Trial = [490 492]

nd = length(Trial)

for i=1:nd  

  tr = num2str(Trial(i));
  
  FileBase = [Base Rat '_' tr '/' Base Rat '_' tr]
  
  if FileExists([FileBase '.states.min']) & FileExists([FileBase '.states.max']);
    com=sprintf('dmins=load([FileBase ''.states.min'']);'); %--load
    eval(com);
    com=sprintf('dmaxs=load([FileBase ''.states.max'']);'); %--load
    eval(com);
  else
    [dmins,dmaxs]=ThetaStat(FileBase);
  end
    
  %dmins = 1000./dmins;
  
  meanmins(i) = mean(dmins);
  stdmins(i)  = std(dmins);

  meanmaxs(i) = mean(dmaxs);
  stdmaxs(i)  = std(dmaxs);
    
  Hmins(:,i) = hist(dmins,[0.5:0.5:19])/sum(dmins)/0.5;
  Hmaxs(:,i) = hist(dmaxs,[0.5:0.5:19])/sum(dmaxs)/0.5;
 
  figure(1)
  subplot(ceil(nd/4),4,i)
  hist(dmins,[0.5:0.5:19]);
  title([Base Rat '.' tr])

  figure(2)
  subplot(ceil(nd/4),4,i)
  loglog([0.5:0.5:19],Hmins(:,i))
  xlim([5,15])
  title([Base Rat '.' tr])
end

figure(3)
subplot(2,2,1)
plot(meanmins,meanmaxs,'ro',[min(meanmins) max(meanmins)],[min(meanmins) max(meanmins)])
xlabel('min')
ylabel('max')
%axis([0,nd,5,10])
subplot(2,2,2)
plot(stdmins,stdmaxs,'ro',[min(stdmins) max(stdmins)],[min(stdmins) max(stdmins)])
xlabel('min')
ylabel('max')
%axis([0,nd,0,2])
subplot(2,1,2)
plot([0.5:0.5:19],Hmins',[0.5:0.5:19],Hmaxs')
%axis([0,nd,0,2])

