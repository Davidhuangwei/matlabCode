function [minimaTimes] = FindMinima(data,minimaIntervals)
[m n] = size(minimaIntervals);
minimaTimes = zeros(m,1);
for i = 1:m
    minimaTimes(i) = find(data == min(data(minimaIntervals(i,1):minimaIntervals(i,2))));
end
return