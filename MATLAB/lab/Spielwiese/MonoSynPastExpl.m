function MonoSynPastExpl(FileBase,type,mono,spike,states,varargin)
[overwrite,Pairs] = DefaultArgs(varargin,{0,[1]});

%% number of mono-syn-pairs
nmono = size(mono.From.ElClu,1);

%% significance of mono-syn connections
if ~FileExists([FileBase '.MonoSynSignif']) | overwrite
  signif = MonoSynPastSig(spike,mono,type,states);
  save([FileBase '.MonoSynSignif'],'signif')
else
  load([FileBase '.MonoSynSignif'],'-MAT')
end
Cat = CatStruct(signif);

%% load electrode information
load([FileBase '.elc'],'-MAT')

%% PARAM
param.hbin = 2*30;
param.bin = 2*20;
param.njit = 200;
param.nn = 20; %% nearest neigbours within significance interval x param.nn
    
param.pdbin = 200/12;%(ceil(max(myPos))-floor(min(myPos)))/100;
param.pbin = [1:param.pdbin:200];%BIN = [floor(min(myPos)):dBIN:ceil(max(myPos))];
dBIN = param.pdbin;
BIN = param.pbin;

%% compute everything for ONE pair!
m=Pairs;
indPre = find(type.elec==mono.From.ElClu(m,1) & type.cell==mono.From.ElClu(m,2));
indPost = find(type.elec==mono.To.ElClu(m,1) & type.cell==mono.To.ElClu(m,2));

[indPre indPost]
  
%% BrowsOneCell
BrowseOneCells(FileBase,type,[indPre indPost],find(elc.region==1));

%% show ccg over all (includes ALL spikes, not only theta)
idx1 = find(ismember(spike.ind,[indPre indPost]));
[ccg tbin] = CCG(spike.t(idx1),spike.ind(idx1),param.bin,param.hbin,20000,[indPre indPost],'count');
  
%% jitter post syn spikes:
indpre = find(spike.ind==indPre);
indpost = find(spike.ind==indPost);
jitter = round(2*(rand(length(indpost),1)-0.5)*param.njit);
[jccg tbin] = CCG([spike.t(indpost)+jitter;spike.t(indpre)],[spike.ind(indpost);spike.ind(indpre)],param.bin,param.hbin,20000,[indPre indPost],'count'); 

figure(1);clf
subplot(221)
bar(tbin,ccg(:,1,1))
axis tight
xlim([-30 30])
title(['presynaptic cell ' num2str(indPre)])
subplot(224)
bar(tbin,ccg(:,2,2))
axis tight
xlim([-30 30])
title(['postsynaptic cell ' num2str(indPost)])
subplot(223)
bar(tbin,ccg(:,1,2))
hold on 
plot(tbin,jccg(:,1,2),'r')
%plot(tbin(1:end-1),JJ,'g.')
axis tight
xlim([-30 30])
subplot(222)
bar(tbin,jccg(:,1,2))
title('jitter')
axis tight
xlim([-30 30])

%% take only linear track
idx = ismember(spike.ind,[indPre indPost]) & WithinRanges(round(spike.t/16),states.itv(find(states.ind==2),:)) & spike.good;

%% separate directions
for dire = unique(spike.dir(find(idx)))'
  if dire<2
    continue
  end
    
    myind = find(idx & spike.dir==dire); 
    if isempty(myind)
      continue;
    end
    
    myRes = spike.t(myind);
    myClu = spike.ind(myind);
    myPos = spike.lpos(myind);
    
    %% ccg for one direction
    [ccg tbin pairs] = CCG(myRes,myClu,param.bin,param.hbin,20000,[indPre indPost],'count');
    
    %% significance of mono-syn peak in ccg (gray shading)
    gpair = find(Cat.ind(1,:)==indPre & Cat.ind(2,:)==indPost & Cat.ind(3,:)==dire);
    sigbin = find(Cat.out.PvalShufCCG(:,gpair)<0.01 & Cat.out.tbin(:,gpair)>0 & Cat.out.tbin(:,gpair)<5);
    tt = Cat.out.tbin(:,gpair);
    if isempty(sigbin)
      sig = [];
    else
      sig = [min(tt(sigbin))-mean(diff(tt))/2 max(tt(sigbin))+mean(diff(tt))/2];
    end
    
    %% PLOT ccg
    figure(dire);clf
    subplot(2,3,1);
    bar(tbin,ccg(:,1,1)); axis tight
    title(['pre-synaptic ' num2str(indPre)]);
    xlim([-30 30])
    %
    subplot(2,3,2);
    bar(tbin,ccg(:,2,2)); axis tight
    title(['post-synaptic ' num2str(indPost)]);
    xlim([-30 30])
    %
    subplot(2,3,3)
    bar(tt,Cat.out.CCG(:,gpair))
    hold on
    plot(tt,Cat.out.smCCG(:,gpair),'b','LineWidth',2)
    plot(tt,Cat.out.AvShufCCG(:,gpair),'r','LineWidth',2)
    plot(tt,Cat.out.AvShufCCG(:,gpair)+Cat.out.StdShufCCG(:,gpair),'--r','LineWidth',1)
    plot(tt,Cat.out.AvShufCCG(:,gpair)-Cat.out.StdShufCCG(:,gpair),'--r','LineWidth',1)
    if ~isempty(sig)
      ShadeArea(sig,[]);
    end
    xlim([-30 30])
    
    
    %% Analyze monosynaptic contribution
    %% get indixes (in the system of myRes,myClu,mylpos) of spikes of
    %% pre (first column) and post (second column) that fall into the cross-corr.
    myPairs = pairs(find(myClu(pairs(:,1))==indPre & myClu(pairs(:,2))==indPost),:);
    if isempty(myPairs)
      continue
    end
    
    %% get the time lag betweeb pre and post
    dT = diff(myRes(myPairs),1,2)*1000/20000;
    if isempty(dT)
      continue
    end
    
    %% get position: 
    mylpos = spike.lpos(myind);
    
    %% get the position of every pre spike
    lpos = mylpos(myPairs(:,1));
    
    subplot(2,3,4)
    hist2([dT lpos],31,20);
    xlabel('time lag'); ylabel('position');
    
    %%get nearest neighbors
    indpre = find(myClu==indPre);
    indpost = find(myClu==indPost);
    if ~isempty(sig)
      [int ini pci] = NearestNeighbour(myRes(indpost),myRes(indpre),'right',sig(2)*param.nn);
    else
      [int ini pci] = NearestNeighbour(myRes(indpost),myRes(indpre),'right',0);
    end
    if isempty(ini) | isempty(pci)
      continue
    end
    
    %% position histogram
    %HH = histcI(myPos(indpost(ini)),BIN);
    [HH Bins] = HistOv(myPos(indpost(ini)),30,15,[0 200]);
    smHH = HH;%smooth(HH,10,'lowess');
    
    %%check for significance
    for kk=1:1000
      jitter = round(2*(rand(length(indpost),1)-0.5)*param.njit);
      [jint jini jpci] = NearestNeighbour(myRes(indpost)+jitter,myRes(indpre),'right',sig(2)*param.nn);
      if isempty(jini)
	%JH(:,kk) = zeros(length(param.pbin)-1,1);
	%smJH(:,kk) = zeros(length(param.pbin)-1,1);
	JH(:,kk) = zeros(length(Bins),1);
	smJH(:,kk) = zeros(length(Bins),1);
      else
	%JH(:,kk) = histcI(myPos(indpost(jini)),param.pbin);
	JH(:,kk) = histOv(myPos(indpost(jini)),30,15,[0 200]);
	smJH(:,kk) = JH(:,kk);%smooth(JH(:,kk),10,'lowess');
      end
    end
    
    subplot(235)
    bar(Bins,smHH);
    hold on
    pval = prctile(smJH,[5 95],2);
    plot(Bins,pval(:,2),'g');
    plot(Bins,pval(:,1),'g');
    plot(Bins,mean(smJH,2),'r');
    xlabel('distance');
    ylabel('count');
    axis tight
    
    subplot(236)
    plot(Bins,smHH-pval(:,2),'LineWidth',2)
    Lines([],0,[1 1 1]*0.5,'--');
    hold on
    tx = Bins;
    dtx = mean(diff(Bins));
    xx = smHH-pval(:,2);
    plot(tx(find(xx>0)),xx(find(xx>0)),'or','LineWidth',2)
    ShadeArea([tx(find(xx>0))-dtx/2 tx(find(xx>0))+dtx/2]',[],[1 1 1]*0.7);
    xlabel('distance')
    ylabel('count-pval');
 
end

return;

subplot(235)
bar(BIN(2:end)-dBIN/2,smHH);
hold on
pval = prctile(smJH,[5 95],2);
plot(BIN(2:end)-dBIN/2,pval(:,2),'g');
plot(BIN(2:end)-dBIN/2,pval(:,1),'g');
plot(BIN(2:end)-dBIN/2,mean(smJH,2),'r');
xlabel('distance');
ylabel('count');
axis tight

subplot(236)
plot(BIN(2:end)-dBIN/2,smHH-pval(:,2),'LineWidth',2)
Lines([],0,[1 1 1]*0.5,'--');
hold on
tx = BIN(2:end)-dBIN/2;
xx = smHH-pval(:,2);
plot(tx(find(xx>0)),xx(find(xx>0)),'or','LineWidth',2)
ShadeArea([tx(find(xx>0))-dBIN/2; tx(find(xx>0))+dBIN/2],[],[1 1 1]*0.7);
xlabel('distance')
ylabel('count-pval');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%load([FileBase '.ravdat'],'-MAT');
%monofile = dir([FileBase '*mono-*']);
%load([DirName '/' monofile.name],'-MAT');
%load([FileBase '.mono-' num2str(Els)]);

%now go through pairs

%  bar(tbin,sq(ccg(:,1,2)));axis tight
% waitforbuttonpress;


%    myPairs = pairs(find(myClu(pairs(:,1))==indPre & myClu(pairs(:,2))==indPost),:);
%    if isempty(myPairs)
%      continue
%    end%%
%
%    %% get the time lag betweeb pre and post
%    dT = diff(myRes(myPairs),1,2)*1000/20000;
%    if isempty(dT)
%      continue
%    end
%    
%    %% get position: 
%    mylpos = spike.lpos(myind);
%    
%    %% get the position of every pre spike
%    lpos = mylpos(myPairs(:,1));
%    
%    %% close pairs
%    myCPairs = myPairs(find(dT<5 & dT>0),:);
%    Clpos = mylpos(myCPairs(:,1));
%    if ~isempty(Clpos)
%      dBIN = (ceil(max(mylpos))-floor(min(mylpos)))/40;
%      BIN = [floor(min(mylpos)):dBIN:ceil(max(mylpos))];
%      HC = histcI(Clpos,BIN);
%      HLE = histcI(mylpos(find(myClu==indPre)),BIN);
%      HLO = histcI(mylpos(find(myClu==indPost)),BIN);
%    
%      HLENorm = zeros(size(HLE));
%      HLENorm(find(HLE>0)) = HC(find(HLE>0))./HLE(find(HLE>0));
%    end
%    
%    %% PLOT
%    figure(dire)
%    subplot(2,3,1);
%    bar(tbin,ccg(:,1,1)); axis tight
%    title('pre-synaptic');
%    
%    subplot(2,3,2);
%    bar(tbin,ccg(:,2,2)); axis tight
%    title('post-synaptic');
%    
%    subplot(2,3,3)
%    %hist(dT(badpos),61); axis tight
%    hist(dT,61); axis tight
%    title('time lag hist');
%    
%    subplot(2,3,4)
%    plot(dT,lpos,'.');
%    axis tight
%    title(['direction ' num2str(dire)])
%    ylabel('position');
%    
%    subplot(2,3,5)
%    hist2([dT lpos],31,20);
%    xlabel('time lag'); ylabel('position');
%
%    subplot(2,3,6)
%    [hh XBIN YBIN] = hist2([dT lpos],31,20);
%    plot(YBIN(1:end-1),sum(hh(16:18,:),1))
%    xlabel('position'); ylabel('count');
%    
%    
%    if isempty(Clpos)
%      continue
%    end
%    figure(dire+100)
%    subplot(221)
%    bar(BIN(2:end)-dBIN/2,HC)
%    ylabel('count');
%    title('all pairs within 5ms')
%    subplot(223)
%    bar(BIN(2:end)-dBIN/2,HLENorm)
%    xlabel('Position');
%    ylabel('count'); 
%    title('all pairs/pre-count')
%    subplot(222)
%    plot(BIN(2:end)-dBIN/2,HLE)
%    title('spike-hist of pre-syn cell')
%    subplot(224)
%    plot(BIN(2:end)-dBIN/2,HLO)
%    title('spike-hist of post-syn cell')
%    xlabel('Position');
%    
