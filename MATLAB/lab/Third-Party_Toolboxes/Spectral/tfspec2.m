function spec = dispscec(data, NW, sr, padtime, freqrange);
    

if ndim(data ~= 3)
    data = tfspec(data, NW, sr, padtime, freqrange);
else
    
end;
nbpoints = size( data, 3);
imagesc(squeeze(log(spec(1,:,:)))');
set( gca, 'ydir', 'normal');
set( gca, 'ylim', freqrange);
totaltime = nbpoints/ sr;
%set( gca, 'xlim', [totaltime+NW(1)/2 totaltime-NW(1)/2]);

return;