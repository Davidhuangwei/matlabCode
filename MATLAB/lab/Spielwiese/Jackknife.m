function [m,s]=Jackknife(x)

l = length(x);

for n=1:length(x)
  y(n) = mean(x(~ismember([1:l],n)));
end

m = mean(y);
s = std(y);

return;