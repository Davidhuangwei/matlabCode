function CF(FileName, totalChannels, channels, BufSize, Window, IfShow)
% runs the CleanData of Gersteins lab 
% on file in chunks and saves it in file with the 
% name FileName.cln
global ptspercut;	
global prepts;				% additional points before threshold detection to replace
global postpts;			% additional points after return under threshold to replace

[n, nChannels] = size(channels);
ptspercut = BufSize;
prepts = Window;
postpts = Window;
inname = FileName;
outname = [FileName '.cln'];
pcname = [FileName '.pc'];
bytespersample = 2;
totalsmpls = FileLength(inname)/bytespersample/totalChannels;

% open input file and output file
outfile = fopen(outname,'wb');
pcfile = fopen(pcname,'wb');
datafile = fopen(inname,'r');

nBufs =floor(totalsmpls/BufSize); % # of full buffers

for i=1:(nBufs+1)
    beg = (i-1)*BufSize*totalChannels*bytespersample; % start point for reading file
    if i > nBufs  % if all the full buffers have been read, get the remaining data
        curbuf = mod(totalsmpls,BufSize);
    else
        curbuf = BufSize;
    end
    status = fseek(datafile, beg, -1);
   [datasegment,count] = fread(datafile,[totalChannels,curbuf],'int16');  
    resampled = CleanData2(datasegment(channels,:),IfShow); % CleanData outputs a [time, channels+2] matrix where extra 2 channels are the PCs
    datasegment(channels,:) = resampled(:,1:nChannels).';
    count2 = fwrite(outfile,datasegment,'int16');
    count3 = fwrite(pcfile,resampled(:,nChannels+1:nChannels+2).','int16'); % PCs are written to a separate file
end

fclose(datafile);
fclose(outfile);
fclose(pcfile);
