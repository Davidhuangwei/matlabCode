% fir1 bandpass filter implementation for rc file 12 bit version
% (subtracts 2048 before filtering and adds 2048 before writing)
% Hajime Hirase ... no warranty..(sorry)  (1998)
% function
% firfilt2(inname,outname,numchannel,sampl,lowband,highband)
% or
% firfilt2(inname,outname,numchannel)
% in the latter case, 
%  sampl = 20000; % sampling rate (in Hz)
%  lowband = 800; % low pass 
%  highband = 8000; % high pass
% is assumed

function firfilt2mult(inname,outname,numchannel,sampl,lowband,highband)

if nargin <3,
error('firfilt(inname,outname,numchannel,sampl,lowband,highband)');
end
if nargin <4,
  sampl = 20000; % sampling rate (in Hz)
  lowband = 800; % low pass 
  highband = 8000; % high pass
end

forder = 50; % filter order has to be even; .. the longer the more
	     % selective, but the operation will be linearly slower
	     % to the filter order
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
filtered_data = filter(b,1,datasegment2);
count2 = fwrite(filtfile,filtered_data(overlap1:size(filtered_data,1),:)'+2048,'int16');
  overlapbuffer = datasegment2(size(datasegment2,1)-overlap11:size(datasegment2,1),:);
% disp([count,count2]);
  
% show the frequency and phase response

[h,w] = freqz(b,1,buffersize,sampl);

figure(1);
hold off;
subplot(4,2,1),plot(b);
title('filter function');
xlabel('time');
subplot(4,2,2),plot(w,unwrap(angle(h)));
title('filter characteristics - phase');
xlabel('frequency(Hz)');
ylabel('radian');
subplot(4,2,3),plot(w,abs(h));
title('filter characteristics - amplitude');
xlabel('frequency(Hz)');
subplot(4,2,4),plot(w,log10(abs(h))*20);
title('filter characteristics - log in dB');
xlabel('frequency(Hz)');
plotbuffer = buffersize/2;
subplot(4,1,3),plot([1:plotbuffer]/sampl,datasegment(1,1:plotbuffer));
title('sample raw data');
xlabel('time(s)');
axis([0,plotbuffer/sampl,min(datasegment(1,1:plotbuffer)),max(datasegment(1,1:plotbuffer))]);
subplot(4,1,4),plot([1:plotbuffer]/sampl,filtered_data(overlap1:plotbuffer+overlap,1));
title('sample filtered data');
xlabel('time(s)');
axis([0,plotbuffer/sampl,min(filtered_data(overlap1:plotbuffer+overlap,1)),max(filtered_data(overlap1:plotbuffer+overlap,1))]);

figure(1); % redraw


% do the rest 
while ~feof(datafile),
  fseek(datafile,-2*numchannel*overlap,0);
  datasegment = fread(datafile,[numchannel,buffersize],'int16')'-2048;
  filtered_data = 10*filter(b,1,datasegment)+2048;
  fwrite(filtfile,filtered_data(overlap1:end,:)','int16');
end  
 
% add the last unprocessed portion 

overlapbuffer = datasegment(size(datasegment,1)-overlap11: ...
			       size(datasegment,1),:);
datasegment2 = [overlapbuffer;flipud(overlapbuffer)];
filtered_data = filter(b,1,datasegment2);
fwrite(filtfile,filtered_data(overlap1:overlap1+overlap/2-1,:)'+2048,'int16');
    
fclose(datafile);
fclose(filtfile);

