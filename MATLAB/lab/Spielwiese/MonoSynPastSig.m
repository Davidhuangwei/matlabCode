function   signif   =  MonoSynPastSig(spike,mono,type,states,varargin)
[overwrite,PLOT,selstate] = DefaultArgs(varargin,{0,0,2});

%keyboard

nmono = size(mono.From.ElClu,1);
f = 0;
for m=1:nmono
  
  %% find pre- and postsyn cell
  indPre = find(type.elec==mono.From.ElClu(m,1) & type.cell==mono.From.ElClu(m,2));
  indPost = find(type.elec==mono.To.ElClu(m,1) & type.cell==mono.To.ElClu(m,2));
  
  indpre = find(spike.ind==indPre);
  indpost = find(spike.ind==indPost);

  idx = ismember(spike.ind,[indPre indPost]) & WithinRanges(round(spike.t/16),states.itv(find(states.ind==selstate),:)) & spike.good;
  
  %% significance of ccg
  Randomize.Type = 'jitter';
  Randomize.nRand = 1000;
  Randomize.Tau = 60;
  Randomize.Alpha = [5 95];
    
  if selstate==2
    %% ON RUNNING TRACK - select directions   
    
    %% separate directions
    for dire = unique(spike.dir(find(idx)))'
      
      dire
      if dire<2
	continue
      end
      
      figure(dire);clf
      
      myind = find(idx & spike.dir==dire); 
      if isempty(myind)
	continue;
      end
      
      myRes = spike.t(myind);
      myClu = spike.ind(myind);
      myPos = spike.lpos(myind);
      
      if 1%xxx
	out = CCGSignif(myRes,myClu,20,30,20000,'count',[indPre indPost],Randomize,10);
	if ~isfield('out','tbin');
	  out.tbin = [-20*30:20:20*30]/20;
	end
	out.tbin = reshape(out.tbin,max(size(out.tbin)),1);
	
	sigbin = find(out.PvalShufCCG<0.01 & out.tbin>0);
	if isempty(sigbin)
	  sig = [];
	else
	  sig = [min(out.tbin(sigbin))-mean(diff(out.tbin))/2 max(out.tbin(sigbin))+mean(diff(out.tbin))/2];
	end
	
	if PLOT
	  figure(3241+dire);clf
	  subplot(211)
	  bar(out.tbin,out.CCG)
	  hold on
	  plot(out.tbin,out.smCCG,'b','LineWidth',2)
	  plot(out.tbin,out.AvShufCCG,'r','LineWidth',2)
	  plot(out.tbin,out.AvShufCCG+out.StdShufCCG,'--r','LineWidth',1)
	  plot(out.tbin,out.AvShufCCG-out.StdShufCCG,'--r','LineWidth',1)
	  if ~isempty(sig)
	    ShadeArea(sig,[]);
	  end
	  subplot(212)
	  plot(out.tbin,out.PvalShufCCG,'b','LineWidth',2)
	  hold on
	  plot(out.tbin,0.01*ones(size(out.tbin)),'--k')
	end
	
       else
	 out=[];
      end
      
      %% count and identify
      f=f+1;
      signif(f).ind = [indPre indPost dire];
      signif(f).out = out;
      signif(f).sig = sig;
    end
    
    
  else 
    %% NOT ON TRACK  
    myind = find(idx);
    myRes = spike.t(myind);
    myClu = spike.ind(myind);
    myPos = spike.lpos(myind);
    
    out = CCGSignif(myRes,myClu,20,30,20000,'count',[indPre indPost],Randomize,10);
    if ~isfield('out','tbin');
      out.tbin = [-20*30:20:20*30]/20;
    end
    out.tbin = reshape(out.tbin,max(size(out.tbin)),1);
    
    sigbin = find(out.PvalShufCCG<0.01 & out.tbin>0);
    if isempty(sigbin)
      sig = [];
    else
      sig = [min(out.tbin(sigbin))-mean(diff(out.tbin))/2 max(out.tbin(sigbin))+mean(diff(out.tbin))/2];
    end
	
    if PLOT
      figure(3241);clf
      subplot(211)
      bar(out.tbin,out.CCG)
      hold on
      plot(out.tbin,out.smCCG,'b','LineWidth',2)
      plot(out.tbin,out.AvShufCCG,'r','LineWidth',2)
      plot(out.tbin,out.AvShufCCG+out.StdShufCCG,'--r','LineWidth',1)
      plot(out.tbin,out.AvShufCCG-out.StdShufCCG,'--r','LineWidth',1)
      if ~isempty(sig)
	ShadeArea(sig,[]);
      end
      subplot(212)
      plot(out.tbin,out.PvalShufCCG,'b','LineWidth',2)
      hold on
      plot(out.tbin,0.01*ones(size(out.tbin)),'--k')
    end
    
    %% count and identify
    f=f+1;
    signif(f).ind = [indPre indPost 0];
    signif(f).out = out;
    signif(f).sig = sig;
  end
  
end
return;