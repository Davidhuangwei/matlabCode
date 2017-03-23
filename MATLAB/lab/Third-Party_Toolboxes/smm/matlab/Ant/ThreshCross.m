%function CrossTimes = ThreshCross(x, Thresh, MinInterval)
function CrossTimes = ThreshCross(x, Thresh, MinInterval)

dx = diff(x>Thresh);
%hoping there is no touching
left = find(dx==1);
right = find(dx ==-1);
if right(end)<left(end)
    right(end+1)=length(x);
end
if right(1)<left(1)
    left = [1; left(:)];
end
% length(left) ~= length(right)


CrossTimes = [left(:) right(:)];
LongInt = find(diff(CrossTimes, 1,2) > MinInterval);
CrossTimes = CrossTimes(LongInt,:);

