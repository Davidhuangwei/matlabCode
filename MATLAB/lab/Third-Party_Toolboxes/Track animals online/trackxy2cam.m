function [xy,xytimes]=trackxy2cam(finalfilename)

close all; pack

vid=videoinput('dt',1);
vid.FrameGrabInterval = 1; 
vid.Tag='Online analysis of mouse behavior';
vid.FramesPerTrigger=16000;
vid.Timeout=30; % in seconds

vid2=videoinput('winvideo',1);
vid2.FrameGrabInterval = 1; 
vid2.Tag='Online analysis of mouse behavior';
vid2.FramesPerTrigger=16000;
vid2.Timeout=30; % in seconds
set(vid2.VideoFormat)='RGB24_640x480';

start(vid2); 

keyboard

% get a sample image
start(vid); data=getdata(vid,1); stop(vid)
data2=getdata(vid2,1); data2=rgb2gray(data2); stop(vid2)

% define region of interest
figure(1); imshow(data); set(gcf,'Name','Please select FRAMESTART, WIDTH and HEIGHT in this order')
flims=ginput; set(vid,'ROIPosition',[flims(1,1) flims(1,2) flims(2,1)-flims(1,1) flims(3,2)-flims(1,2)])

figure(2); imshow(data2); set(gcf,'Name','Please select FRAMESTART, WIDTH and HEIGHT in this order')
flims2=ginput; set(vid2,'ROIPosition',[flims2(1,1) flims2(1,2) flims2(2,1)-flims2(1,1) flims2(3,2)-flims2(1,2)])

clear data data2
close all

% get a second sample image with the new image size
start(vid); data=getdata(vid,1); stop(vid);
start(vid2); data2=getdata(vid2,1); stop(vid2);


figure(1); imshow(data); pause
xydat=ginput; xydat=round(xydat); data=double(data);

figure(2); imshow(data2); pause
xydat2=ginput; xydat2=round(xydat2); data2=double(data2);

for lp=1:size(xydat,1)
    cols(lp,1)=data(xydat(lp,2),xydat(lp,1));    
end

for lp2=1:size(xydat2,1)
    cols2(lp2,1)=data(xydat2(lp2,2),xydat2(lp2,1));    
end

xylims=[size(data,2) size(data,1)]; close all
xylims2=[size(data2,2) size(data2,1)]; 


start(vid)
start(vid2)
for lp=1:vid.FramesPerTrigger
    
    
    data=getdata(vid,1); data2=getdata(vid2,2);
    flushdata(vid);flushdata(vid2)
    
    bw=roicolor(data,min(cols),max(cols));
    ncols=sum(bw);nrows=sum(bw');

    bw2=roicolor(data2,min(cols2),max(cols2));
    ncols2=sum(bw2);nrows2=sum(bw2');

    %nrows=smooth(nrows,'raverage',10,0,2);
    %ncols=smooth(ncols,'raverage',10,0,2);
    
    [tmpr,tempnrows]=max(nrows);[tmpr,tempncols]=max(ncols);
    [tmpr2,tempnrows2]=max(nrows2);[tmpr2,tempncols2]=max(ncols2);
    
    xy(lp,1)=tempnrows;xy(lp,2)=tempncols;xytimes(lp,:)=clock;
    xy2(lp,1)=tempnrows2;xy2(lp,2)=tempncols2;xytimes2(lp,:)=clock;
    
    %figure(100); plot(tempncols,tempnrows,'r.'); axis([0 xylims(1) 0 xylims(2)]);hold on
    
    clear tmpr ncols nrows bw tmpr2 ncols2 nrows2 bw2
    
end

wait(vid); wait(vid2)
stop(vid); stop(vid2)

save([finalfilename '.mat'],'xy','xytimes')
delete(vid);clear;close(gcf)
delete(vid2);clear;close(gcf2)

