%function fgvsrip(filename,chnum, eegch, unitsel,highband, lowband, threshold)
function fgvsripisi(filename,chnum, eegch, unitsel,highband, lowband, threshold, tbin, binnum)

%filename='32309s';
if nargin<8
tbin=5;
binnum=50;
end
fn=[pwd '/' filename '/' filename];
swfname=[fn '.sw.' num2str(lowband) '-' num2str(highband) '-' num2str(threshold) ];
if ~FileExists(swfname)
    event=sdetect_a(strcat(fn,'.eeg'),chnum, eegch,highband, lowband, threshold);
    msave(swfname,event);
else
    event=load(swfname);
end

%figure
tit=[filename '.' num2str(unitsel) ', ' num2str(lowband) '-' num2str(highband) ', ' num2str(threshold)]

%sw2clusCC(filename,unitsel,0,tbin,binnum,event)
ISIinSW(filename,unitsel,0,tbin,binnum,event)
ax=axis;
text(ax(1),-ax(4)/4,tit)