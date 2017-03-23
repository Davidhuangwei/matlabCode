function [t, SRate, d, MSRateD] = AvRate(sptime,spind,spdist,dist,varargin)
% function [t, ratet, d, rated] = AvRate(sptime,spind,spdist,varargin)
% [trials,EegRate] = DefaultARgs(varargin,{[],1250});
%
% IN: 
%    sptime : spike time (EegRate)
%    spind  : spike identification (cell number)
%    spdist : spike position on the track (linearized)
%    
% optional:
%    trials : [beginnin end] of trials - if empty sptime is used (EegRate)
%    EegRate: sampling rate of Eeg (default 1250)
%    dt     : time bin [ms]
%    ds     : distance bin [cm]
%
% 
% OUT:
%    t, ratet  : rate averaged over trials vs time (sec)
%    d, rated  : rate averaged over trials vs distance
%
[trials,EegRate,dt,ds,SmoothT,SmoothD] = DefaultArgs(varargin,{[],1250,100,10,10,30});

%% sort spike-time into trials
if isempty(trials)
  SPT = sptime;
  TR = ones(size(sptime));
  indx = find(SPT);
else
  TR = ones(size(sptime));
  SPT = sptime;
  for n=1:size(trials,1)
    idx = find(sptime>=trials(n,1));
    SPT(idx,1) = sptime(idx,1) - trials(n,1) + 1;
    TR(idx) = TR(idx) +1; 
  end
  indx = find(WithinRanges(sptime,trials));
end

%% rate vs time
X = round(SPT(indx)/EegRate*1000/dt);
X(find(X==0)) = 1;
Y = spind(indx);
msize = [max(X) max(Y)];
asize = prod(size(msize));

Rate = Accumulate([X Y],1,msize)/size(trials,1)*1000/dt;
t = [min(X):max(X)]/1000*dt;

%% smooth rate
SRate = reshape(smooth(Rate,SmoothT,'lowess'),msize(1),msize(2));


%%%%%%%%%%%%%%%%%%%%
%% rate vs. position
mm = max(round(dist(find(WithinRanges([1:length(dist)],trials)))/ds));
my = max(spind);
for n=1:size(trials,1)
  %% spike count
  ix = find(WithinRanges(sptime,trials(n,:)));
  W = round(spdist(ix)/ds);
  W(find(W==0)) = 1;
  Y = spind(ix);
  Count(:,:,n) = Accumulate([W Y],1,[mm my]);
  
  %% occupacion count
  ix = [trials(n,1):trials(n,2)];
  Z = round(dist(ix)/ds);
  ix = find(Z>=min(W) & Z<=max(W));
  Occ(:,n) = Accumulate([Z(ix)],1,mm)/EegRate*ds;
end
%% Rate
RateD = Count./permute(repmat(Occ,[1 1 size(Count,2)]),[1 3 2]);

%% get rid of NaNs
for n=1:size(trials,1)
  RateD(find(Occ(:,n)==0),:,n) = 0;
end
d = [1:mm]*ds;

%% smooth rate
%for n=1:size(RateD,2)
%  SRateD(:,n) = smooth(RateD,30,'lowess');
%end
SRateD = reshape(smooth(RateD,30,'lowess'),size(RateD,1),size(RateD,2),size(RateD,3));

%% mean rate across trials
MSRateD = mean(SRateD,3);

PLOT = 1;
SORT = 1;
if PLOT 

  %gf = [1:end-20
	
  if SORT
    [rk1 rk2] = max(SRate(1:end-20,:));
    [rl1 rl2] = sort(rk2);
    [k1 k2] = max(MSRateD(1:end-20,:));
    [l1 l2] = sort(k2);
  else
    rl2 = [1:size(SRate,2)];
    l2 = [1:size(SRate,2)];
  end 
  
  figure(2364);clf;
  subplot(211)
  imagesc(t,[],unity(SRate(:,rl2))');
  axis xy;
  xlabel('time [sec]');
  ylabel('neuron number');
  
  subplot(212)
  imagesc(d,[],unity(MSRateD(:,l2))');
  axis xy
  xlabel('distance [cm????]');
  ylabel('neuron number');
  
end

return;

%% [t, ratet, d, rated] = AvRate(round(spike.t/16),spike.ind,wheel.dist);


