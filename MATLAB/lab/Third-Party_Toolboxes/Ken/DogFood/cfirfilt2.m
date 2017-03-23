% fir1 bandpass filter implementation for rc file 12 bit version
% (subtracts 2048 before filtering and adds 2048 before writing)
% Hajime Hirase ... no warranty..(sorry)  (1998)
% function
% firfilt2(inname,outname,numchannel,sampl,lowband,highband,forder,gain)
% or
% firfilt2(inname,outname,numchannel)
% in the latter case, 
%  sampl = 20000; % sampling rate (in Hz)
%  lowband = 800; % low pass 
%  highband = 8000; % high pass
%  gain = 1; % post-filter gain
% is assumed

function firfilt2(inname,outname,numchannel,sampl,lowband,highband,forder,gain)

% make input arguments numbers for compiler
numchannel = str2num(numchannel);
if nargin <4, sampl = 20000; else sampl = str2num(sampl); end
if nargin <5, lowband = 800; else lowband = str2num(lowband); end
if nargin <6, highband = 8000; else highband = str2num(highband); end
if nargin <7, forder = 50; else forder = str2num(forder); end
if nargin<8 gain = 1; else gain = str2num(gain); end;

forder = ceil(forder/2)*2; %make sure filter order is even 
buffersize = 4096; % buffer size ... the larger the faster, as long as
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

b = fir1(forder,[lowband/sampl*2,highband/sampl*2]);

% overlap buffer length;
overlap = forder;
overlap1 = overlap+1;
overlap11 = overlap-1;

% initial overlap buffer ... which is actually the mirror image
% of the initial portion ... make sure that you 'rewind' the file

overlapbuffer = fread(datafile,[numchannel,overlap/2],'int16');
overlapbuffer = overlapbuffer-2048;
frewind(datafile);
overlapbuffer = transpose(fliplr(overlapbuffer));

[datasegment,count] = fread(datafile,[numchannel,buffersize],'int16');
datasegment = datasegment - 2048;
datasegment2 = [overlapbuffer;datasegment'];
filtered_data = gain*filter(b,1,datasegment2);
count2 = fwrite(filtfile,filtered_data(overlap1:size(filtered_data,1),:)'+2048,'int16');
  overlapbuffer = datasegment2(size(datasegment2,1)-overlap11:size(datasegment2,1),:);
% disp([count,count2]);
  

% do the rest 
while ~feof(datafile),
  fseek(datafile,-2*numchannel*overlap,0);
  datasegment = fread(datafile,[numchannel,buffersize],'int16')'-2048;
  filtered_data = gain*filter(b,1,datasegment)+2048;
  fwrite(filtfile,filtered_data(overlap1:end,:)','int16');
end  
 
% add the last unprocessed portion 

overlapbuffer = datasegment(size(datasegment,1)-overlap11: ...
			       size(datasegment,1),:);
datasegment2 = [overlapbuffer;flipud(overlapbuffer)];
filtered_data = gain*filter(b,1,datasegment2);
fwrite(filtfile,filtered_data(overlap1:overlap1+overlap/2-1,:)'+2048,'int16');
    
fclose(datafile);
fclose(filtfile);

