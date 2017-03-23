function plotMazeRegionSpectrum(expBaseMat,controlBaseMatfileext,nchannels,channels,chanmat,badchannels,nFFT,nOverlap,WinLength,Fs,samescale,dbscale,removeexp)

if ~exist('trialTypesBool','var') | isempty(trialTypesBool)
    trialTypesBool = [1  0  1  0  0   0   0   0   0   0   0   0  0];
                   % lr rr rl ll lrp rrp rlp llp lrb rrb rlb llb xp
end
if ~exist('removeexp', 'var') | isempty(removeexp)
    removeexp = 0;
end

figure(1);
clf;
figure(2);
clf;
mazeLocationsBool = [0  0  0  1  0  0   0   0   0];
                  % rp lp dp cp ca rca lca rra lra
[expY, expF]=calcchanspectrum8(expBaseMat,fileext,nchannels,channels,nFFT,nOverlap,WinLength,Fs,removeexp,0,trialTypesBool,mazeLocationsBool);
[controlY, controlF]=calcchanspectrum8(controlBaseMat,fileext,nchannels,channels,nFFT,nOverlap,WinLength,Fs,removeexp,0,trialTypesBool,mazeLocationsBool);
if expF ~= controlF
    CONTROL_EXP_FREQS_NOT_SAME
end
y = expY./controlY;
color = [0 1 0];
lineWidth = 0.01;
plotchanspectrum(f,y,chanmat,badchannels,samescale,dbscale,color)
return
mazeLocationsBool = [0  0  0  0  1  0   0   0   0];
                  % rp lp dp cp ca rca lca rra lra
[y, f]=calcchanspectrum8(filebasemat,fileext,nchannels,channels,nFFT,nOverlap,WinLength,Fs,removeexp,0,trialTypesBool,mazeLocationsBool);
color = [1 0 0];
lineWidth = 0.01;
plotchanspectrum(f,y,chanmat,badchannels,samescale,dbscale,color)

                  
mazeLocationsBool = [0  0  0  0  0  1   1   0   0];
                  % rp lp dp cp ca rca lca rra lra
[y, f]=calcchanspectrum8(filebasemat,fileext,nchannels,channels,nFFT,nOverlap,WinLength,Fs,removeexp,0,trialTypesBool,mazeLocationsBool);
color = [.5 .5 .5];
lineWidth = 0.01;
plotchanspectrum(f,y,chanmat,badchannels,samescale,dbscale,color)
               

mazeLocationsBool = [0  0  0  0  0  0   0   1   1];
                  % rp lp dp cp ca rca lca rra lra
[y, f]=calcchanspectrum8(filebasemat,fileext,nchannels,channels,nFFT,nOverlap,WinLength,Fs,removeexp,0,trialTypesBool,mazeLocationsBool);
color = [0 0 1];
lineWidth = 0.01;
plotchanspectrum(f,y,chanmat,badchannels,samescale,dbscale,color)

return
mazeLocationsBool = [0  0  0  1  0  0   0   0   0];
                  % rp lp dp cp ca rca lca rra lra
[y, f]=calcchanspectrum8(filebasemat,fileext,nchannels,channels,nFFT,nOverlap,WinLength,Fs,removeexp,0,trialTypesBool,mazeLocationsBool);
color = [0 1 0];
lineWidth = 0.01;
plotchanspectrum(f,y,chanmat,badchannels,samescale,dbscale,color)
