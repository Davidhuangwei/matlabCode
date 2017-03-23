function ny=STmatrix(y,t)
% function ny=STmatrix(y,t)
% ny=y([T+1:t(2):t(1)],:)
if length(t)<2
    ny=y(1:(end-t+1),:);
    for k=2:t
        ny=[ny,y(k:(end-t+k),:)];
    end
else
    for k=1:t(2):t(1)
        if k==1
            ny=y(1:t(2):(end-t(1)+1),:);
        else
            ny=[ny,y(k:t(2):(end-t(1)+k),:)];
        end
    end
end