function MonoSynPast(FileBase,type,mono,spike,states,varargin)
[overwrite] = DefaultArgs(varargin,{0})

%% number of mono-syn-pairs
nmono = size(mono.From.ElClu,1);


for m=1:nmono
  
  %% find pre- and postsyn cell
  indPre = find(type.elec==mono.From.ElClu(m,1) & type.cell==mono.From.ElClu(m,2));
  indPost = find(type.elec==mono.To.ElClu(m,1) & type.cell==mono.To.ElClu(m,2));
  
  %% loop through states:
  for st=unique(states.ind)
    
    idx = ismember(spike.ind,[indPre indPost]) & WithinRanges(round(spike.t/16),states.itv(find(states.ind==st),:));
    
    for dire = unique(spike.dir(find(idx)))'
      if st==2 & dire==0
	continue
      end
      
      if st>1
	myind = find(idx & spike.good & spike.dir==dire); 
      else
	myind = find(idx);
      end
      
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
      if st==1 | st==3
	mylpos = spike.pos(myind,1);
      else
	mylpos = spike.lpos(myind);
      end
      
      %% get the position of every pre spike
      lpos = mylpos(myPairs(:,1));
      
      %% PLOT
      figure(st);clf
      subplot(2,3,1);
      bar(tbin,ccg(:,1,1)); axis tight
      title('pre-synaptic');
      
      subplot(2,3,4);
      bar(tbin,ccg(:,2,2)); axis tight
      title('post-synaptic');
      
      subplot(2,3,2);
      bar(tbin,ccg(:,1,2)); axis tight
      title('cross-correlation');
      
      subplot(2,3,5)
      %hist(dT(badpos),61); axis tight
      hist(dT,61); axis tight
      title('time lag hist');
      
      %subplot(2,3,5)
      %hist(dT(~badpos),61); axis tight
      %title('run');
      
      if st>1
	subplot(2,3,3)
	plot(dT,lpos,'.');
	axis tight
	ylabel('position');
	
	subplot(2,3,6)
	hist2([dT lpos],31,20);
	xlabel('time lag'); ylabel('position');
      end
      waitforbuttonpress
      figure(st);clf
    end
  end
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
