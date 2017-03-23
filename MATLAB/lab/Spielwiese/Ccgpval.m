function [pval,t, prc]=Ccgpval(FileBase,T,Ind,SpPh,BinSize,HalfBins,SampleRate,varargin)
[Num,GSubset, Normalization, Epochs,overwrite] = DefaultArgs(varargin,{1000,unique(Ind),'hz',[],0});
%%
%% comput ccg and comput p-value from X shuffled/jiddered ccgs

%Num=2;
overwrite = 0;

if ~FileExists([FileBase '.ccgpval']) | overwrite

  %% conserving PHASE relationship
  ThPhase = InternThetaPh(FileBase);
  
  phaseTrial = WithinRanges([1:length(ThPhase.deg)]/32,Epochs,[1:size(Epochs,1)],'vector')';
  cellTrial = WithinRanges(T/512,Epochs,[1:size(Epochs,1)],'vector')';
  
  BinStep = 10;
  BIN = [0:BinStep:360];
  
  [histEeg binEeg] = histcI(ThPhase.deg*180/pi+180,BIN);
  [histCells binCells] = histcI(SpPh*180/pi,BIN);
  
  NewT = T;
  
  [ccg,t] = CCG(T,Ind,BinSize,HalfBins,SampleRate,GSubset,Normalization,Epochs*512);
  
  for n=1:Num
    fprintf([num2str(n) '... ']);
    
    for tr=1:size(Epochs,1)
      for b=1:length(BIN)-1
	goodphase = find(binEeg==b & phaseTrial==tr);
	goodspike = find(binCells==b & cellTrial==tr);
	NewT(goodspike) = goodphase(randsample(length(goodphase),length(goodspike)))*16;
      end
    end
    [ccgPV(:,:,:,n),t] = CCG(NewT,Ind,BinSize,HalfBins,SampleRate,GSubset,Normalization,Epochs*512);
  end
  
  for m1=1:size(ccgPV,1)
    for m2=1:size(ccgPV,2)
      for m3=m2:size(ccgPV,3)
	pval(m1,m2,m3) = length(find(sq(ccgPV(m1,m2,m3,:))<ccg(m1,m2,m3)))/Num;
      end
    end
  end
  
  %%% Figure
  figure(52354)
  subplot(311)
  bar(t,ccg(:,3,4))
  axis tight
  subplot(312)
  bar(t,sq(mean(ccgPV(:,3,4,:),4)))
  axis tight
  subplot(313)
  plot(t,pval(:,3,4))
  Lines([],[0.05 0.95]);
  axis tight
  ylim([0 1])
  
  save([FileBase '.ccgpval'],'pval','t','ccgPV','ccg')
else
  load([FileBase '.ccgpval'],'-MAT')
  
end

for m1=1:size(ccgPV,2)
  for m2=m1:size(ccgPV,3)
    for m3=1:size(ccgPV,1)
      prc(m3,m1,m2,:) = prctile(sq(ccgPV(m3,m1,m2,:)),[5 95]);
    end
  end
end
  

%keyboard

figure(52354)
subplot(311)
bar(t,ccg(:,1,2))
axis tight
subplot(312)
bar(t,sq(mean(ccgPV(:,1,2,:),4)))
axis tight
subplot(313)
plot(t,pval(:,1,2))
Lines([],[0.05 0.95]);
axis tight
ylim([0 1])

return;

%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%
%% 
%% Jitter spikes RANDOMLY and INDEPENDENTLY.
for n=1:Num
  [ccgPV(:,:,:,n),t] = CCG(T+(rand(size(T))-0.5)*SampleRate*0.5,Ind,BinSize,HalfBins,SampleRate,GSubset,Normalization,Epochs);
end

for m1=1:size(ccgPV,1)
  for m2=1:size(ccgPV,2)
    for m3=m2:size(ccgPV,3)
      pval(m1,m2,m3) = length(find(sq(ccgPV(m1,m2,m3,:))<ccg(m1,m2,m3)))/Num;
    end
  end
end

