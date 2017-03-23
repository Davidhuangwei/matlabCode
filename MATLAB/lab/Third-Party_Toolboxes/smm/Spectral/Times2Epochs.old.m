% function epochs = Times2Epochs(times, timeWin)
function epochs = Times2Epochs(times, timeWin)

epochs = [times(1) 0];
for j=2:length(times)
    if (times(j) - times(j-1)) > timeWin
        epochs(end,2) = times(j-1) + timeWin;
        epochs = cat(1,epochs,[times(j) 0]);
    end
    if j==length(times)
        epochs(end,2) = times(j)+timeWin;
    end
end
    
return

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
