% Usage: PlotPsd('FileBase',ChNum1, ChNum2,N, [timebeg timeend])
%
% if timebeg and timeend are not provided, a power spectrum
% will be performed on the whole file.

function PPSD(FileBase,ChNum1,ChNum2,N,arg1);

ParFile = ([FileBase '.par']);
doesexist=exist(ParFile);

if (doesexist == 0)
    error('%s unavailable',ParFile);
  end;

% reads the max number of channels and sampling rate from the parfile, couldn't figure a better way...

  ReadparNumCh = sprintf('!awgetxy %s 1 1 > tempfile',ParFile); % read number of channels
  eval(ReadparNumCh);

  ReadparSrate = sprintf('!awgetxy %s 2 1 >> tempfile',ParFile); % read sampling rate
  eval(ReadparSrate);

  fid=fopen('tempfile');
  ParInput=fscanf(fid,'%d',inf);
  MaxChannels=ParInput(1);
  SRateMS=ParInput(2);
  fclose(fid);
  !rm tempfile
% end read par file

filename = ([FileBase '.eeg']);
doesexist = exist(filename);
  if (doesexist == 0)
    error('The filename you entered does not exist, please check the filename and try again');
  end;

fp = fopen(filename, 'r');
datasize = 'short';
Parameters=[MaxChannels inf];
eegAll = fread(fp, Parameters, datasize);

if (nargin<5)
 PerBeg=1;
 PerEnd=max(eegAll);
else
 PerBeg=arg1(1)*1250;
 PerEnd=arg1(2)*1250;
end;

if (nargin<4)
 error('Incorrect Parameters');
end;

ThetaX=[7 7];
ChNum1txt=num2str(ChNum1);
ChNum2txt=num2str(ChNum2);
PerBegtxt=num2str(PerBeg/1250);
PerEndtxt=num2str(PerEnd/1250);

figure(1)
letterlayoutl;
subplot(2,1,1)
Spsd(eegAll(ChNum1,PerBeg:PerEnd)-2048,2^(N),1250,2^(N-1),2^(N-2));
hold on
YL1=ylim;
title(['Channel number ',ChNum1txt,' from ',FileBase, ' - ',PerBegtxt,'-',PerEndtxt,' sec']);
hold off

subplot(2,1,2)
Spsd(eegAll(ChNum2,PerBeg:PerEnd)-2048,2^(N),1250,2^(N-1),2^(N-2));
hold on
YL2=ylim;
title(['Channel number ',ChNum2txt,' from ',FileBase, ' - ',PerBegtxt,'-',PerEndtxt,' sec']);
hold off

% set limits of graphs

if (YL1(1)<YL2(1))
 MinYL=YL1(1);
else
 MinYL=YL2(1);
end;

if (YL1(2)<YL2(2))
 MaxYL=YL2(2);
else
 MaxYL=YL1(2);
end;

subplot(2,1,1)
hold on
ylim([MinYL MaxYL]);
set(gca,'YTick',MinYL:10:MaxYL);
set(gca,'XTick',0:25:250);
plot(ThetaX,[(MinYL+30) (MaxYL-2)],'r');
xlim([0 250]);
hold off

subplot(2,1,2)
hold on
ylim([MinYL MaxYL]);
set(gca,'YTick',MinYL:10:MaxYL);
set(gca,'XTick',0:25:250);
plot(ThetaX,[(MinYL+30) (MaxYL-2)],'r');
xlim([0 250]);
hold off

pict1 = strcat(FileBase,'-',PerBegtxt,'-',PerEndtxt,'_PSD');
print( '-f1', '-depsc2', pict1);





