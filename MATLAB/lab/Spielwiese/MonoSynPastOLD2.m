function MonoSynPast(FileBase,type,mono,spike,states,varargin)
[overwrite] = DefaultArgs(varargin,{0});

%% number of mono-syn-pairs
nmono = size(mono.From.ElClu,1);


for m=1:nmono
  
  %% find pre- and postsyn cell
  indPre = find(type.elec==mono.From.ElClu(m,1) & type.cell==mono.From.ElClu(m,2));
  indPost = find(type.elec==mono.To.ElClu(m,1) & type.cell==mono.To.ElClu(m,2));
  
  idx1 = find(ismember(spike.ind,[indPre indPost]));
  [ccg tbin] = CCG(spike.t(idx1),spike.ind(idx1),20,30,20000,[indPre indPost],'count');
  figure(1)
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
  axis tight

  %% take only linear track
  idx = ismember(spike.ind,[indPre indPost]) & WithinRanges(round(spike.t/16),states.itv(find(states.ind==2),:)) & spike.good;
  
  for dire = unique(spike.dir(find(idx)))'
    
    dire
    
    if dire<2
      continue
    end
    
    figure(dire);clf
    figure(dire+100);clf
    
    myind = find(idx & spike.dir==dire); 
    
    if isempty(myind)
      continue;
    end
    
    myRes = spike.t(myind);
    myClu = spike.ind(myind);
    
    pairs = [];
    [ccg tbin pairs] = CCG(myRes,myClu,20,30,20000,[indPre indPost],'count');
    
    %% get indixes (in the system of myRes,myClu,mylpos) of spikes of
    %% pre (first column) and post (second column) that fall into the cross-corr.
    if isempty(pairs)
      continue;
    end
    
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
    
    %% close pairs
    myCPairs = myPairs(find(dT<5 & dT>0),:);
    Clpos = mylpos(myCPairs(:,1));
    if ~isempty(Clpos)
      dBIN = (ceil(max(mylpos))-floor(min(mylpos)))/40;
      BIN = [floor(min(mylpos)):dBIN:ceil(max(mylpos))];
      HC = histcI(Clpos,BIN);
      HLE = histcI(mylpos(find(myClu==indPre)),BIN);
      HLO = histcI(mylpos(find(myClu==indPost)),BIN);
    
      HLENorm = zeros(size(HLE));
      HLENorm(find(HLE>0)) = HC(find(HLE>0))./HLE(find(HLE>0));
    end
    
    %% PLOT
    figure(dire)
    subplot(2,3,1);
    bar(tbin,ccg(:,1,1)); axis tight
    title('pre-synaptic');
    
    subplot(2,3,2);
    bar(tbin,ccg(:,2,2)); axis tight
    title('post-synaptic');
    
    subplot(2,3,3)
    %hist(dT(badpos),61); axis tight
    hist(dT,61); axis tight
    title('time lag hist');
    
    subplot(2,3,4)
    plot(dT,lpos,'.');
    axis tight
    title(['direction ' num2str(dire)])
    ylabel('position');
    
    subplot(2,3,5)
    hist2([dT lpos],31,20);
    xlabel('time lag'); ylabel('position');

    subplot(2,3,6)
    [hh XBIN YBIN] = hist2([dT lpos],31,20);
    plot(YBIN(1:end-1),sum(hh(16:18,:),1))
    xlabel('position'); ylabel('count');
    
    
    if isempty(Clpos)
      continue
    end
    figure(dire+100)
    subplot(221)
    bar(BIN(2:end)-dBIN/2,HC)
    ylabel('count');
    title('all pairs within 5ms')
    subplot(223)
    bar(BIN(2:end)-dBIN/2,HLENorm)
    xlabel('Position');
    ylabel('count'); 
    title('all pairs/pre-count')
    subplot(222)
    plot(BIN(2:end)-dBIN/2,HLE)
    title('spike-hist of pre-syn cell')
    subplot(224)
    plot(BIN(2:end)-dBIN/2,HLO)
    title('spike-hist of post-syn cell')
    xlabel('Position');
    
  end
  waitforbuttonpress
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%load([FileBase '.ravdat'],'-MAT');
%monofile = dir([FileBase '*mono-*']);
%load([DirName '/' monofile.name],'-MAT');
%load([FileBase '.mono-' num2str(Els)]);

%now go through pairs

%  bar(tbin,sq(ccg(:,1,2)));axis tight
% waitforbuttonpress;
