function MonoStats(FileBase,spike,states)

load([FileBase '.mono-5_6_7_8'],'-MAT'); 

for n=1:size(mono.From.ElClu,1)
  n
  
  cellIDF = find(spike.clu(:,1) == mono.From.ElClu(n,1) & spike.clu(:,2) == mono.From.ElClu(n,2));
  cellIDT = find(spike.clu(:,1) == mono.To.ElClu(n,1) & spike.clu(:,2) == mono.To.ElClu(n,2));
  
  indx = find(spike.ind==cellIDF | spike.ind==cellIDT);
  

  statestype = unique(states.ind);
  for m=1:length(unique(states.ind))
    m
    
    goodstates = find(states.ind==statestype(m));
    [ccg, t] = CCG(spike.t(indx), spike.ind(indx), 10, 50, 20000,unique(spike.ind(indx)),'hz',states.itv(goodstates,:)*16);
    
    figure(m);clf
    subplot(221)
    bar(t,ccg(:,1,1));
    title(states.info{m});
    axis tight
    
    subplot(223)
    bar(t,ccg(:,1,2));
    title(states.info{m});
    axis tight
    
    subplot(224)
    bar(t,ccg(:,2,2));
    title(states.info{m});
    axis tight
  
  end
  
  [ccg, t] = CCG(spike.t(indx), spike.ind(indx), 10, 50, 20000,unique(spike.ind(indx)),'hz',[states.itv(1,1) states.itv(end,2)]*16);
  
  figure(m+1);clf
  subplot(221)
  bar(t,ccg(:,1,1));
  title('whole day')
  axis tight
      
  subplot(223)
  bar(t,ccg(:,1,2));
  title('whole day')
  axis tight
  
  subplot(224)
  bar(t,ccg(:,2,2));
  title('whole day')
  axis tight

  
  waitforbuttonpress
  
end



return;