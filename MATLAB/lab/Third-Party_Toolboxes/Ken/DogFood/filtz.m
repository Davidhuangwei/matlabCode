% fir1 bandpass filter implementation for rc file
% Hajime Hirase ... no warranty..(sorry)  (1998)
% modified in two ways: 1: subtract mean out of filter impulse response
% to ensure good behaviour at low frequencies
% 2 - now it's a high pass, not band pass filter
%
% function
% firfilt(inname,outname,numchannel,sampl,cutoff,forder)
% or
% firfilt(inname,outname,numchannel)
% in the latter case, 
%  sampl = 20000; % sampling rate (in Hz)
%  cutoff = 800;
% is assumed

  
function firfilt(inname,outname,numchannel,sampl,cutoff,forder)

% make input arguments numbers for compiler
numchannel = str2num(numchannel);
sampl = str2num(sampl);
cutoff = str2num(cutoff);
forder = str2num(forder);

forder = ceil(forder/2)*2; %make sure filter order is even 
buffersize = 16384; % buffer size ... the larger the faster, as long as
                   % (real) memory can cover it.

% specify input and output file

datafile = fopen(inname,'r');
filtfile = fopen(outname,'w');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% changing something below this line will result in changing the
% algorithm (i.e. not the parameter)                       
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% %
% calculate the convolution function (passbands are normalized to
% the Nyquist frequency 

b = fir1(forder,cutoff/sampl*2, 'high');
% subtract off mean
b = b - mean(b);

% overlap buffer length;
overlap = forder;
overlap1 = overlap+1;
overlap11 = overlap-1;

% initial overlap buffer ... which is actually the mirror image
% of the initial portion ... make sure that you 'rewind' the file

overlapbuffer = fread(datafile,[numchannel,overlap/2],'int16');
frewind(datafile);
overlapbuffer = transpose(fliplr(overlapbuffer));

[datasegment,count] = fread(datafile,[numchannel,buffersize],'int16');
datasegment2 = [overlapbuffer;datasegment'];
filtered_data = filter(b,1,datasegment2);
count2 = fwrite(filtfile,filtered_data(overlap1:size(filtered_data,1),:)','int16');
  overlapbuffer = datasegment2(size(datasegment2,1)-overlap11:size(datasegment2,1),:);
% disp([count,count2]);


% do the rest (this routine can be made faster, if you use
% intial and final conditions of filter. (in fact, the programming
% would be much cleaner.  I should have done it., but now this
% works and I don't want to stir any more.. (sorry)

while ~feof(datafile),
  fseek(datafile,-2*numchannel*overlap,0);
  datasegment = fread(datafile,[numchannel,buffersize],'int16')';
  filtered_data = filter(b,1,datasegment);
  fwrite(filtfile,filtered_data(overlap1:end,:)','int16');
end  
 
% add the last unprocessed portion 

overlapbuffer = datasegment(size(datasegment,1)-overlap11: ...
			       size(datasegment,1),:);
datasegment2 = [overlapbuffer;flipud(overlapbuffer)];
filtered_data = filter(b,1,datasegment2);
fwrite(filtfile,filtered_data(overlap1:overlap1+overlap/2-1,:)','int16');
    
fclose(datafile);
fclose(filtfile);






























































