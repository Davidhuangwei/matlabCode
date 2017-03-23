function [xy,xytimes]=acquirePST(finalfilename,sessionn)
% ACQUIREPST is a function in the "TRACK ANIMALS ONLINE" toolbox.
%
% This function acquires the 2 dimensional location of the animal in the
% swimming chamber at a high temporal and spatial res olution.  
%
% Sample entry:
%[xy,xytimes]=acquirePST('TG1 PST1',1);

ptopt=0;

% Set-up specific input
klength=28;

if sessionn==1
    tmin=15;
elseif sessionn==2
    tmin=10;
elseif sessionn==0
    tmin=5;
else
    tmin= input ('How many minutes the session should last? ...')
end

close all; pack
vid=videoinput('dt',1);
vid.FrameGrabInterval = 1;
vid.Tag='Online analysis of PORSOLT SWIMMING TEST';
vid.FramesPerTrigger=tmin*25*60;
vid.Timeout=120; % in seconds
%vid.Previewing='on';

% get a sample image
start(vid);data=getdata(vid,1);stop(vid)

% define region of interest
figure(1); imshow(data); set(gcf,'Name','Please select FRAMESTART, WIDTH and HEIGHT in this order')
flims=ginput(3);
set(vid,'ROIPosition',[flims(1,1) flims(1,2) flims(2,1)-flims(1,1) flims(3,2)-flims(1,2)])

line ([flims(1,1) flims(2,1)],[min(flims(:,2)) min(flims(:,2))],'Color',[0 1 0],'LineWidth',3)
line ([flims(2,1) flims(2,1)],[min(flims(:,2)) max(flims(:,2))],'Color',[0 1 0],'LineWidth',3)
line ([flims(1,1) flims(2,1)],[max(flims(:,2)) max(flims(:,2))],'Color',[0 1 0],'LineWidth',3)
line ([min(flims(:,1)) min(flims(:,1))],[min(flims(:,2)) max(flims(:,2))],'Color',[0 1 0],'LineWidth',3)

continueopt=menu('Is the place assignment correct?','YES','NO');
    
if continueopt==2
    disp ('Please choose new place assignments. The program is now stopped!')
    xy=[];
    xytimes=[];
    close all
    return
end

close all
figure; set(gcf,'Name','Please mark the start and end of a known object');
imshow(uint8(data));

% Calculate resolution
kobj=ginput(2); close all
%klength= input('What is the length of the object that you just selected...');
imres=klength/round(kobj(2,1)-kobj(1,1));

illumlevel=data;
clear data
clc

% get a second sample image with the new image size
start(vid);
data=getdata(vid,1);
stop(vid);

close all
set(gcf,'Name','Please select the start and end of the pool first in X then Y dimensions');
figure(1); imshow(data);
xydim=ginput(4);

hold on
% Draw a circle
center=xydim(1,1)+round((xydim(2,1)-xydim(1,1))/2);
center(2)=xydim(end-1,2)+round((xydim(end,2)-xydim(end-1,2))/2);
radius=round((xydim(2,1)-xydim(1,1))/2);

THETA=linspace(0,2*pi,10000);
RHO=ones(1,10000)*radius;
[X,Y] = pol2cart(THETA,RHO);
X=X+center(1);
Y=Y+center(2);
H=plot(X,Y,'r.');
axis square;
close

disp(['Processing: ' finalfilename])
disp('In order to continue please press a key')
pause
clc
disp(['Processing: ' finalfilename])
disp(' ACQUIRING DATA. PLEASE WAIT!')

%  to track black object
data=double(data); setuptemp=data;

%cols=[min(min(data)) min(min(data))+40]; 
xylims=[size(data,2) size(data,1)];

%figure(100); axis([0 xylims(1) 0 xylims(2)]);hold on
start(vid)
for lp=1:vid.FramesPerTrigger

    %wait(vid)
    data=getdata(vid,1);
    if isempty(data)==0
        %preview(vid)
        %flushdata(vid)
        %data analysis
      
       % bw=roicolor(data,min(cols),max(cols));
       bw=roicolor(data,min(min(data)),min(min(data))+40);

        ncols=sum(bw);nrows=sum(bw');

        %gncols(lp,:)=sum(bw);
        %gnrows(lp,:)=sum(bw');

        %     nrows=smooth(nrows,'raverage',10,0,2);
        %     ncols=smooth(ncols,'raverage',10,0,2);
        %
        %     [tmpr,tempnrows]=max(nrows(lp,:));
        %     [tmpr,tempncols]=max(ncols(lp,:));
        %
        [tmpr,tempnrows]=max(nrows);
        [tmpr,tempncols]=max(ncols);

        xy(lp,1)=tempnrows;
        xy(lp,2)=tempncols;
        xytimes(lp,:)=clock;

        %     figure (99)
        %     plot(xy(:,1),xy(:,2),'b'); hold on; redimscreen;
        %     axis([0 500 0 500])
        clear tmpr ncols nrows bw tempnrows tempncols
    else % these are the dropped frames
        xy(lp,1)=1;
        xy(lp,2)=1;
        xytimes(lp,:)=clock;
    end

end
wait(vid)
stop(vid)
close all

lastframe=data; circlex=X; circley=Y;
clear data
save([finalfilename '.mat'],'xy','xytimes','setuptemp','imres','illumlevel','lastframe','circlex','circley')

if ptopt==1
    figure (100); plot (xy(:,2),xy(:,1),'b.'); title([finalfilename ' studied on ' date]);
    set(gca,'YDir','reverse');
    axis([2 size(setuptemp,2) 2 size(setuptemp,1)]);
    hold on; 
    H=plot(X,Y,'r.');
    axis square
    print;
end
clc

save([finalfilename '.mat'],'xy','xytimes','setuptemp','imres','illumlevel','lastframe','circlex','circley')
delete(vid);

