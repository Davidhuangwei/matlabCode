% function ThetaDetect(filename,mode)
% is a procedure to detect sharpwaves from EEG file
%
% much like Haj's TRD, except it reads a single channel.eeg.0 file, 
% rather than a .eeg file
%
% mode =0 -> datamax 16bit awake theta periods
% mode =1 -> datamax 16bit sleep REM periods
% mode =2 -> RC 12bit awake theta periods
% mode =3 -> RC 12bit sleep REM periods
% mode =10 -> datamax 16bit awake theta peaks
% mode =11 -> datamax 16bit sleep REM peaks
% mode =12 -> RC 12bit awake theta peaks
% mode =13 -> RC 12bit sleep REM peaks


function TRD(filename, mode)

numch = 1;
chselect = 1;

eegfilename = sprintf('%s.eeg.0',filename);
tfilename = sprintf('%s.the',filename);
ntfilename = sprintf('%s.nthe',filename);
otfilename = sprintf('%s.othe',filename);
tpfilename = sprintf('%s.theta',filename);

sr = 1250; % sampling rate (Hz)
min_REM_period = 10; % (second)

fileinfo = dir(eegfilename);
numel = ceil(fileinfo(1).bytes / 2 / numch);
rlength = numel * 16;

switch mode
 case 0
  [t,nt] = trdetect(eegfilename, numch,chselect);
  thtsave(t);
  nthtsave(nt);
  t = t * 16;
  nt = nt * 16;
  msave(tfilename,t);
  msave(ntfilename,nt);
 case 1
  [t,nt] = trdetectr(eegfilename, numch,chselect);
  dt = diff(t,1,2);
  remt = t(find(dt/sr >= min_REM_period),:);
  thtsave(remt);
  nthtsave(nt);
  remt = remt * 16;
  nt = nt * 16;
  norem =   exregion(rlength,remt);
  noremnt = exregion(norem,nt);
  msave(tfilename,remt);
  msave(ntfilename,nt);
  msave(otfilename,noremnt);
 case 2
  [t,nt] = trdetect2(eegfilename, numch,chselect);
  thtsave(t);
  nthtsave(nt);
  t = t * 16;
  nt = nt * 16;
  msave(tfilename,t);
  msave(ntfilename,nt);
 case 3
  [t,nt] = trdetectr2(eegfilename, numch,chselect);
  dt = diff(t,1,2);
  remt = t(find(dt/sr >= min_REM_period),:);
  thtsave(remt);
  nthtsave(nt);
  remt = remt * 16;
  nt = nt * 16;
  msave(tfilename,remt);
  msave(ntfilename,nt);

 case 10
  p = tdetect(eegfilename, numch,chselect,0);
  p2 = p * 16;
  msave(tpfilename,p2);
  vsave('t',p);
 case 11
  p = tdetectr(eegfilename, numch,chselect,0);
  p2 = p * 16;
  msave(tpfilename,p2);
  vsave('t',p);
 case 12
  p = tdetect2(eegfilename, numch,chselect,0);
  p2 = p * 16;
  msave(tpfilename,p2);
  vsave('t',p);
 case 13
  [t,nt] = tdetectr2(eegfilename, numch,chselect,0);
  p2 = p * 16;
  msave(tpfilename,p2);
  vsave('t',p);
end


