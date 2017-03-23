
TT = ALL(f).PhTSp.t*1250;
AA = size(ALL(f).PhTSp.y,2);
LL = 2^11;
SpT = round(spike.t(find(spike.good))/16);
for NN = 1:length(TT)
  %XX = find(WithinRanges(round(spike.t(find(spike.good))/16),[TT(NN)-LL/2 TT(NN)+LL/2]));
  XX = find(SpT >TT(NN)-LL/2 & SpT <= TT(NN)+LL/2);
  if isempty(XX)
    Count(NN,:) = zeros(AA,1)';
  else
    Count(NN,:) = histcI(spike.ind(XX),[1:AA+1]-0.5);
    %xNN
  end
  
  if mod(NN,500)==0
    fprintf([num2str(NN) ' ..... ']);
  end
end
