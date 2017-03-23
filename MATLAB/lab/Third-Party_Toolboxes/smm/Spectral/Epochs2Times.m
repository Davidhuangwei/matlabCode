% function times = Epochs2Times(epochs, timeWin)
function times = Epochs2Times(epochs, timeWin)

times = [];
for j=1:size(epochs,1)
    times = cat(1,times,[ceil(epochs(j,1)/timeWin)*timeWin:timeWin:floor(epochs(j,2)/timeWin)*timeWin-timeWin]');
end
return
