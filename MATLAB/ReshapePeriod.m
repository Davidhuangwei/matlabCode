function nP=ReshapePeriod(Period)
lp=size(Period,1);
LP=(Period(:,2)-Period(:,1))'*triu(ones(lp));
nP=[[1:lp]+[0,LP(1:(end-1))];[1:lp]+LP]';