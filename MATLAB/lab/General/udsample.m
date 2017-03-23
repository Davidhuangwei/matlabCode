% udsample(inname,outname,numchannel,resampldown, resamplup, offset)
% resampling program --- requires signal processing toolbox
% now can do both up and downsampling 
% built on the versio of sensay Hajime Hirase ... no warranty ..(sorry) (1999)
% this function passes anti aliasing low pass filter first
% to the data and then upsamples resampldown and downsample resamplup times

function udsample(inname,outname,numchannel,resampldown, resamplup, offset)

if nargin <4,
error('function udsample(inname,outname,num_channel,resample_down, resample_up)');
return
end
if nargin<5 || isempty(resamplup) %length(resampl)==1
	resamplup = 1; offset = 0;
end 
if nargin<6 
    offset = 0; 
end
if ischar(offset) offset = str2num(offset);  end

if ischar(numchannel)
    numchannel=str2num(numchannel);
end
if ischar(resamplup)
    resamplup=str2num(resamplup);
end
if ischar(resampldown)
    resampldown=str2num(resampldown);
end

% open input file and output file
datafile = fopen(inname,'r');
outfile = fopen(outname,'w');
%
buffersize = 2^18-mod(2^18, resampldown);
overlaporder   = 8;%lcm(8,resamplup);
overlaporder2  = overlaporder/2*resamplup;
overlaporder21 = overlaporder2+1;
obufsize = overlaporder * resampldown;
obufsize11 = obufsize - 1;

% the first buffer

[obuf,count] = fread(datafile,[numchannel,obufsize],'int16');
obuf = fliplr(obuf)-offset;
frewind(datafile);
[datasegment,count] = fread(datafile,[numchannel,buffersize],'int16');  
datasegment = datasegment - offset;

%append overlap chunk to avoid edge effect
datasegment2 = [obuf,datasegment]';
resampled =resample(datasegment2,resamplup,resampldown);

%the idea here is to save only middle portion unaffected by the edge
%effects
count2 = fwrite(outfile,resampled(overlaporder2*2+1:size(resampled,1)-overlaporder2,:)'+offset,'int16');
obuf = datasegment2(size(datasegment2,1)-obufsize11:size(datasegment2,1),:);
% do the rest

while ~feof(datafile),
  [datasegment,count] = fread(datafile,[numchannel,buffersize],'int16');   
  datasegment = datasegment - offset;
  datasegment2 = [obuf;datasegment'];
  resampled = resample(datasegment2,resamplup,resampldown);
  count2 = fwrite(outfile,resampled(overlaporder21:size(resampled,1)-overlaporder2,:)'+offset,'int16');
  obuf = datasegment2(size(datasegment2,1)-obufsize11:size(datasegment2,1),:);
end  

% add the last unprocessed portion 
resampled = resample(obuf,resamplup,resampldown);
count2 = fwrite(outfile,resampled(overlaporder21:end,:)'+offset,'int16');
fclose(outfile);

