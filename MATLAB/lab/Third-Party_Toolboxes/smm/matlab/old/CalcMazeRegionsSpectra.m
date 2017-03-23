function [freqs,caY,cpY,rewY,retY,xpY,wpY,dpY,allY,allNoPortsY] = CalcMazeRegionsSpectra(fileBaseMat,fileext,nchannels,channels,nFFT,nOverlap,WinLength,Fs,NW,autoSave,tasktype,fileNameFormat,removeexp)
% function [freqs,caY,cpY,rewY,retY,xpY,wpY,dpY,allY,allNoPortsY] = calcMazeRegionSpectrum(fileBaseMat,fileext,nchannels,channels,nFFT,nOverlap,WinLength,Fs,NW,autoSave,tasktype,fileNameFormat,removeexp)
% calculates the power spectrum for each portion of the maze for each
% channel.

if ~exist('removeexp', 'var') | isempty(removeexp)
    removeexp = 0;
end


trialTypesBool = [0  0  0  0  0   0   0   0   0   0   0   0  1];
               % lr rr rl ll lrp rrp rlp llp lrb rrb rlb llb xp
mazeLocationsBool = [0  0  0  0  0  0   0   0   0];  
                  % rp lp dp cp ca rca lca rra lra
[xpY, xpF] = calcchanspectrum9(fileBaseMat,fileext,nchannels,channels,nFFT,nOverlap,WinLength,Fs,NW,removeexp,0,trialTypesBool,mazeLocationsBool);


trialTypesBool = [1  0  1  0  0   0   0   0   0   0   0   0  0];
               % lr rr rl ll lrp rrp rlp llp lrb rrb rlb llb xp
mazeLocationsBool = [1  1  0  0  0  0   0   0   0];  
                  % rp lp dp cp ca rca lca rra lra
[wpY, wpF]=calcchanspectrum9(fileBaseMat,fileext,nchannels,channels,nFFT,nOverlap,WinLength,Fs,NW,removeexp,0,trialTypesBool,mazeLocationsBool);


mazeLocationsBool = [0  0  1  0  0  0   0   0   0];  
                  % rp lp dp cp ca rca lca rra lra
[dpY, dpF]=calcchanspectrum9(fileBaseMat,fileext,nchannels,channels,nFFT,nOverlap,WinLength,Fs,NW,removeexp,0,trialTypesBool,mazeLocationsBool);


mazeLocationsBool = [0  0  0  1  0  0   0   0   0];
                  % rp lp dp cp ca rca lca rra lra
[cpY, cpF]=calcchanspectrum9(fileBaseMat,fileext,nchannels,channels,nFFT,nOverlap,WinLength,Fs,NW,removeexp,0,trialTypesBool,mazeLocationsBool);


mazeLocationsBool = [0  0  0  0  1  0   0   0   0];
                  % rp lp dp cp ca rca lca rra lra
[caY, caF]=calcchanspectrum9(fileBaseMat,fileext,nchannels,channels,nFFT,nOverlap,WinLength,Fs,NW,removeexp,0,trialTypesBool,mazeLocationsBool);

                  
mazeLocationsBool = [0  0  0  0  0  1   1   0   0];
                  % rp lp dp cp ca rca lca rra lra
[rewY, rewF]=calcchanspectrum9(fileBaseMat,fileext,nchannels,channels,nFFT,nOverlap,WinLength,Fs,NW,removeexp,0,trialTypesBool,mazeLocationsBool);
               

mazeLocationsBool = [0  0  0  0  0  0   0   1   1];
                  % rp lp dp cp ca rca lca rra lra
[retY, retF]=calcchanspectrum9(fileBaseMat,fileext,nchannels,channels,nFFT,nOverlap,WinLength,Fs,NW,removeexp,0,trialTypesBool,mazeLocationsBool);


mazeLocationsBool = [0  0  0  1  1  1   1   1   1];
                  % rp lp dp cp ca rca lca rra lra
[allNoPortsY allNoPortsF] = calcchanspectrum9(fileBaseMat,fileext,nchannels,channels,nFFT,nOverlap,WinLength,Fs,NW,removeexp,0,trialTypesBool,mazeLocationsBool);

mazeLocationsBool = [1  1  1  1  1  1   1   1   1];
                  % rp lp dp cp ca rca lca rra lra
[allY allF] = calcchanspectrum9(fileBaseMat,fileext,nchannels,channels,nFFT,nOverlap,WinLength,Fs,NW,removeexp,0,trialTypesBool,mazeLocationsBool);

if allF ~= cpF | allF ~= caF | allF ~= rewF | allF ~= retF | allF ~= xpF | allF ~= wpF | allF ~= dpF | allF ~= allNoPortsF
    FREQ_MATS_NOT_SAME
end

F = allF;

i = 'y';
if (autoSave == 0)
    while 1,
        i = input('Save to disk (yes/no)? ', 's');
        if strcmp(i,'yes') | strcmp(i,'no'), break; end
    end
end
if i(1) == 'n'
    counttrialtypes(fileBaseMat,1,trialTypesBool);
    return;
else
    trialsmat = counttrialtypes(fileBaseMat,1,trialTypesBool);     
    if fileNameFormat == 1,
        outname = [tasktype '_' fileBaseMat(1,1) fileBaseMat(1,2:4) fileBaseMat(1,5) fileBaseMat(1,6:8) ...
            '-' fileBaseMat(end,1) fileBaseMat(end,2:4) fileBaseMat(end,5) fileBaseMat(end,6:8)...
            fileext '_PowerSpectrumsWindowNW' num2str(NW) '.mat'];
    end
    if fileNameFormat == 0,
        outname = [tasktype '_' fileBaseMat(1,7) fileBaseMat(1,10:12) fileBaseMat(1,14) fileBaseMat(1,17:19) ...
            '-' fileBaseMat(end,7) fileBaseMat(end,10:12) fileBaseMat(end,14) fileBaseMat(end,17:19) ...
            fileext '_PowerSpectrumsWindowNW' num2str(NW) '.mat'];
    end
    if fileNameFormat == 2,
                outname = [tasktype '_' fileBaseMat(1,:) '-' fileBaseMat(end,8:10) ...
                    fileext '_PowerSpectrumsWindowNW' num2str(NW) '.mat'];
    end
    fprintf('Saving %s\n', outname);
    save(outname,'F','caY','cpY','rewY','retY','xpY','wpY','dpY','allY','allNoPortsY','nFFT','nOverlap','WinLength','Fs','NW','trialsmat');
end   

return
