clear data
filename = 'g3509-005.eeg';
dur = 100;

fid = fopen(filename,'r')
data = fread(fid,[21,dur*1250],'short');
fclose(fid);
ndata = data(2:4:20,:);
tic;spec = tfspec(ndata,[1,3],1250);toc

tic;tfsp =tfspec(ndata(1,:),[.5,4],1250,0.05,200);toc


--------------------------------------------------------

>> pwd

ans =

/data/guest1/george

>> ls

ans =

g3509-005.eeg  g3509.m1m2.1  g3509.m1m2.3  g3509.m1m2.5  g3509.mm.2  g3509.mm.4  Placefield22.m  Placefield2.m	 Placefield32.m  Record1.mat  Track
g3509.eeg      g3509.m1m2.2  g3509.m1m2.4  g3509.mm.1	 g3509.mm.3  g3509.mm.5  Placefield29.m  Placefield2.m~  Placefield.m	 Spectral     tracking.m


>> fid=fopen('g3509-005.eeg','r')

fid =

     3

>> data = fread(fid,[21,1250*10],'short');
>> plot(data(1,1:1e3))
>> 
>> 
>> plot(data(:,1:1e3)')
>> plot(data(21,:)')
>> plot(data(20,:)')
>> plot(data(19,:)')
>> plot(data(18,:)')
>> plot(data(1:10,:)')
>> plot(data(11:15,:)')
>> plot(data(16,:)')
>> plot(data(17,:)')
>> plot(data(18,:)')
>> plot(data(19,:)')
>> plot(data(20,:)')
>> plot(data(12,:)')
>> plot(data(:,:)')
>> plot(data(1:10,:)')
>> plot(data(1:5,:)')
>> plot(data(1:4,:)')
>> plot(data(5,:)')
>> mean(data(5,:)')

ans =

  -2.0879e+04

>> ndata = data(2:4:20,:);
>> fid=fopen('g3509-005.eeg',
filename = 'g3509-005.eeg';
dur = 100;

fid = fopen(filename,'r')
data = fread(fid,[21,dur*1250],'short');
fclose(fid);
ndata = data(2:4:20,:);
??? fid=fopen('g3509-005.eeg',
                              |
Error: Expected a variable, function, or constant, found "end of line".

>> 
filename = 'g3509-005.eeg';
dur = 100;

fid = fopen(filename,'r')
data = fread(fid,[21,dur*1250],'short');
fclose(fid);
ndata = data(2:4:20,:);

fid =

     3

>> whos ndata
  Name        Size           Bytes  Class

  ndata       5x125000     5000000  double array

Grand total is 625000 elements using 5000000 bytes

>> plot(ndata(:,:1e3))
??? plot(ndata(:,:1e3))
                  |
Error: ")" expected, "numeric value" found.

>> plot(ndata(:,1:1e3)')
>> plot(ndata(:,1:5e3)')
>> addpath('Spectral')
>> help dmtspec

  DMTSPEC calculates the direct multitaper spectral estimate for time series.
 
  [SPEC, F, ERR] = DMTSPEC(X, TAPERS, SAMPLING, FK, PAD, PVAL, FLAG)
 
   Inputs:  X		=  Time series array in [Space/Trials,Time] form.
 	    TAPERS 	=  Data tapers in [K,TIME], [N,P,K] or [N,W] form.
 			   	Defaults to [N,3,5] where N is duration of X.
 	    SAMPLING 	=  Sampling rate of time series X in Hz. 
 				Defaults to 1.
 	    FK 	 	=  Frequency range to return in Hz in
                                either [F1,F2] or [F2] form.  
                                In [F2] form, F1 is set to 0.
 			   	Defaults to [0,SAMPLING/2]
 	    PAD		=  Padding factor for the FFT.  
 			      	i.e. For N = 500, if PAD = 2, we pad the FFT 
 			      	to 1024 points; if PAD = 4, we pad the FFT
 			      	to 2048 points.
 				Defaults to 2.
 	   PVAL		=  P-value to calculate error bars for.
 				Defaults to 0.05 i.e. 95% confidence.
 
 	   FLAG = 0:	calculate SPEC seperately for each channel/trial.
 	   FLAG = 1:	calculate SPEC by pooling across channels/trials. 
 
   Outputs: SPEC	=  Spectrum of X in [Space/Trials, Freq] form.
 	    F		=  Units of Frequency axis for SPEC.
 	    ERR 	=  Error bars for SPEC in [Hi/Lo, Space/Trials, Freq]
 			   form given by a Jacknife-t interval for PVAL.
 

>> help dmtspec

  DMTSPEC calculates the direct multitaper spectral estimate for time series.
 
  [SPEC, F, ERR] = DMTSPEC(X, TAPERS, SAMPLING, FK, PAD, PVAL, FLAG)
 
   Inputs:  X		=  Time series array in [Space/Trials,Time] form.
 	    TAPERS 	=  Data tapers in [K,TIME], [N,P,K] or [N,W] form.
 			   	Defaults to [N,3,5] where N is duration of X.
 	    SAMPLING 	=  Sampling rate of time series X in Hz. 
 				Defaults to 1.
 	    FK 	 	=  Frequency range to return in Hz in
                                either [F1,F2] or [F2] form.  
                                In [F2] form, F1 is set to 0.
 			   	Defaults to [0,SAMPLING/2]
 	    PAD		=  Padding factor for the FFT.  
 			      	i.e. For N = 500, if PAD = 2, we pad the FFT 
 			      	to 1024 points; if PAD = 4, we pad the FFT
 			      	to 2048 points.
 				Defaults to 2.
 	   PVAL		=  P-value to calculate error bars for.
 				Defaults to 0.05 i.e. 95% confidence.
 
 	   FLAG = 0:	calculate SPEC seperately for each channel/trial.
 	   FLAG = 1:	calculate SPEC by pooling across channels/trials. 
 
   Outputs: SPEC	=  Spectrum of X in [Space/Trials, Freq] form.
 	    F		=  Units of Frequency axis for SPEC.
 	    ERR 	=  Error bars for SPEC in [Hi/Lo, Space/Trials, Freq]
 			   form given by a Jacknife-t interval for PVAL.
 

>> help tfspec

 TFSPEC  Moving window time-frequency spectrum using multitaper techniques.
 
  [SPEC, F, ERR] = TFSPEC(X, TAPERS, SAMPLING, DN, FK, PAD, PVAL, FLAG) 
 
   Inputs:  X		=  Time series array in [Space/Trials,Time] form.
 	    TAPERS 	=  Data tapers in [K,TIME], [N,P,K] or [N,W] form.
 			   	Defaults to [N,3,5] where N is NT/10
 				and NT is duration of X. 
 	    SAMPLING 	=  Sampling rate of time series X in Hz. 
 				Defaults to 1.
 	    DN		=  Overlap in time between neighbouring windows.
 			       	Defaults to N./10;
 	    FK 	 	=  Frequency range to return in Hz in
                                either [F1,F2] or [F2] form.  
                                In [F2] form, F1 is set to 0.
 			   	Defaults to [0,SAMPLING/2]
 	    PAD		=  Padding factor for the FFT.  
 			      	i.e. For N = 500, if PAD = 2, we pad the FFT 
 			      	to 1024 points; if PAD = 4, we pad the FFT
 			      	to 2048 points.
 				Defaults to 2.
 	   PVAL		=  P-value to calculate error bars for.
 				Defaults to 0.05 i.e. 95% confidence.
 
 	   FLAG = 0:	calculate SPEC seperately for each channel/trial.
 	   FLAG = 1:	calculate SPEC by pooling across channels/trials. 
 
   Outputs: SPEC	=  Spectrum of X in [Space/Trials, Time, Freq] form. 
 	    F		=  Units of Frequency axis for SPEC.
 	    ERR 	=  Error bars in[Hi/Lo, Space, Time, Freq]  
 			   form given by the Jacknife-t interval for PVAL.
  
    See also DPSS, PSD, SPECGRAM.

>> whos ndata
  Name        Size           Bytes  Class

  ndata       5x125000     5000000  double array

Grand total is 625000 elements using 5000000 bytes

>> tic;spec = tfspec(ndata,[1,3],1250);toc
Using 5 tapers.
Calculating tapers ... 
	... Done

elapsed_time =

  203.5488

>> whos spec
  Name       Size           Bytes  Class

  spec       5x990x2048  81100800  double array

Grand total is 10137600 elements using 81100800 bytes

>> addpath('/mnt/data/and10/arno/Spectral')
>> tvimage(log(spec(1,:,:)))
>> plot(squeeze(log(mean(spec(1,:,:)))))
>> 2.^16

ans =

       65536

>> plot(ndata(1,1:1e3))
>> spec =dmtspec(ndata(1,1:1250),[1,3],1250);
Using 5 tapers.
Calculating tapers ... 
	... Done
>> semilogy(spec)
>> [spec,f,err] =dmtspec(ndata(1,1:1250),[1,3],1250);
Using 5 tapers.
Calculating tapers ... 
	... Done
>> semilogy(f,spec)
>> hold;
Current plot held
>> semilogy(f,err)
??? Error using ==> semilogy
Data may not have more than 2 dimensions.

>> whos err
  Name      Size           Bytes  Class

  err       2x1x2048       32768  double array

Grand total is 4096 elements using 32768 bytes

>> err = squeeze(err);
>> semilogy(f,err)
>> semilogy(f,spec)
>> clf
>> clf
>> semilogy(f,spec)
>> hold;
Current plot held
>> semilogy(f,err,'r')
>> [spec2,f2,err2] =dmtspec(ndata(1,1:1250*2),[2,3],1250);
Using 11 tapers.
Calculating tapers ... 
	... Done
>> semilogy(f2,spec2,'g')
>> semilogy(f2,squeeze(err2),'m')
>> [spec3,f3,err3] =dmtspec(ndata(1,1:1250),[1,6],1250);
Using 11 tapers.
Calculating tapers ... 
	... Done
>> semilogy(f3,spec3,'c')
>> [spec4,f4,err4] =dmtspec(ndata(1,1:1250./2),[.5,3],1250);
Using 2 tapers.
Calculating tapers ... 
Warning:  K is less than 3
	... Done
>> semilogy(f4,spec4,'k')
>> [spec5,f5,err5] =dmtspec(ndata(1,1:1250./4),[.25,6],1250);
Warning: Integer operands are required for colon operator when used as index.
Using 2 tapers.
Calculating tapers ... 
Warning:  K is less than 3
Warning: Size vector should be a row vector with integer elements.
> In /usr/local/matlab61/toolbox/signal/signal/dpss.m (dpsscalc) at line 122
  In /usr/local/matlab61/toolbox/signal/signal/dpss.m at line 52
  In /mnt/data/and10/arno/Spectral/dpsschk.m at line 37
  In /mnt/data/and10/arno/Spectral/dmtspec.m at line 55
Warning: Integer operands are required for colon operator when used as index.
> In /usr/local/matlab61/toolbox/signal/signal/dpss.m (dpsscalc) at line 154
  In /usr/local/matlab61/toolbox/signal/signal/dpss.m at line 52
  In /mnt/data/and10/arno/Spectral/dpsschk.m at line 37
  In /mnt/data/and10/arno/Spectral/dmtspec.m at line 55
???  Index exceeds matrix dimensions.

Error in ==> /usr/local/matlab61/toolbox/signal/signal/dpss.m (dpsscalc)
On line 154  ==>     q(:,blkind) = fftfilt(E(N:-1:1,blkind),E(:,blkind));

Error in ==> /usr/local/matlab61/toolbox/signal/signal/dpss.m
On line 52  ==>    [E,V] = dpsscalc(N,NW,k);

Error in ==> /mnt/data/and10/arno/Spectral/dpsschk.m
On line 37  ==> 		[e,v]=dpss(N,NW,'calc');

Error in ==> /mnt/data/and10/arno/Spectral/dmtspec.m
On line 55  ==>    tapers = dpsschk(tapers);

>> [spec5,f5,err5] =dmtspec(ndata(1,1:1250./4),[.3,6],1250);
Warning: Integer operands are required for colon operator when used as index.
Using 2 tapers.
Calculating tapers ... 
Warning:  K is less than 3
	... Done
??? Error using ==> dmtspec
Error:  Length of time series and tapers must be equal

>> [spec5,f5,err5] =dmtspec(ndata(1,1:500),[.4,6],1250);
Using 3 tapers.
Calculating tapers ... 
	... Done
>> [spec5,f5,err5] =dmtspec(ndata(1,1:300),[300./1250,6],1250);
Using 1 tapers.
Calculating tapers ... 
Warning:  K is less than 3
	... Done
Warning: Divide by zero.
> In /usr/local/matlab61/toolbox/matlab/datafun/mean.m at line 28
  In /mnt/data/and10/arno/Spectral/dmtspec.m at line 93
>> semilogy(f5,spec5,'y')
>> tic;tfsp =tfspec(ndata(1,:),[.5,4],1250,0.05);toc
Using 3 tapers.
Calculating tapers ... 
	... Done

elapsed_time =

   18.0644

>> tvimage(log(tfsp(1,:,:)))
>> clf
>> tvimage(log(tfsp(1,:,:)))
>> tic;tfsp =tfspec(ndata(1,:),[.5,4],1250,0.05,200);toc
Using 3 tapers.
Calculating tapers ... 
	... Done

elapsed_time =

   14.8949

>> tvimage(log(tfsp(1,:,:)))
>> tvimage(log(tfsp(1,:,:)),'YRange',[0,200])
>> whos tfsp
  Name       Size           Bytes  Class

  tfsp       1x1974x327   5163984  double array

Grand total is 645498 elements using 5163984 bytes

>> tfsp = squeeze(tfsp);
>> semilogy(mean(tfsp))
>> semilogy(f,mean(tfsp))
??? Error using ==> semilogy
Vectors must be the same lengths.

>> semilogy(f2,mean(tfsp))
??? Error using ==> semilogy
Vectors must be the same lengths.

>> semilogy(f4,mean(tfsp))
??? Error using ==> semilogy
Vectors must be the same lengths.

>> whos f
  Name      Size           Bytes  Class

  f         1x2048         16384  double array

Grand total is 2048 elements using 16384 bytes

>> whos tfsp
  Name       Size           Bytes  Class

  tfsp    1974x327        5163984  double array

Grand total is 645498 elements using 5163984 bytes

>> tic;tfsp =tfspec(ndata(1,:),[.5,3],1250,0.05,200);toc
Using 2 tapers.
Calculating tapers ... 
Warning:  K is less than 3
	... Done

elapsed_time =

   11.3312

>> semilogy(mean(tfsp))
??? Error using ==> semilogy
Data may not have more than 2 dimensions.

>> tfsp = squeeze(tfsp);
>> semilogy(mean(tfsp))
>> tic;tfsp =tfspec(ndata(:,:),[.5,3],1250,0.05,200);toc
Using 2 tapers.
Calculating tapers ... 
Warning:  K is less than 3
	... Done

elapsed_time =

   58.3920

>> semilogy(mean(tfsp))
??? Error using ==> semilogy
Data may not have more than 2 dimensions.

>> whos tfsp
  Name       Size           Bytes  Class

  tfsp       5x1974x327  25819920  double array

Grand total is 3227490 elements using 25819920 bytes

>> semilogy(squeeze(mean(tfsp,2)))
>> semilogy(squeeze(mean(tfsp,2))')
>> whos coherency
>> help coherency

  COHERENCY calculates the coherency between two time series, X and Y 
 
  [COH, F, S_X, S_Y,, COH_ERR, SX_ERR, SY_ERR] = ...
 	COHERENCY(X, Y, TAPERS, SAMPLING, FK, PAD, FLAG, PVAL)
 
   Inputs:  X		=  Time series array in [Space/Trials,Time] form.
 	    Y		=  Time series array in [Space/Trials,Time] form.
 	    TAPERS 	=  Data tapers in [K,TIME], [N,P,K] or [N, W] form.
 			   	Defaults to [N,5,9] where N is the duration 
 				of X and Y.
 	    SAMPLING 	=  Sampling rate of time series X, in Hz. 
 				Defaults to 1.
 	    FK 	 	=  Frequency range to return in Hz in
                                either [F1,F2] or [F2] form.  
                                In [F2] form, F1 is set to 0.
 			   	Defaults to [0,SAMPLING/2]
 	    PAD		=  Padding factor for the FFT.  
 			      	i.e. For N = 500, if PAD = 2, we pad the FFT 
 			      	to 1024 points; if PAD = 4, we pad the FFT
 			      	to 2048 points.
 				Defaults to 2.
 	    PVAL	=  P-value to calculate error bars for.
 				Defaults to 0.05 i.e. 95% confidence.
 
 	    FLAG = 0:	calculate COH seperately for each channel/trial.
 	    FLAG = 1:	calculate COH by pooling across channels/trials. 
 	    FLAG = 11 	calculation is done as for FLAG = 1 
 		but the error bars cannot be calculated to save memory.
 	   	Defaults to FLAG = 11.
 
   Outputs: COH		=  Coherency between X and Y in [Space/Trials,Freq].
                   F    =  Units of Frequency axis for COH
 	    S_X		=  Spectrum of X in [Space/Trials, Freq] form.
 	    S_Y		=  Spectrum of Y in [Space/Trials, Freq] form.
 	    COH_ERR 	=  Error bars for COH in [Hi/Lo, Space, Freq]
 			   form given by the Jacknife-t interval for PVAL.
  	    SX_ERR 	=  Error bars for S_X.
  	    SY_ERR 	=  Error bars for S_Y.
 

>> figure
>> coh = coherency(ndata(1,1:1250),ndata(2,1:1250),[1,10],1250);
Using 19 tapers.
Calculating tapers ... 
	... Done
>> plot(abs(coh))
>> coh = coherency(ndata(1,1:1250),ndata(2,1:1250),[1,10],1250,200);
Using 19 tapers.
Calculating tapers ... 
	... Done
>> plot(abs(coh))
>> plot(atanh(abs(coh)))
>> tic;coh = coherency(ndata(1,1:1250),ndata(2,1:1250*2),[2,10],1250,200);toc
??? Error using ==> coherency
Error: Time series are not the same length

>> tic;[coh,f] = coherency(ndata(1,1:1250*2),ndata(2,1:1250*2),[2,10],1250,200);toc
Using 39 tapers.
Calculating tapers ... 
	... Done

elapsed_time =

    3.6835

>> plot(f,atanh(abs(coh)))
>> plot(f,(abs(coh)))
>> plot(f,atanh(abs(coh)))
>> tic;[coh,f] = coherency(ndata(1,1:1250*5),ndata(2,1:1250*5),[5,3],1250,200);toc
Using 29 tapers.
Calculating tapers ... 
	... Done

elapsed_time =

    6.2970

>> plot(f,atanh(abs(coh)))
>> tic;[coh,f] = coherency(ndata(1,1:1250*5),ndata(3,1:1250*5),[5,3],1250,200);toc
Using 29 tapers.
Calculating tapers ... 
	... Done

elapsed_time =

    6.3133

>> hold;
Current plot held
>> pl
??? Undefined function or variable 'pl'.

>> plot(f,atanh(abs(coh)),'r')
>> tic;[coh,f] = coherency(ndata(1,1:1250*5),ndata(4,1:1250*5),[5,3],1250,200);toc
Using 29 tapers.
Calculating tapers ... 
	... Done

elapsed_time =

    6.2693

>> plot(f,atanh(abs(coh)),'g')
>> axis([0,200,0,2])
>> tic;[coh,f] = coherency(ndata(1,1:1250*5),ndata(5,1:1250*5),[5,3],1250,200);toc
Using 29 tapers.
Calculating tapers ... 
	... Done

elapsed_time =

    6.2801

>> plot(f,atanh(abs(coh)),'m')
>> tic;[coh,f] = coherency(ndata(4,1:1250*5),ndata(5,1:1250*5),[5,3],1250,200);toc
Using 29 tapers.
Calculating tapers ... 
	... Done

elapsed_time =

    6.2861

>> plot(f,atanh(abs(coh)),'k')
>> tic;[coh,f] = coherency(ndata(4,1:1250*5),ndata(2,1:1250*5),[5,3],1250,200);toc
Using 29 tapers.
Calculating tapers ... 
	... Done

elapsed_time =

    6.3073

>> plot(f,atanh(abs(coh)),'y');


---------------------------------

>> ls

ans =

Bijan_Thur.mat	g3509.m1m2.2  g3509.mm.2      Placefield29.m  Placefield.m
Bijan_Wed.m	g3509.m1m2.3  g3509.mm.3      Placefield2.m   Record1.mat
g3509-005.eeg	g3509.m1m2.4  g3509.mm.4      Placefield2.m~  Spectral
g3509.eeg	g3509.m1m2.5  g3509.mm.5      Placefield32.m  Track
g3509.m1m2.1	g3509.mm.1    Placefield22.m  Placefield3.m   tracking.m


>> whos fid
  Name      Size           Bytes  Class

  fid       1x1                8  double array

Grand total is 1 elements using 8 bytes

>> fidg=fopen('g3509-005.eeg','r');
>> datag=fread(fidg,[20,1250*20],'short');
>> fclose(fidg);
>> fidg=fopen('g3509-005.eeg','r');
>> datag=fread(fidg,[21,1250*20],'short');
>> fclose(fidg);
>> ndatag=datag(2:4:20,:);
>> tic;tfspec(ndatag(1,:),[5,3],1250);toc
Using 29 tapers.
Calculating tapers ... 
	... Done

elapsed_time =

   30.8606

>> tic;[sp,f]=tfspec(ndatag(1,:),[5,3],1250);toc
Using 29 tapers.
Calculating tapers ... 
	... Done

elapsed_time =

   36.1355

>> plot(sp);
??? Error using ==> plot
Data may not have more than 2 dimensions.

>> whos sp
  Name      Size           Bytes  Class

  sp        1x30x8192    1966080  double array

Grand total is 245760 elements using 1966080 bytes

>> whos f
  Name      Size           Bytes  Class

  f         1x8192         65536  double array

Grand total is 8192 elements using 65536 bytes

>> t
??? Undefined function or variable 't'.

>> tb
??? Undefined function or variable 'tb'.

>> t=[0:28]/2+2.5;
>> whos t
  Name      Size           Bytes  Class

  t         1x29             232  double array

Grand total is 29 elements using 232 bytes

>> t=[0:29]/2+2.5; %creating a time vector of the size 
    %equal to number of windows-1 divided by 2 + the 
    %center of the last interval (5/2=2.5)
>> whos t
  Name      Size           Bytes  Class

  t         1x30             240  double array

Grand total is 30 elements using 240 bytes

>> whos f
  Name      Size           Bytes  Class

  f         1x8192         65536  double array

Grand total is 8192 elements using 65536 bytes

>> imagesc(t,f,squeeze(10*log10(sp))')
>> imagesc(t,f,squeeze(10*log10(sp))');axis xy
>> imagesc(t,f,squeeze(10*log10(sp))');axis xy;colorbar
>> imagesc(t,f,squeeze(log10(sp))');axis xy;colorbar
>> help semilogy

 SEMILOGY Semi-log scale plot.
    SEMILOGY(...) is the same as PLOT(...), except a
    logarithmic (base 10) scale is used for the Y-axis.
 
    See also PLOT.

 Overloaded methods
    help demtseries/semilogy.m

>> help tvimage

   TVIMAGE displays images in a better way than imagesc
 
   TVIMAGE(IMAGE) displays the IMAGE in the proper orientation
   and allows you to edit the labels and ranges with a series
   of optional arguments:
 
   'XLabel' - String giving the text to label the X-axis
 
   'YLabel' - String giving the text to label the Y-Axis
  
   'XNTicks' - Integer giving the number of X tickmarks
 
   'YNTicks' - Integer giving the number of Y tickmarks
  
   'XRange' - Two element vector giving the minmax for the X-axis
  
   'YRange' - Two element vector giving the minmax for the Y-axis
 
   'CLim' - Two element vector giving the minmax for the color scale
 

>> tvimage(t,f,squeeze(log10(sp))')
??? Error using ==> set
Values must be monotonically increasing.

Error in ==> /mnt/data/and10/arno/Spectral/tvimage.m
On line 70  ==> set(gca,'XTick',xtickpos);

>> tvimage(squeeze(log10(sp))')
>> tvimage(squeeze(log10(sp)))
>> 
>> tvimage(squeeze(semilogy(sp)))
??? Error using ==> semilogy
Data may not have more than 2 dimensions.

>> tvimage(squeeze(log10(sp)));
--------------------
>> plot(squeeze(sp(:,:,:)));
>> plot(squeeze(sp(:,1,:)));
>> plot(squeeze(sp(:,2,:)));
>> plot(squeeze(sp(:,3,:)));
>> plot(squeeze(sp(:,4,:)));
>> plot(squeeze(sp(:,5,:)));
>> plot(squeeze(mean(sp(:,:))));
>> plot(squeeze(mean(sp(:,:,:))));
>> help mean

 MEAN   Average or mean value.
    For vectors, MEAN(X) is the mean value of the elements in X. For
    matrices, MEAN(X) is a row vector containing the mean value of
    each column.  For N-D arrays, MEAN(X) is the mean value of the
    elements along the first non-singleton dimension of X.
 
    MEAN(X,DIM) takes the mean along the dimension DIM of X. 
 
    Example: If X = [0 1 2
                     3 4 5]
 
    then mean(X,1) is [1.5 2.5 3.5] and mean(X,2) is [1
                                                      4]
 
    See also MEDIAN, STD, MIN, MAX, COV.

>> spq=squeeze(sp);
>> whos spq
  Name      Size           Bytes  Class

  spq      30x8192       1966080  double array

Grand total is 245760 elements using 1966080 bytes

>> spqmean=mean(spq);
>> whos spq
  Name      Size           Bytes  Class

  spq      30x8192       1966080  double array

Grand total is 245760 elements using 1966080 bytes

>> whos spqmean
  Name          Size           Bytes  Class

  spqmean       1x8192         65536  double array

Grand total is 8192 elements using 65536 bytes

>> spqmean=squeeze(mean(spq));
>> plot(spqmean)
>> tvimage(squeeze(log10(sp)))
>> imagesc(t,f,squeeze(log10(sp))');axis xy;colorbar
>> plot(f,spqmean)

-------------------------------------

>> fid=fopen('g3509-005.eeg','r');
>> whos
  Name      Size           Bytes  Class

  ans       1x352            704  char array
  fid       1x1                8  double array

Grand total is 353 elements using 712 bytes

>> data=fread(fid,[21,1250*120],'short');
>> fclose(fid);
>> ndata=data(2:4:20,:);
>> tic;[sp,f]=tfspec(ndata(:,:),[5,4],1250,1,[400]);toc
Using 39 tapers.
Calculating tapers ... 
	... Done

elapsed_time =

  655.3416

>> whos sp
  Name      Size           Bytes  Class

  sp        5x115x5242  24113200  double array

Grand total is 3014150 elements using 24113200 bytes

>> t=[0:115]/2+2.5;
>> whos t
  Name      Size           Bytes  Class

  t         1x116            928  double array

Grand total is 116 elements using 928 bytes

>> t=[0:114]/2+2.5;
>> whos t
  Name      Size           Bytes  Class

  t         1x115            920  double array

Grand total is 115 elements using 920 bytes

>> imagesc(t,f,squeeze(log10(sp))');axis xy;colorbar
??? Error using ==> '
Transpose on ND array is not defined.

>> imagesc(t,f,squeeze(log10(sp(1,:,:)))');axis xy;colorbar
>> figure;
>> imagesc(t,f,squeeze(log10(sp(2,:,:)))');axis xy;colorbar
>> help caxis

 CAXIS  Pseudocolor axis scaling.
    CAXIS(V), where V is the two element vector [cmin cmax], sets manual
    scaling of pseudocolor for the SURFACE and PATCH objects created by
    commands like MESH, PCOLOR, and SURF.  cmin and cmax are assigned
    to the first and last colors in the current colormap.  Colors for PCOLOR
    and SURF are determined by table lookup within this range.  Values
    outside the range are clamped to the first or last colormap color.
    CAXIS('manual') fixes axis scaling at the current range.
    CAXIS('auto') sets axis scaling back to autoranging.
    CAXIS, by itself, returns the two element row vector containing the
    [cmin cmax] currently in effect.
    CAXIS(AX,...) uses axes AX instead of the current axes.
 
    CAXIS is an M-file that sets the axes properties CLim and CLimMode.
 
    See also COLORMAP, AXES, AXIS.

>> caxis([6 8])
>> imagesc(t,f,squeeze(log10(sp(2,:,:)))');axis xy;colorbar
>> caxis([6 8]); colorbar
>> save George_Th.mat

-------------------------------------

>> edit Powerspect&
>> ls

ans =

Bijan_Thur.mat	g3509.eeg     g3509.mm.1     Placefield22.m  Placefield.m
Bijan_Wed.m	g3509.m1m2.1  g3509.mm.2     Placefield29.m  Powerspect&.m
core		g3509.m1m2.2  g3509.mm.3     Placefield2.m   Record1.mat
g3509-005.eeg	g3509.m1m2.3  g3509.mm.4     Placefield2.m~  Spectral
g3509-015.eeg	g3509.m1m2.4  g3509.mm.5     Placefield32.m  Track
g3509-029.eeg	g3509.m1m2.5  George_Th.mat  Placefield3.m   tracking.m


>> Powerspect&
??? Powerspect&
               |
Error: Expected a variable, function, or constant, found "end of line".

>> !more Powerspect&.m
/bin/bash: .m: command not found
>> !mv Powerspect&.m Powerspect.m
Powerspect: No such file or directory
/bin/bash: .m: command not found
mv: missing file argument
Try `mv --help' for more information.
>> ls

ans =

Bijan_Thur.mat	g3509.eeg     g3509.mm.1     Placefield22.m  Placefield.m
Bijan_Wed.m	g3509.m1m2.1  g3509.mm.2     Placefield29.m  Powerspect&.m
core		g3509.m1m2.2  g3509.mm.3     Placefield2.m   Record1.mat
g3509-005.eeg	g3509.m1m2.3  g3509.mm.4     Placefield2.m~  Spectral
g3509-015.eeg	g3509.m1m2.4  g3509.mm.5     Placefield32.m  Track
g3509-029.eeg	g3509.m1m2.5  George_Th.mat  Placefield3.m   tracking.m


>> pwd

ans =

/data/guest1/george

>> ls

ans =

Bijan_Thur.mat	g3509.eeg     g3509.mm.1     Placefield22.m  Placefield.m
Bijan_Wed.m	g3509.m1m2.1  g3509.mm.2     Placefield29.m  Powerspect&.m
core		g3509.m1m2.2  g3509.mm.3     Placefield2.m   Record1.mat
g3509-005.eeg	g3509.m1m2.3  g3509.mm.4     Placefield2.m~  Spectral
g3509-015.eeg	g3509.m1m2.4  g3509.mm.5     Placefield32.m  Track
g3509-029.eeg	g3509.m1m2.5  George_Th.mat  Placefield3.m   tracking.m


>> !mv Powerspect&.m Powerspect.m
mv: missing file argument
Try `mv --help' for more information.
/bin/bash: .m: command not found
>> pwd

ans =

/data/guest1/george

>> ls

ans =

Bijan_Thur.mat	g3509.eeg     g3509.mm.1     Placefield22.m  Placefield.m
Bijan_Wed.m	g3509.m1m2.1  g3509.mm.2     Placefield29.m  Powerspect.m
core		g3509.m1m2.2  g3509.mm.3     Placefield2.m   Record1.mat
g3509-005.eeg	g3509.m1m2.3  g3509.mm.4     Placefield2.m~  Spectral
g3509-015.eeg	g3509.m1m2.4  g3509.mm.5     Placefield32.m  Track
g3509-029.eeg	g3509.m1m2.5  George_Th.mat  Placefield3.m   tracking.m


>> Powerspect
Using 39 tapers.
Calculating tapers ... 
	... Done

elapsed_time =

  694.9932

>> figure;
>> imagesc(t,f,squeeze(log10(sp(1,:,:)))');axis xy;colorbar
>> !mv Powerspect.m Powerspect15.m
>> !cp Powerspect15.m Powerspect29.m
>> !more Powerspect29.m
fid15=fopen('g3509-015.eeg','r');
data15=fread(fid15,[21,1250*120],'short');
fclose(fid15);
ndata15=data15(2:4:20,:);
tic;[sp15,f15]=tfspec(ndata15(:,:),[5,4],1250,1,[400]);toc
t15=[0:114]/2+2.5;
imagesc(t15,f15,squeeze(log10(sp15(1,:,:)))');axis xy;colorbar;
>> edit Powerspect29.m
>> !emacs Powerspect29.m
>> Powerspect29
Using 39 tapers.
Calculating tapers ... 
	... Done

elapsed_time =

  716.9829

>> Powerspect29
  Interrupt
Error in ==> /data/guest1/george/Powerspect29.m
On line 2  ==> data29=fread(fid29,[21,1250*120],'short');


>> !more Powerspect29.m
fid29=fopen('g3509-029.eeg','r');
data29=fread(fid29,[21,1250*120],'short');
fclose(fid29);
ndata29=data29(2:4:20,:);
tic;[sp29,f29]=tfspec(ndata29(:,:),[5,4],1250,1,[400]);toc
t29=[0:114]/2+2.5;
imagesc(t29,f29,squeeze(log10(sp29(1,:,:)))');axis xy;colorbar;
>> caxis([4 10]);colorbar;
>> figure(1);caxis([4 10]);colorbar;
>> figure(2);caxis([4 10]);colorbar;
>> figure(2);caxis([6 10]);colorbar;
>> figure(3);caxis([6 10]);colorbar;
>> figure(1);caxis([6 10]);colorbar;
>> figure(1);caxis([6 8]);colorbar;
>> figure(2);caxis([6 8]);colorbar;
>> figure(3);caxis([6 8]);colorbar;
>> Powerspect29

------------------------------------------------------------------------
       Segmentation violation detected at Thu Aug 30 21:01:38 2001
------------------------------------------------------------------------

Configuration:
  MATLAB Version:   6.1.0.450 (R12.1)
  Operating System: Linux 2.4.2-2 #1 Sun Apr 8 20:41:30 EDT 2001 i686
  Window System:    The XFree86 Project, Inc (4003), display :0.0
  Current Visual:   0x22 (class 4, depth 24)
  Processor ID:     x86 Family 6 Model 8 Stepping 1, GenuineIntel
  Virtual Machine:  Java 1.1.8 from Sun Microsystems Inc., ported by the Blackdown Java-Linux Porting Team

Register State:
  eax = 0001be6a   ebx = 40969540
  ecx = 4df43d00   edx = 0001be69
  esi = 4e3a0008   edi = 000000a8
  ebp = bfff93a0   esp = bfff9338
  eip = 40935b46   flg = 00010206

Stack Trace:
  [0] libmwm_interpreter.so:inIsCurrentMexLocked~(0x47f3c4a0 "data29", 31, 1, 0x4090dba9) + 27078 bytes
  [1] libmwm_interpreter.so:inCheckFunctionTimestamp~(31, 15, 1, 0xbfff9740) + 5315 bytes
  [2] libmwm_interpreter.so:inPrintOpcodeStats~(1, 1, 0xbfffac30, 0x4094d694) + 7377 bytes
  [3] libmwm_interpreter.so:inFindLocalFunction~(0x47eae238, 21531, 0xbfffaca4, 0x409319e9) + 16806 bytes
  [4] libmwm_interpreter.so:inIsCurrentMexLocked~(0, 0, 0xbfffc2a8, 0x47eae238) + 10474 bytes
  [5] libmwm_interpreter.so:inGetFileExtFromType~(0, 0, 0xbfffc2a8, 0x47eae238) + 10416 bytes
  [6] libmwm_interpreter.so:inValidateLoadedObject~(639, 0x415b77ec "Powerspect29", 0, 0) + 1630 bytes
  [7] libmwm_interpreter.so:inPrintOpcodeStats~(2, 0x40969540, 0xbfffd850, 0x4091c1b7) + 4772 bytes
  [8] libmwm_interpreter.so:inIsInEvalc~(0, 0x409765c0, 0xbfffd930, 0xbfffd984) + 271 bytes
  [9] libmwm_interpreter.so:inIsInEvalc~(0x087a5bc0 "Powerspect29\n", 13, 0, 0) + 2208 bytes
  [10] libmwm_interpreter.so:inEvalCmdNoEnd~(0x087a5bc0 "Powerspect29\n", 76, 0xbfffdb60, 0x0805ff9a) + 105 bytes
  [11] matlab:mnParser~(0x40dd09e4, 0x40016b64, 0xbffff70c, 0xbffff024) + 906 bytes
  [12] matlab:main~(1, 0xbffff70c, 0xbffff714, 0x40cc2149) + 2279 bytes
  [13] libc.so.6:__libc_start_main~(0x08053dc0, 1, 0xbffff70c, 0x08051a5c) + 147 bytes

Please follow these steps in reporting this problem to The MathWorks so
that we have the best chance of correcting it:

    1. Send us this crash report.  For your convenience, this information
       has been recorded in: /home/guest/matlab_crash_dump.18661

    2. Provide a brief description of what you were doing when this
       problem occurred.

    3. If possible, include M-files, MEX-files, or MDL-files that aid
       in reproducing it.

    4. E-mail or FAX this information to us at:
                  E-mail:   support@mathworks.com
                     FAX:   508-647-7201

Thank you for your assistance.  Please save your workspace and restart
MATLAB before continuing your work.

  Interrupt
Error in ==> /data/guest1/george/Powerspect29.m
On line 4  ==> ndata29=data29(2:4:20,:);


>> !more Powerspect29.m
fid29=fopen('g3509-029.eeg','r');
data29=fread(fid29,[21,1250*120],'short');
fclose(fid29);
ndata29=data29(2:4:20,:);
tic;[sp29,f29]=tfspec(ndata29(:,:),[5,4],1250,1,[400]);toc
t29=[0:114]/2+2.5;
imagesc(t29,f29,squeeze(log10(sp29(1,:,:)))');axis xy;colorbar;
>> imagesc(t29,f29,squeeze(log10(sp29(1,:,:)))');axis xy;colorbar;
>> imagesc(t29,f29,squeeze(log10(sp29(5,:,:)))');axis xy;colorbar;
>> subplot(131);imagesc(t15,f15,squeeze(log10(sp15(5,:,:)))');axis xy;colorbar;
>> subplot(311);imagesc(t15,f15,squeeze(log10(sp15(5,:,:)))');axis xy;colorbar;
>> edit Plots.m
>> figure(3);caxis([6 10]);colorbar;
>> edit Plots.m
>> Plots
>> edit Plots.m
>> edit Plots.m
>> Plots
>> edit Plots.m
>> Plots
>> edit Plots.m
>> Plots
??? Error: File: /data/guest1/george/Plots.m Line: 1 Column: 97
Missing operator, comma, or semicolon.

>> edit Plots.m
>> Plots
??? Error using ==> xlim
Wrong number of arguments

Error in ==> /data/guest1/george/Plots.m
On line 1  ==> subplot(311);imagesc(t,f,squeeze(log10(sp(5,:,:)))');axis xy;colorbar;caxis([6 8]);colorbar;xlim(0,50);

>> help xlim

 XLIM X limits.
    XL = XLIM             gets the x limits of the current axes.
    XLIM([XMIN XMAX])     sets the x limits.
    XLMODE = XLIM('mode') gets the x limits mode.
    XLIM(mode)            sets the x limits mode.
                             (mode can be 'auto' or 'manual')
    XLIM(AX,...)          uses axes AX instead of current axes.
 
    XLIM sets or gets the XLim or XLimMode property of an axes.
 
    See also PBASPECT, DASPECT, YLIM, ZLIM.

>> edit Plots.m
>> Plots
>> edit Plots.m
>> Plots
>> edit Plots.m
>> Plots
>> edit Plots.m
>> plot(t)
>> Plotm
>> Plotm
>> edit Plotm.m
>> Plotm
>> Plots
>> edit Plots.m
>> Plots
>> edit Plots.m
>> Plots
>> edit Plotm.m
>> Plotm.m
??? Undefined variable 'Plotm'.

>> Plotm
>> Plots
>> edit Plots.m
>> Plots
>> edit Plots.m
>> edit Plots.m
>> Plots

-----------------------------

>> edit Plots.m
>> edit Plots.m
>> Plots
>> whos
  Name          Size           Bytes  Class

  ans           1x1                8  double array
  data         21x150000    25200000  double array
  data15       21x150000    25200000  double array
  data29       21x150000    25200000  double array
  f             1x5242         41936  double array
  f15           1x5242         41936  double array
  f29           1x5242         41936  double array
  fid           1x1                8  double array
  fid15         1x1                8  double array
  fid29         1x1                8  double array
  ndata         5x150000     6000000  double array
  ndata15       5x150000     6000000  double array
  ndata29       5x150000     6000000  double array
  sp            5x115x5242  24113200  double array
  sp15          5x115x5242  24113200  double array
  sp29          5x115x5242  24113200  double array
  t             1x115            920  double array
  t15           1x115            920  double array
  t29           1x115            920  double array

Grand total is 20758525 elements using 166068200 bytes

>> [coh1,f]=coherency(ndata(1,1:5*1250),ndata(2,5*1250),[1,10],1250,[0,50]);
??? Error using ==> coherency
Error: Time series are not the same length

>> [coh1,f]=coherency(ndata(1,1:5*1250),ndata(2,1:5*1250),[1,10],1250,[0,50]);
Using 19 tapers.
Calculating tapers ... 
	... Done
??? Error using ==> coherency
Error: Tapers and time series are not the same length

>> [coh1,f]=coherency(ndata(1,1:1250*5),ndata(2,1:1250*5),[1,10],1250,[0,50]);
Using 19 tapers.
Calculating tapers ... 
	... Done
??? Error using ==> coherency
Error: Tapers and time series are not the same length

>> [coh1,f]=coherency(ndata(1,1:1250),ndata(2,1:1250),[1,10],1250,[0,50]);
Using 19 tapers.
Calculating tapers ... 
	... Done
>> [coh1,f]=coherency(ndata(1,1:1250*5),ndata(2,1:1250*5),[2,10],1250,[0,50]);
Using 39 tapers.
Calculating tapers ... 
	... Done
??? Error using ==> coherency
Error: Tapers and time series are not the same length

>> [coh1,f]=coherency(ndata(1,1:1250),ndata(2,1:1250),[1,10],1250,[0,50]);
Using 19 tapers.
Calculating tapers ... 
	... Done
>> [coh1,f]=coherency(ndata(1,1:1250*5),ndata(2,1:1250*5),[5,3],1250,[0,50]);
Using 29 tapers.
Calculating tapers ... 
	... Done
>> plot(coh);
??? Undefined function or variable 'coh'.

>> plot(coh1);
>> whos coh1
  Name       Size           Bytes  Class

  coh1       1x655          10480  double array (complex)

Grand total is 655 elements using 10480 bytes

>> plot(f,coh1);
Warning: Imaginary parts of complex X and/or Y arguments ignored.
>> plot(f,abs(coh1));
>> plot(abs(coh1));
>> plot(f,abs(coh1));
>> help atanh

 ATANH  Inverse hyperbolic tangent.
    ATANH(X) is the inverse hyperbolic tangent of the elements of X.

 Overloaded methods
    help sym/atanh.m

>> [coh1,f]=coherency(ndata(1,1:1250*2),ndata(2,1:1250*2),[2,3],1250,[0,50]);
Using 11 tapers.
Calculating tapers ... 
	... Done
>> plot(f,abs(coh1));
>> [coh1,f]=coherency(ndata(1,1:1250),ndata(2,1:1250),[1,3],1250,[0,50]);
Using 5 tapers.
Calculating tapers ... 
	... Done
>> plot(f,abs(coh1));
>> [coh1,f]=coherency(ndata(1,1:1250/2),ndata(2,1:1250/2),[0.5,3],1250,[0,50]);
Using 2 tapers.
Calculating tapers ... 
Warning:  K is less than 3
	... Done
>> plot(f,abs(coh1));
>> [coh1,f]=coherency(ndata(1,1:1250*2),ndata(2,1:1250*2),[2,3],1250,[0,50]);
Using 11 tapers.
Calculating tapers ... 
	... Done
>> plot(f,abs(coh1));
>> [coh1,f]=coherency(ndata(1,1:1250*10),ndata(2,1:1250*10),[10,3],1250,[0,50]);
Using 59 tapers.
Calculating tapers ... 
	... Done
>> plot(f,abs(coh1));
>> [coh1,f]=coherency(ndata(1,1:1250*2),ndata(2,1:1250*2),[2,3],1250,[0,50]);
Using 11 tapers.
Calculating tapers ... 
	... Done
>> plot(f,abs(coh1));
>> [coh1,f]=coherency(ndata(1,1:1250),ndata(2,1:1250),[2,3],1250,[0,50]);
Using 11 tapers.
Calculating tapers ... 
	... Done
??? Error using ==> coherency
Error: Tapers and time series are not the same length

>> [coh1,f]=coherency(ndata(1,1:1250),ndata(2,1:1250),[1,3],1250,[0,50]);
Using 5 tapers.
Calculating tapers ... 
	... Done
>> plot(f,abs(coh1));
>> plot(f,atanh(abs(coh1)));
>> hold on;
>> plot(f,abs(coh1));
>> clf
>> plot(ndata(1,1:1250))
>> hold;
Current plot held
>> plot(ndata(2,1:1250),'r')
>> clf
>> plot(abs(coh1))
>> plot(f,abs(coh1))
>> [coh1,f]=coherency(ndata(1,1:1250),ndata(5,1:1250),[1,3],1250,[0,50]);
Using 5 tapers.
Calculating tapers ... 
	... Done
>> plot(f,abs(coh1))
>> [coh1,f]=coherency(ndata(1,1:1250*5),ndata(2,1:1250*5),[5,3],1250,[0,50]);
Using 29 tapers.
Calculating tapers ... 
	... Done
>> plot(f,abs(coh1))
>> [coh1,f]=coherency(ndata(1,1:1250*5),ndata(5,1:1250*5),[5,3],1250,[0,50]);
Using 29 tapers.
Calculating tapers ... 
	... Done
>> plot(f,abs(coh1))
>> [coh1,f]=coherency(ndata(1,1:1250*5),ndata(4,1:1250*5),[5,3],1250,[0,50]);
Using 29 tapers.
Calculating tapers ... 
	... Done
>> hold;
Current plot held
>> plot(f,abs(coh1),'r')
>> [coh1,f]=coherency(ndata(1,1:1250*5),ndata(3,1:1250*5),[5,3],1250,[0,50]);
Using 29 tapers.
Calculating tapers ... 
	... Done
>> plot(f,abs(coh1),'g')
>> [coh1,f]=coherency(ndata(1,1:1250*5),ndata(4,1:1250*5),[5,3],1250,[0,50]);
Using 29 tapers.
Calculating tapers ... 
	... Done
>> clf
>> plot(f,ph(coh1))
??? Undefined function or variable 'ph'.

>> plot(f,phase(coh1))
>> [coh1,f]=coherency(ndata(1,1:1250*5),ndata(2,1:1250*5),[5,3],1250,[0,50]);
Using 29 tapers.
Calculating tapers ... 
	... Done
>> hold;
Current plot held
>> plot(f,phase(coh1),'r')
>> [coh1,f]=coherency(ndata(2,1:1250*5),ndata(4,1:1250*5),[5,3],1250,[0,50]);
Using 29 tapers.
Calculating tapers ... 
	... Done
>> plot(f,phase(coh1),'g')
>> [coh1,f]=coherency(ndata(2,1:1250*5),ndata(4,1:1250*5),[5,3],1250,[0,50]);
Using 29 tapers.
Calculating tapers ... 
	... Done
>>
Using 29 tapers.
Calculating tapers ... 
	... Done

elapsed_time =

  361.2882
  
  ------------------------
  
  >> ls

ans =

Bijan_Thur.mat	g3509.m1m2.2  g3509.mm.5	   Placefield32.m   Record1.mat
Bijan_Wed.m	g3509.m1m2.3  George.mat	   Placefield3.m    Spectral
core		g3509.m1m2.4  George_Th.mat	   Placefield.m     Track
g3509-005.eeg	g3509.m1m2.5  George_Th_Night.mat  Plotm.m	    tracking.m
g3509-015.eeg	g3509.mm.1    Placefield22.m	   Plots.m
g3509-029.eeg	g3509.mm.2    Placefield29.m	   Powerspect15.m
g3509.eeg	g3509.mm.3    Placefield2.m	   Powerspect29.m
g3509.m1m2.1	g3509.mm.4    Placefield2.m~	   Powerspect29.m~


>> load George.mat
>> whos
  Name          Size           Bytes  Class

  ans           1x471            942  char array
  data         21x150000    25200000  double array
  data15       21x150000    25200000  double array
  f             1x655           5240  double array
  f15           1x5242         41936  double array
  fid           1x1                8  double array
  fid15         1x1                8  double array
  fid29         1x1                8  double array
  ndata         5x150000     6000000  double array
  ndata15       5x150000     6000000  double array
  sp            5x115x5242  24113200  double array
  sp15          5x115x5242  24113200  double array
  t             1x115            920  double array
  t15           1x115            920  double array

Grand total is 13834901 elements using 110676382 bytes

>> fid29=fopen('g3509-005.eeg','r');
>> data29=fread(fid29,[21,1250*120],'short');
>> data29=fread(fid29,[21,1:1250*120],'short');
??? Error using ==> fread
Invalid size.

>> clear data29
>> data29 = fread(fid,[21,1250*120],'short');
>> fclose(fid);
>> ndata29=data29(2:4:20,:);
>> tic;[coh29,fc29]=tfcoh(ndata29(2,:),ndata29(4,:),[5,3],1250,1,[0,50]);toc
??? Undefined function or variable 'tfcoh'.

>> addpath /mnt/and
No completions found.
>> addpath /mnt/
cdrom/   data/    floppy/  
>> addpath /mnt/data/and10/arno/Spectral/
>> tic;[coh29,fc29]=tfcoh(ndata29(2,:),ndata29(4,:),[5,3],1250,1,[0,50]);toc
Using 29 tapers.
Calculating tapers ... 
	... Done

elapsed_time =

  351.3445

>> whos
  Name          Size           Bytes  Class

  ans           1x1                8  double array
  coh29       115x655        1205200  double array (complex)
  data         21x150000    25200000  double array
  data15       21x150000    25200000  double array
  data29       21x150000    25200000  double array
  f             1x655           5240  double array
  f15           1x5242         41936  double array
  fc29          1x655           5240  double array
  fid           1x1                8  double array
  fid15         1x1                8  double array
  fid29         1x1                8  double array
  ndata         5x150000     6000000  double array
  ndata15       5x150000     6000000  double array
  ndata29       5x150000     6000000  double array
  sp            5x115x5242  24113200  double array
  sp15          5x115x5242  24113200  double array
  t             1x115            920  double array
  t15           1x115            920  double array

Grand total is 17810411 elements using 143085888 bytes

>> tic;[coh5,fc5]=tfcoh(ndata(2,:),ndata(4,:),[5,3],1250,1,[0,50]);toc
Using 29 tapers.
Calculating tapers ... 
	... Done

elapsed_time =

  335.6944

>> imagesc(t,fc29,abs(coh29(:,:))');axis xy;colorbar
>> figure;
>> imagesc(t,fc5,abs(coh5(:,:))');axis xy;colorbar
>> figure(1);caxis[1 9];
??? figure(1);caxis[1 9];
                   |
Error: Missing operator, comma, or semicolon.

>> !more Plots.m
subplot(311);imagesc(t,f,squeeze(log10(sp(3,:,:)))');axis xy;colorbar;caxis([6 8]);colorbar;ylim([0 50]);
subplot(312);imagesc(t15,f15,squeeze(log10(sp15(3,:,:)))');axis xy;colorbar;caxis([6 8]);colorbar;ylim([0 50]);
subplot(313);imagesc(t29,f29,squeeze(log10(sp29(3,:,:)))');axis xy;colorbar;caxis([6 8]);colorbar;ylim([0 50]);
>> figure(1);caxis([1 9]);
>> figure(1);caxis([1 9]);colorbar;
>> imagesc(t,fc5,abs(coh5(:,:))');axis xy;colorbar
>> imagesc(t,fc5,abs(coh5(:,:))');axis xy;colorbar;caxis([0.1 0.9]);
>> figure(2);caxis([0.1 0.9]);
>> clf
>> clf
>> imagesc(t,fc5,abs(coh5(:,:))');axis xy;colorbar;caxis([0.1 0.9]);
>> figure;
>> imagesc(t,fc29,abs(coh29(:,:))');axis xy;colorbar;caxis([0.1 0.9]);
>> imagesc(t,fc29,abs(coh29(:,:))');axis xy;colorbar;caxis([0.1 0.9]);
>> imagesc(t,fc29,abs(coh29(:,:))');axis xy;colorbar;caxis([0.1 1]);
>> imagesc(t,fc29,abs(coh29(:,:))');axis xy;colorbar;caxis([0.1 1]);colorbar
>> imagesc(t,fc29,abs(coh29(:,:))');axis xy;colorbar;caxis([0.1 0.9]);colorbar
>> imagesc(t,fc29,abs(coh29(:,:))');axis xy;colorbar;caxis([0.1 0.9]);colorbar
>> imagesc(t,fc29,abs(coh29(:,:))');axis xy;colorbar;caxis([0.1 0.9]);colorbar
>> imagesc(t,fc29,abs(coh29(:,:))');axis xy;colorbar;caxis([0.1 1]);colorbar
>> figure;
>> imagesc(t,fc5,abs(coh5(:,:))');axis xy;colorbar;caxis([0.1 1]);colorbar;

--------------------------------Partha, Bijan

>> whos
  Name          Size           Bytes  Class

  ans           1x1                8  double array
  coh29       115x655        1205200  double array (complex)
  coh5        115x655        1205200  double array (complex)
  data         21x150000    25200000  double array
  data15       21x150000    25200000  double array
  data29       21x150000    25200000  double array
  f             1x655           5240  double array
  f15           1x5242         41936  double array
  fc29          1x655           5240  double array
  fc5           1x655           5240  double array
  fid           1x1                8  double array
  fid15         1x1                8  double array
  fid29         1x1                8  double array
  ndata         5x150000     6000000  double array
  ndata15       5x150000     6000000  double array
  ndata29       5x150000     6000000  double array
  sp            5x115x5242  24113200  double array
  sp15          5x115x5242  24113200  double array
  t             1x115            920  double array
  t15           1x115            920  double array

Grand total is 17886391 elements using 144296328 bytes

>> figure
>> plot(f,abs(coh1),'r')
??? Undefined function or variable 'coh1'.

>> whos coh5
  Name       Size           Bytes  Class

  coh5     115x655        1205200  double array (complex)

Grand total is 75325 elements using 1205200 bytes

>> plot(f,abs(coh5(1,:)),'r')
>> plot(f,abs(mean(coh5(:,:))),'r')
>> plot(f,mean(abs(coh5(:,:))),'r')
>> plot(ndata(2,1:1250))
>> hold;
Current plot held
>> plot(ndata(4,1:1250),'r')
>> plot(ndata(1,1:1250),'g')
>> plot(ndata(4,1:1250),'k')
>> plot(ndata(5,1:1250),'r')
>> 
>> 
>> help mtfilter

   MTFILTER Bandpass filter a time series using the multitaper method
 
   Y = MTFILTER(X, TAPERS, SAMPLING, F0, FLAG) 
 
   Inputs:  X 		=  Time series array in [Space/Trials,Time] form
 	    TAPERS	=  Data tapers in [K,TIME], [N,P,K] or [N,W] form.
 				Defaults to [N,3,5] where N is duration of X
 	    SAMPLING 	=  Sampling rate of time series X in Hz.
 				Defaults to 1 Hz.
 	    F0		=  Center frequency of filter.
 				Defaults to 0 Hz.
 
 	    FLAG = 0:	Output data should be centered.
 	    FLAG = 1:	Output data should not be centered.
 
   Outputs: Y		=  Filtered version of X in [Space/Trials,Time] form.
 				If F0 is nonzero Y is complex.
 

>> y2 = mtfilter(ndata(2,1:2500),[.5,5],1250,7);
Calculating tapers ... 
	... Done
Filter is 1250 points long
>> whos y2
  Name      Size           Bytes  Class

  y2        1x2500         40000  double array (complex)

Grand total is 2500 elements using 40000 bytes

>> plot(real(y2))
>> clf
>> plot(ndata(2,1:1250))
>> hold;
Current plot held
>> plot(real(y2),'r')
>> y2 = mtfilter(ndata(2,:),[.5,5],1250,7);
Calculating tapers ... 
	... Done
Filter is 1250 points long
>> y2 = mtfilter(ndata(2,:),[1,2.5],1250,7);
Calculating tapers ... 
	... Done
Filter is 2500 points long
>> whos y2
  Name      Size           Bytes  Class

  y2        1x150000     2400000  double array (complex)

Grand total is 150000 elements using 2400000 bytes

>> plot(real(y2(1:2500)),'g')
>> plot(ndata(2,1:2500))
>> plot(real(y2(1:2500)),'k')
>> y4 = mtfilter(ndata(4,:),[1,2.5],1250,7);
Calculating tapers ... 
	... Done
Filter is 2500 points long
>> clf
>> plot(real(y2(1:2500)),'k')
>> hold;
Current plot held
>> plot(real(y2(1:2500)),'r')
>> plot(ndata(4,1:2500))
>> clf
>> plot(ndata(4,1:2500))
>> hold;
Current plot held
>> plot(real(y4(1:2500)),'r')
>> 
>> 
>> clf
>> plot(real(y4(1:2500)),'r')
>> hold;
Current plot held
>> plot(real(y2(1:2500)),'k')
>> hold;
Current plot released
>> plot(real(y4(1:2500*4)),'r')
>> hold;
Current plot held
>> plot(real(y2(1:2500*4)),'k')
>> plot(phase(y2.*conj(y4)))
  Interrupt
Error in ==> /usr/local/matlab61/toolbox/ident/idobsolete/phase.m
On line 22  ==> PHI=PHI+2*pi*sign(DF(i))*[zeros(1,i) ones(1,N-i)];


>> clf
>> plot(phase(y2(1:250:2500*10).*conj(y4(1:250:2500*10))))
>> plot(phase(y2(1:250:end).*conj(y4(1:250:end))))
>> plot(angle(y2(1:250:end).*conj(y4(1:250:end))))
>> plot(angle(y2(1:250:end).*conj(y4(1:250:end))),'.')
>> hist(angle(y2(1:250:end).*conj(y4(1:250:end))))
>> hist(angle(y2(1:250:end).*conj(y4(1:250:end))),100)
>> hist(angle(y2(1:250:end).*conj(y4(1:250:end))),50)
>> hist(angle(y2(1:250:end).*conj(y4(1:250:end)).*exp(complex(0,1)*2)),50)
>> hist(angle(y2(1:250:end).*conj(y4(1:250:end)).*exp(complex(0,1)*1.5)),50)
>> y1 = mtfilter(ndata(1,:),[1,2.5],1250,7);
Calculating tapers ... 
	... Done
Filter is 2500 points long
>> hist(angle(y2(1:250:end).*conj(y1(1:250:end))),50)
>> tic;[coh5_2,fc5_2]=tfcoh(ndata(2,:),ndata(4,:),[2,3],1250,1,[0,200]);toc
Using 11 tapers.
Calculating tapers ... 
	... Done

elapsed_time =

   69.0831

>> figure
>> whos coh5_2
  Name         Size           Bytes  Class

  coh5_2     118x1310       2473280  double array (complex)

Grand total is 154580 elements using 2473280 bytes

>> imagesc(flipud(abs(coh5_2)'))
>> plot(abs(mean(coh5_2)))
>> tic;[coh5_2,fc5_2]=tfcoh(ndata(2,:),ndata(4,:),[1,2.5],1250,0.25,[0,200]);toc
Using 4 tapers.
Calculating tapers ... 
	... Done
Warning: Integer operands are required for colon operator when used as index.
> In /mnt/data/and10/arno/Spectral/tfcoh.m at line 92
Warning: Integer operands are required for colon operator when used as index.
> In /mnt/data/and10/arno/Spectral/tfcoh.m at line 93
Warning: Integer operands are required for colon operator when used as index.
> In /mnt/data/and10/arno/Spectral/tfcoh.m at line 92
Warning: Integer operands are required for colon operator when used as index.
> In /mnt/data/and10/arno/Spectral/tfcoh.m at line 93
Warning: Integer operands are required for colon operator when used as index.
> In /mnt/data/and10/arno/Spectral/tfcoh.m at line 92
Warning: Integer operands are required for colon operator when used as index.
> In /mnt/data/and10/arno/Spectral/tfcoh.m at line 93
Warning: Integer operands are required for colon operator when used as index.
> In /mnt/data/and10/arno/Spectral/tfcoh.m at line 92
Warning: Integer operands are required for colon operator when used as index.
> In /mnt/data/and10/arno/Spectral/tfcoh.m at line 93
Warning: Integer operands are required for colon operator when used as index.
> In /mnt/data/and10/arno/Spectral/tfcoh.m at line 92
Warning: Integer operands are required for colon operator when used as index.
> In /mnt/data/and10/arno/Spectral/tfcoh.m at line 93
Warning: Integer operands are required for colon operator when used as index.
> In /mnt/data/and10/arno/Spectral/tfcoh.m at line 92
Warning: Integer operands are required for colon operator when used as index.
> In /mnt/data/and10/arno/Spectral/tfcoh.m at line 93
Warning: Integer operands are required for colon operator when used as index.
> In /mnt/data/and10/arno/Spectral/tfcoh.m at line 92
Warning: Integer operands are required for colon operator when used as index.
> In /mnt/data/and10/arno/Spectral/tfcoh.m at line 93
Warning: Integer operands are required for colon operator when used as index.
> In /mnt/data/and10/arno/Spectral/tfcoh.m at line 92
Warning: Integer operands are required for colon operator when used as index.
> In /mnt/data/and10/arno/Spectral/tfcoh.m at line 93
Warning: Integer operands are required for colon operator when used as index.
> In /mnt/data/and10/arno/Spectral/tfcoh.m at line 92
Warning: Integer operands are required for colon operator when used as index.
> In /mnt/data/and10/arno/Spectral/tfcoh.m at line 93
Warning: Integer operands are required for colon operator when used as index.
> In /mnt/data/and10/arno/Spectral/tfcoh.m at line 92
Warning: Integer operands are required for colon operator when used as index.
> In /mnt/data/and10/arno/Spectral/tfcoh.m at line 93
Warning: Integer operands are required for colon operator when used as index.
> In /mnt/data/and10/arno/Spectral/tfcoh.m at line 92
Warning: Integer operands are required for colon operator when used as index.
> In /mnt/data/and10/arno/Spectral/tfcoh.m at line 93
Warning: Integer operands are required for colon operator when used as index.
> In /mnt/data/and10/arno/Spectral/tfcoh.m at line 92
Warning: Integer operands are required for colon operator when used as index.
> In /mnt/data/and10/arno/Spectral/tfcoh.m at line 93
Warning: Integer operands are required for colon operator when used as index.
> In /mnt/data/and10/arno/Spectral/tfcoh.m at line 92
Warning: Integer operands are required for colon operator when used as index.
> In /mnt/data/and10/arno/Spectral/tfcoh.m at line 93
Warning: Integer operands are required for colon operator when used as index.
> In /mnt/data/and10/arno/Spectral/tfcoh.m at line 92
Warning: Integer operands are required for colon operator when used as index.
> In /mnt/data/and10/arno/Spectral/tfcoh.m at line 93
Warning: Integer operands are required for colon operator when used as index.
> In /mnt/data/and10/arno/Spectral/tfcoh.m at line 92
Warning: Integer operands are required for colon operator when used as index.
> In /mnt/data/and10/arno/Spectral/tfcoh.m at line 93
Warning: Integer operands are required for colon operator when used as index.
> In /mnt/data/and10/arno/Spectral/tfcoh.m at line 92
Warning: Integer operands are required for colon operator when used as index.
> In /mnt/data/and10/arno/Spectral/tfcoh.m at line 93
Warning: Integer operands are required for colon operator when used as index.
> In /mnt/data/and10/arno/Spectral/tfcoh.m at line 92
Warning: Integer operands are required for colon operator when used as index.
> In /mnt/data/and10/arno/Spectral/tfcoh.m at line 93
Warning: Integer operands are required for colon operator when used as index.
> In /mnt/data/and10/arno/Spectral/tfcoh.m at line 92
Warning: Integer operands are required for colon operator when used as index.
> In /mnt/data/and10/arno/Spectral/tfcoh.m at line 93
Warning: Integer operands are required for colon operator when used as index.
> In /mnt/data/and10/arno/Spectral/tfcoh.m at line 92
Warning: Integer operands are required for colon operator when used as index.
> In /mnt/data/and10/arno/Spectral/tfcoh.m at line 93
Warning: Integer operands are required for colon operator when used as index.
> In /mnt/data/and10/arno/Spectral/tfcoh.m at line 92
Warning: Integer operands are required for colon operator when used as index.
> In /mnt/data/and10/arno/Spectral/tfcoh.m at line 93
Warning: Integer operands are required for colon operator when used as index.
> In /mnt/data/and10/arno/Spectral/tfcoh.m at line 92
Warning: Integer operands are required for colon operator when used as index.
> In /mnt/data/and10/arno/Spectral/tfcoh.m at line 93
Warning: Integer operands are required for colon operator when used as index.
> In /mnt/data/and10/arno/Spectral/tfcoh.m at line 92
Warning: Integer operands are required for colon operator when used as index.
> In /mnt/data/and10/arno/Spectral/tfcoh.m at line 93
Warning: Integer operands are required for colon operator when used as index.
> In /mnt/data/and10/arno/Spectral/tfcoh.m at line 92
Warning: Integer operands are required for colon operator when used as index.
> In /mnt/data/and10/arno/Spectral/tfcoh.m at line 93
Warning: Integer operands are required for colon operator when used as index.
> In /mnt/data/and10/arno/Spectral/tfcoh.m at line 92
Warning: Integer operands are required for colon operator when used as index.
> In /mnt/data/and10/arno/Spectral/tfcoh.m at line 93
Warning: Integer operands are required for colon operator when used as index.
> In /mnt/data/and10/arno/Spectral/tfcoh.m at line 92
Warning: Integer operands are required for colon operator when used as index.
> In /mnt/data/and10/arno/Spectral/tfcoh.m at line 93
Warning: Integer operands are required for colon operator when used as index.
> In /mnt/data/and10/arno/Spectral/tfcoh.m at line 92
Warning: Integer operands are required for colon operator when used as index.
> In /mnt/data/and10/arno/Spectral/tfcoh.m at line 93
  Interrupt
Error in ==> /mnt/data/and10/arno/Spectral/coherency.m
On line 201  ==>       Yk = fft(tapers(:,1:K).*tmp2(:,ones(1,K)),nf)';

Error in ==> /mnt/data/and10/arno/Spectral/tfcoh.m
On line 94  ==>    [tmp_coh,f,tS1,tS2]=coherency(tmp1,tmp2,tapers,sampling,fk,pad,flag);


>> tic;[coh5_2,fc5_2]=tfcoh(ndata(2,:),ndata(4,:),[1,2.5],1250,0.2,[0,200]);toc
Using 4 tapers.
Calculating tapers ... 
	... Done

elapsed_time =

  117.6548

>> imagesc(flipud(abs(coh5_2)'))
>> plot(fc5_2,abs(mean(coh5_2)))
>> y2_gamma = mtfilter(ndata(2,:),[1,5],1250,40);
Calculating tapers ... 
	... Done
Filter is 2500 points long
>> y4_gamma = mtfilter(ndata(4,:),[1,5],1250,40);
Calculating tapers ... 
	... Done
Filter is 2500 points long
>> hist(angle(y2_gamma(1:250:end).*conj(y4_gamma(1:250:end))),50)
>> y1_gamma = mtfilter(ndata(1,:),[1,5],1250,40);
Calculating tapers ... 
	... Done
Filter is 2500 points long
>> tic;[coh12_2,fc12_2]=tfcoh(ndata(1,:),ndata(2,:),[1,2.5],1250,0.2,[0,200]);toc
Using 4 tapers.
Calculating tapers ... 
	... Done

elapsed_time =

  117.8611

>> imagesc(flipud(abs(coh12_2)'))
>> plot(fc5_2,abs(mean(coh12_2)))
>> imagesc(flipud(abs(coh12_2)'))
>> hist(angle(y2(1:250:end).*conj(y1(1:250:end))),50)
>> hist(angle(y2(1:250:end).*conj(y4(1:250:end))),50)
>> ph24_theta=angle(y2(1:250:end).*conj(y4(1:250:end)));
>> mean(exp(complex(0,1).*ph2_theta))
??? Undefined function or variable 'ph2_theta'.

>> mean(exp(complex(0,1).*ph24_theta))

ans =

  -0.0714 - 0.3398i

>> abs(mean(exp(complex(0,1).*ph24_theta)))

ans =

    0.3472

>> plot(abs(mean(coh5_2)))
>> plot(f5_2,abs(mean(coh5_2)))
??? Undefined function or variable 'f5_2'.

>> plot(abs(mean(coh5_2)))
>> plot(linspace(0,200,655),abs(mean(coh5_2)))
>> tic;[coh24_2,fc24_2]=tfcoh(ndata(2,:),ndata(4,:),[3,1.5],1250,0.2,[0,200]);toc
Using 8 tapers.
Calculating tapers ... 
	... Done
  Interrupt
Error in ==> /mnt/data/and10/arno/Spectral/coherency.m
On line 198  ==>       Xk = fft(tapers(:,1:K).*tmp1(:,ones(1,K)),nf)';

Error in ==> /mnt/data/and10/arno/Spectral/tfcoh.m
On line 94  ==>    [tmp_coh,f,tS1,tS2]=coherency(tmp1,tmp2,tapers,sampling,fk,pad,flag);


>> dndata(1,:) = decimate(ndata(1,:),5);
>> for i = 2:5 dndata(i,:) = decimate(ndata(i,:),5);end
>> tic;[coh24_2,fc24_2]=tfcoh(dndata(2,:),dndata(4,:),[3,1.5],250,0.2,[0,200]);toc
Using 8 tapers.
Calculating tapers ... 
	... Done
  Interrupt
Error in ==> /mnt/data/and10/arno/Spectral/coherency.m
On line 159  ==>      Xk((ch-1)*K+1:ch*K,:) = xk(:,nfk(1)+1:nfk(2));

Error in ==> /mnt/data/and10/arno/Spectral/tfcoh.m
On line 94  ==>    [tmp_coh,f,tS1,tS2]=coherency(tmp1,tmp2,tapers,sampling,fk,pad,flag);


>> tic;[coh24_2,fc24_2]=tfcoh(dndata(2,:),dndata(4,:),[3,1.5],250,1,
??? tic;[coh24_2,fc24_2]=tfcoh(dndata(2,:),dndata(4,:),[3,1.5],250,1,
                                                                     |
Error: Expected a variable, function, or constant, found "end of line".

>> whos dndata
  Name         Size           Bytes  Class

  dndata       5x30000      1200000  double array

Grand total is 150000 elements using 1200000 bytes

>> whos ndata
  Name        Size           Bytes  Class

  ndata       5x150000     6000000  double array

Grand total is 750000 elements using 6000000 bytes

>> tic;[coh24_2,fc24_2]=tfcoh(dndata(2,:),dndata(4,:),[3,1.5],250,1,[0,200]);toc
Using 8 tapers.
Calculating tapers ... 
	... Done

elapsed_time =

   23.4813

>> imagesc(flipud(abs(coh24_2)'))
>> plot(linspace(0,200,655),abs(mean(coh24_2)))
??? Error using ==> plot
Vectors must be the same lengths.

>> whos coh24_2
  Name          Size           Bytes  Class

  coh24_2     117x1638       3066336  double array (complex)

Grand total is 191646 elements using 3066336 bytes

>> plot(linspace(0,200,1638),abs(mean(coh24_2)))
>> tic;[coh24_2,fc24_2]=tfcoh(dndata(2,:),dndata(4,:),[4,.5],250,1,[0,100]);toc
Using 3 tapers.
Calculating tapers ... 
	... Done
  Interrupt
Error in ==> /mnt/data/and10/arno/Spectral/coherency.m
On line 198  ==>       Xk = fft(tapers(:,1:K).*tmp1(:,ones(1,K)),nf)';

Error in ==> /mnt/data/and10/arno/Spectral/tfcoh.m
On line 94  ==>    [tmp_coh,f,tS1,tS2]=coherency(tmp1,tmp2,tapers,sampling,fk,pad,flag);


>> tic;[coh24_2,fc24_2]=tfcoh(dndata(2,:),dndata(4,:),[6,.5],250,1,[0,100]);toc
Using 5 tapers.
Calculating tapers ... 
	... Done

elapsed_time =

   23.1467

>> imagesc(flipud(abs(coh24_2)'))
>> plot(linspace(0,200,1638),abs(mean(coh24_2)))
>> whos coh24_2
  Name          Size           Bytes  Class

  coh24_2     114x1638       2987712  double array (complex)

Grand total is 186732 elements using 2987712 bytes

>> plot(linspace(0,100,1638),abs(mean(coh24_2)))
>> tic;[spec24_2,fc24_2]=tfspec(dndata([2,4],:),[6,.5],250,1,[0,100]);toc
Using 5 tapers.
Calculating tapers ... 
	... Done

elapsed_time =

    7.5905

>> plot(linspace(0,100,1638),squeeze(log(mean(spec24_2(1,:,:)))))
>> plot(linspace(0,100,1638),squeeze(log(mean(spec24_2(2,:,:)))))
>> plot(linspace(0,100,1638),squeeze(log(mean(spec24_2(1,:,:)))))
>> hold;
Current plot held
>> plot(linspace(0,100,1638),squeeze(log(mean(spec24_2(2,:,:)))),'r')
>> plot(linspace(0,100,1638),abs(mean(coh24_2)))
>> figure
>> plot(linspace(0,100,1638),abs(mean(coh24_2)))
>> plot(linspace(0,100,1638),squeeze(log(mean(spec24_2(2,:,:)))),'r')
>> whos spec24_2
  Name           Size           Bytes  Class

  spec24_2       2x114x1638   2987712  double array

Grand total is 373464 elements using 2987712 bytes

>> clf
>> plot(linspace(0,100,1638),squeeze(log(mean(spec24_2(2,:,:)))),'r')
>> hold;
Current plot held
>> plot(linspace(0,100,1638),squeeze(log(mean(spec24_2(1,:,:)))),'b')
>> plot(linspace(0,100,1638),30*abs(mean(coh24_2)),'k')
>> subplot(2,1)
??? Error using ==> subplot
Unknown command option

>> subplot(2,1,1)
>> plot(linspace(0,100,1638),squeeze(log(mean(spec24_2(2,:,:)))),'r')
>> hold;
Current plot held
>> plot(linspace(0,100,1638),squeeze(log(mean(spec24_2(1,:,:)))),'b')
>> subplot(2,1,2)
>> plot(linspace(0,100,1638),30*abs(mean(coh24_2)))
>> axis([0,200,5,20])
>> axis([0,100,5,20])
>> axis([0,20,5,20])
>> axis([0,20,0,20])
>> axis([0,20,11,17])
>> axis([0,20,13,17])
>> subplot(2,1,1)
>> plot(linspace(0,100,1638),squeeze((mean(spec24_2(1,:,:)))),'b')
>> cla
>> plot(linspace(0,100,1638),squeeze((mean(spec24_2(1,:,:)))),'b')
>> plot(linspace(0,100,1638),squeeze((mean(spec24_2(1,:,:)))),'b')
>> subplot(2,1,1)
>> plot(linspace(0,100,1638),30*abs(mean(coh24_2)))
>> subplot(2,1,2)
>> plot(linspace(0,100,1638),squeeze((mean(spec24_2(2,:,:)))),'r')
>> hold;
Current plot held
>> plot(linspace(0,100,1638),squeeze((mean(spec24_2(1,:,:)))),'b')
>> axis([0,20,0,1.5e7])
>> y2_theta = mtfilter(ndata(2,:),[2,1.5],1250,7.7);
Calculating tapers ... 
	... Done
Filter is 5000 points long
>> y4_theta = mtfilter(ndata(4,:),[2,1.5],1250,7.7);
Calculating tapers ... 
	... Done
Filter is 5000 points long
>> hist(angle(y2_theta(1:400:end).*conj(y4_theta(1:400:end))),50)
>> clf
>> hist(angle(y2_theta(1:400:end).*conj(y4_theta(1:400:end))),50)
>> hist(angle(y2_theta(1:400:end).*conj(y4_theta(1:400:end)).*exp(complex(0,1).*1),50)
??? hist(angle(y2_theta(1:400:end).*conj(y4_theta(1:400:end)).*exp(complex(0,1).*1),50)
                                                                                       |
Error: ")" expected, "end of line" found.

>> hist(angle(y2_theta(1:400:end).*conj(y4_theta(1:400:end)).*exp(complex(0,1).*1)),50)
>> hist(angle(y2_theta(1:400:end).*conj(y4_theta(1:400:end)).*exp(complex(0,1).*1.5)),50)
>> tic;[coh15_2,fc15_2]=tfcoh(dndata(1,:),dndata(5,:),[6,.5],250,1,[0,100]);toc
Using 5 tapers.
Calculating tapers ... 
	... Done

elapsed_time =

   23.2253

>> plot(linspace(0,100,1638),30*abs(mean(coh15_2)))
>> plot(linspace(0,100,1638),abs(mean(coh15_2)))
>> y1_theta2 = mtfilter(ndata(1,:),[2,.5],1250,15.5);
Calculating tapers ... 
Warning:  K is less than 3
	... Done
Filter is 5000 points long
  Interrupt
Error in ==> /usr/local/matlab61/toolbox/matlab/datafun/conv.m
On line 32  ==>     c = filter(b, 1, a);

Error in ==> /mnt/data/and10/arno/Spectral/mtfilter.m
On line 53  ==> 	Y = conv(X,filt);


>> y1_theta2 = mtfilter(dndata(1,:),[2,.5],250,15.5);
Calculating tapers ... 
Warning:  K is less than 3
	... Done
Filter is 1000 points long
>> y1_theta2 = mtfilter(dndata(1,:),[3,.5],250,15.5);
Calculating tapers ... 
Warning:  K is less than 3
	... Done
Filter is 1500 points long
>> y1_theta2 = mtfilter(dndata(1,:),[4,.5],250,15.5);
Calculating tapers ... 
	... Done
Filter is 2000 points long
>> y5_theta2 = mtfilter(dndata(5,:),[4,.5],250,15.5);
Calculating tapers ... 
	... Done
Filter is 2000 points long
>> figure
>> hist(angle(y1_theta2(1:400:end).*conj(y5_theta2(1:400:end))),50)
>> hist(angle(y1_theta2(1:250:end).*conj(y5_theta2(1:250:end))),50)
>> hist(angle(y1_theta2(1:100:end).*conj(y5_theta2(1:100:end))),50)
>> 
>> 
>> plot(abs(mean(coh5)))
>> plot(abs(mean(coh5)))
>> figure
>> plot(abs(mean(coh5)))
>> hold;
Current plot held
>> plot(abs(mean(coh29)))
>> plot(abs(mean(coh29)),'r')

