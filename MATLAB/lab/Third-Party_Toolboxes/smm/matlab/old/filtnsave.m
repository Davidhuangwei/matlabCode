function filtnsave(filebase,fileext,nchannels,lowband,highband,forder,avgfilorder,savefilt,savepow)

sampl = 1250;

if ~exist('savefilt', 'var')
    savefilt = 0;
end
if ~exist('savepow', 'var')
    savepow = 0;
end

inname = [filebase fileext]


firfiltb = fir1(forder,[lowband/sampl*2,highband/sampl*2]);
avgfiltb = ones(avgfilorder,1)/avgfilorder;

%chan1 = channels(1:floor(length(channels)/2)); % break up number of channels for filtering to ease memory requirements
%chan2 = channels((floor(length(channels)/2)+1):end);

%thresholdbuffer = readmulti(inname,numchannel,channels);
thresholdbuffer = bload(inname, [nchannels inf],0, 'int16');
filtered_data = Filter0(firfiltb,thresholdbuffer'); % filtering
clear thresholdbuffer

if savefilt,
    outname = [filebase '_' num2str(lowband) '-' num2str(highband) 'Hz' fileext '.filt'];
    fprintf('Saving %s\n', outname);
    bsave(outname,filtered_data','int16');
end

if savepow,
    power = filtered_data.^2; 
    clear filtered_data;
    smoothpower = Filter0(avgfiltb,power); % averaging & 
    clear power;
    
    outname = [filebase '_' num2str(lowband) '-' num2str(highband) 'Hz' fileext '.100DBpow'];
    fprintf('Saving %s\n', outname);
    bsave(outname,1000*log10(smoothpower'),'int16');
end