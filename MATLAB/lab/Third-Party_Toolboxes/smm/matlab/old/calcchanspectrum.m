function [y, f]=calcchanspectrum(filebasemat,nchannels,channels,nFFT,Fs,WinLength)
[numfiles n] = size(filebasemat);
for i=1:numfiles
    inname = [filebasemat(i,:) '.eeg'];
    eeg = readmulti(inname,97,channels);
    for j=1:length(channels)
        [y1 f1 t1] = mtpsg(eeg(:,j),nFFT,Fs,WinLength);
        y2 = mean(y1,2);
        
        if ~exist('y','var'),
            y = zeros(length(f1),length(channels));
            t = zeros(length(channels));
            f = zeros(length(f1),length(channels));
        end
        
        if length(f1)~=length(f(:,j)),
            there_is_problem_f1_fj_not_equal
        end
        
        f(:,j)=f1;
            
        
        t1total = t1(end);
        
        y(:,j) = (y(:,j)*t(j)+y2*t1total)/(t(j)+t1total);
        
        t(j) = t(j)+t1total;
    end
end
return;
        