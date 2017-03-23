% function epochs = Times2Epochs(times, timeWin)
function epochs = Times2Epochs(times, timeWin)

times = sort(times);

if length(times)<1
    epochs = [];
else
    epochs = [times(1) NaN];%% add 1st start epoch value
    if length(times)==1
        epochs(end,2) = times(1)+timeWin; %% add last finish epoch value
    else
        for j=2:length(times)
            if (times(j) - times(j-1)) > timeWin
                epochs(end,2) = times(j-1) + timeWin; %% add finish epoch value
                epochs = cat(1,epochs,[times(j) NaN]); %% add start epoch value
            end
            if j==length(times)
                epochs(end,2) = times(j)+timeWin; %% add last finish epoch value
            end
        end
    end
end
return

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
