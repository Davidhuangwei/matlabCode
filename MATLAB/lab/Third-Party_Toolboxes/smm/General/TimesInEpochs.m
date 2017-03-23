% function TimesInEpochs(times,epochs)
function newTimes = TimesInEpochs(times,epochs)

newTimes = [];
for j=1:size(epochs,1)
    if size(times,2) == 1
        newTimes = cat(1,newTimes,times(find(times>=epochs(j,1) & times<=epochs(j,2))));
    else
        newTimes = cat(2,newTimes,times(find(times>=epochs(j,1) & times<=epochs(j,2))));
    end        
end
return