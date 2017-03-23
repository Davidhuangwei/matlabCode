function [PeakRate] = Placeness(Rate,varargin)
[PLOT] = DefaultArgs(varargin,{1});
%%
%% IN : 
%%      Rate : rate matrix [time x cells]

%%% criteria #1 : PeakRate > k Hz
[PeakRate PRi]= max(Rate);

%%% criteria #2 : how much is above 10% of peak rate?
normRate = (Rate./repmat(PeakRate,size(Rate,1),1)>0.1);
Concentr = sum(normRate);

[k1 k2] = sort(PRi);
imagesc(normRate(:,k2)');
axis xy

for n=1:size(Rate,2)
  plot(Rate(:,n))
  Lines([],max(Rate(:,n))*0.1);
  
  th = max(Rate(:,n))*0.1;
  
  a = Rate(:,n) >= th;
  
  b1 = find(diff(a)==1);
  b2 = find(diff(a)==-1);
  
  c = sort([b1;b2]);
  
  if b1(1)>b2(1)
    c = [1;c];
  end
  
  if mod(length(c))
    c = [c;length(a)]
  end
  
  ck = reshape(c,2,length(c)/2)';
  
  Lines(ck(:,1));
  Lines(ck(:,2),[],'g');
  
end


keyboard