function MonoSynPast(FileBase,type,mono,spike,states,varargin)
[overwrite,selstate] = DefaultArgs(varargin,{0,2});

%% number of mono-syn-pairs
nmono = size(mono.From.ElClu,1);

if ~FileExists([FileBase '.MonoSynSignif']) | overwrite
  signif = MonoSynPastSig(spike,mono,type,states,[],[],selstate);
  save([FileBase '.MonoSynSignif'],'signif')
else
  load([FileBase '.MonoSynSignif'],'-MAT')
end
Cat = CatStruct(signif);

%% load electrode information
load([FileBase '.elc'],'-MAT')

for m=1:nmono
  
  %% find pre- and postsyn cell
  indPre = find(type.elec==mono.From.ElClu(m,1) & type.cell==mono.From.ElClu(m,2));
  indPost = find(type.elec==mono.To.ElClu(m,1) & type.cell==mono.To.ElClu(m,2));

  [indPre indPost]
  
  %% BrowsOneCell
  BrowseOneCells(FileBase,type,[indPre indPost],find(elc.region==1));
  
  idx1 = find(ismember(spike.ind,[indPre indPost]));
  [ccg tbin] = CCG(spike.t(idx1),spike.ind(idx1),20,30,20000,[indPre indPost],'count');
  
  indpre = find(spike.ind==indPre);
  indpost = find(spike.ind==indPost);
  jitter = round(2*(rand(length(indpost),1)-0.5)*200);
  [jccg tbin] = CCG([spike.t(indpost)+jitter;spike.t(indpre)],[spike.ind(indpost);spike.ind(indpre)],20,30,20000,[indPre indPost],'count'); 
  %[aint aini apci] = NearestNeighbour(spike.t(indpost),spike.t(indpre),'right',100);
  %JJ = histcI((spike.t(indpost(aini))-spike.t(indpre(apci)))/20,tbin-mean(diff(tbin))/2);
  
  figure(1);clf
  subplot(221)
  bar(tbin,ccg(:,1,1))
  axis tight
  title(['presynaptic cell ' num2str(indPre)])
  subplot(224)
  bar(tbin,ccg(:,2,2))
  axis tight
  title(['postsynaptic cell ' num2str(indPost)])
  subplot(223)
  bar(tbin,ccg(:,1,2))
  hold on 
  plot(tbin,jccg(:,1,2),'r')
  %plot(tbin(1:end-1),JJ,'g.')
  axis tight
  subplot(222)
  bar(tbin,jccg(:,1,2))
  title('jitter')
  axis tight
  
  %% take only linear track
  idx = ismember(spike.ind,[indPre indPost]) & WithinRanges(round(spike.t/16),states.itv(find(states.ind==selstate),:)) & spike.good;
  
  %% check if good
  [ccg tbin] = CCG(spike.t(find(idx)),spike.ind(find(idx)),20,30,20000,[indPre indPost],'count');

  if sum(ccg(:,1,2))/61<5
    continue
  end

  %% separate directions
  for dire = unique(spike.dir(find(idx)))'
    
    dire
        
    %if signif(nmono).ind(3)>0 & dire<2
    if dire<2
      continue
    end
    
    figure(dire+1);clf
    
    myind = find(idx & spike.dir==dire);
    
    if isempty(myind)
      continue;
    end
    
    myRes = spike.t(myind);
    myClu = spike.ind(myind);
    myPos = spike.lpos(myind);
    
    pairs = [];
    [ccg tbin pairs] = CCG(myRes,myClu,20,30,20000,[indPre indPost],'count');
    
    %% find significance
    gpair = find(Cat.ind(1,:)==indPre & Cat.ind(2,:)==indPost & Cat.ind(3,:)==dire);

    sigbin = find(Cat.out.PvalShufCCG(:,gpair)<0.01 & Cat.out.tbin(:,gpair)>0 & Cat.out.tbin(:,gpair)<5);
    tt = Cat.out.tbin(:,gpair);
    if isempty(sigbin)
      sig = [];
    else
      sig = [min(tt(sigbin))-mean(diff(tt))/2 max(tt(sigbin))+mean(diff(tt))/2];
    end
          
    %% PLOT
    figure(dire+1)
    subplot(2,3,1);
    bar(tbin,ccg(:,1,1)); axis tight
    title(['pre-synaptic ' num2str(indPre)]);
    
    subplot(2,3,2);
    bar(tbin,ccg(:,2,2)); axis tight
    title(['post-synaptic ' num2str(indPost)]);
    
    
    %% get indixes (in the system of myRes,myClu,mylpos) of spikes of
    %% pre (first column) and post (second column) that fall into the cross-corr.
    if ~isempty(pairs)
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
      
      subplot(2,3,3)
      %%hist(dT(badpos),61); axis tight
      %hist(dT,61); axis tight
      %hold on
      %title('time lag hist');
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
      %subplot(212)
      %plot(tt,Cat.out.PvalShufCCG(:,gpair),'b','LineWidth',2)
      %hold on
      %plot(tt,0.01*ones(size(tt)),'--k')
      

      %subplot(2,3,4)
      %plot(dT,lpos,'.');
      %axis tight
      %title(['direction ' num2str(dire)])
      %xlabel('time lag');
      %ylabel('position');
      
      subplot(2,3,4)
      hist2([dT lpos],31,20);
      xlabel('time lag'); ylabel('position');
    
    end
    
    %%get nearest neighbors
    indpre = find(myClu==indPre);
    indpost = find(myClu==indPost);
    if ~isempty(sig)
      [int ini pci] = NearestNeighbour(myRes(indpost),myRes(indpre),'right',sig(2)*20);
    else
      [int ini pci] = NearestNeighbour(myRes(indpost),myRes(indpre),'right',0);
    end
      
    if isempty(ini) | isempty(pci)
      continue
    end
    
    dBIN = (ceil(max(myPos))-floor(min(myPos)))/20;
    BIN = [floor(min(myPos)):dBIN:ceil(max(myPos))];
    HH = histcI(myPos(indpost(ini)),BIN);
    
    subplot(235)
    bar(BIN(2:end)-dBIN/2,HH);
    hold on
    %%check for significance
    for kk=1:1000
      jitter = round(2*(rand(length(indpost),1)-0.5)*100);
      [jint jini jpci] = NearestNeighbour(myRes(indpost)+jitter,myRes(indpre),'right',sig(2)*20);
      if isempty(jini)
	JH(:,kk) = zeros(length(BIN)-1,1);
      else
	JH(:,kk) = histcI(myPos(indpost(jini)),BIN);
      end
    end
    
    for ll=1:size(JH,1)
      smJH(ll,:) = smooth(sort(JH(ll,:)),200,'lowess');
    end
    
    pval = prctile(JH,95,2);
    %pval = smJH(:,950);%prctile(JH,95,2);
    plot(BIN(2:end)-dBIN/2,pval,'g');
    plot(BIN(2:end)-dBIN/2,smJH(:,50),'g');
    plot(BIN(2:end)-dBIN/2,mean(JH,2),'r');
    xlabel('distance');
    ylabel('count');
    axis tight
    
    subplot(236)
    plot(BIN(2:end)-dBIN/2,HH-pval,'LineWidth',2)
    Lines([],0,[1 1 1]*0.5,'--');
    hold on
    tx = BIN(2:end)-dBIN/2;
    xx = HH-pval;
    plot(tx(find(xx>0)),xx(find(xx>0)),'or','LineWidth',2)
    ShadeArea([tx(find(xx>0))-dBIN/2; tx(find(xx>0))+dBIN/2],[],[1 1 1]*0.7);
    xlabel('distance')
    ylabel('count-pval');
    
    %[jccg jtbin] = CCG([myRes(indpre);myRes(indpost)+jitter],[myClu(indpre);myClu(indpost)],20,30,20000,[indPre indPost],'count');
    %subplot(233)
    %%plot(jtbin,jccg(:,1,2),'r')
    %KK = histcI((myRes(indpost(ini))-myRes(indpre(pci)))/20,tbin-mean(diff(tbin))/2);
    %plot(tbin(1:end-1),KK,'g.')
    %%keyboard
    
  end
  waitforbuttonpress
end


return;
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
