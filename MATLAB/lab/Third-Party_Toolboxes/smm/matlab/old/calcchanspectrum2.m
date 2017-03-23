function [y, f]=calcchanspectrum2(filebasemat,nchannels,channels,nFFT,nOverlap,WinLength,Fs)
[numfiles n] = size(filebasemat);
for i=1:numfiles
    inname = [filebasemat(i,:) '.eeg'];
    fprintf('loading %s...\n',inname);
  
    eeg = bload(inname,[nchannels inf],0,'int16');
   
    [n t1] = size(eeg);   
  
    for j=1:length(channels)
        [y1 f1] = spectrum(eeg(j,:),nFFT,nOverlap,WinLength,Fs);
        
        if ~exist('y','var'),
            y = zeros(length(f1),length(channels));
            t = 0;
            f = f1;
        end
        
        if length(f1)~=length(f),
            there_is_problem_f1_f_not_equal
        end
            
        y(:,j) = (y(:,j)*t + y1(:,1)*t1)/(t+t1);

    end
    t = t + t1;
end
return;
        