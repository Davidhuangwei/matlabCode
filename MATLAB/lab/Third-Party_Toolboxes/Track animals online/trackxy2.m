function [xy,xytimes]=trackxy2(finalfilename,tmin,ptopt,klength)
%[xy,xytimes]=trackxy('CP30 MOOP S1',6,1,60);

% Make sure that the file won't save to the same name
%if exist ([finalfilename '.mat'])==2
%    finalfilename=[finalfilename '_B'];    
%end

close all; pack
vid=videoinput('dt',1);
vid.FrameGrabInterval = 1;
vid.Tag='Online analysis of mouse behavior';
vid.FramesPerTrigger=tmin*25*60;
vid.Timeout=120; % in seconds
%vid.Previewing='on';

% get a sample image
start(vid);data=getdata(vid,1);stop(vid)

clc
disp (['Current file ' finalfilename])
disp (' ')
disp ('Data acquisition step 1 of 3:')
disp ('Please select the area to search for the mouse')

% define region of interest
figure(1); imshow(data); set(gcf,'Name','Please select FRAMESTART, WIDTH and HEIGHT in this order')
flims=ginput(3);
set(vid,'ROIPosition',[flims(1,1) flims(1,2) flims(2,1)-flims(1,1) flims(3,2)-flims(1,2)])

% for lp=1:size(flims,1)
%     figure(1); hold on
%     plot(flims(lp,1),flims(lp,2),'rs')
% end
line ([min(flims(:,1)) max(flims(:,1))],[min(flims(:,2)) min(flims(:,2))],'Color',[0 1 0],'LineWidth',3)
line ([flims(2,1) flims(2,1)],[min(flims(:,2)) max(flims(:,2))],'Color',[0 1 0],'LineWidth',3)
line ([flims(1,1) flims(2,1)],[max(flims(:,2)) max(flims(:,2))],'Color',[0 1 0],'LineWidth',3)
line ([min(flims(:,1)) min(flims(:,1))],[min(flims(:,2)) max(flims(:,2))],'Color',[0 1 0],'LineWidth',3)

continueopt=menu('Is the place assignment correct?','YES','NO');
    
if continueopt==2
    disp ('Please choose new place assignments. The program is now stopped!')
    xy=[]; xytimes=[]; close all;
    return
end

clc
disp (['Current file ' finalfilename])
disp (' ')
disp ('Data acquisition step 2 of 3:')
disp ('Please select the edge of the open field to allow the program to calculate pixel resolution')

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
disp(['Processing: ' finalfilename])
disp('In order to continue please press a key')

clc
disp (['Current file ' finalfilename])
disp (' ')
disp ('Data acquisition step 3 of 3:')
disp ('Please press a button to start acquiring animal position. Make sure that the mouse is already in the arena')
pause


% get a second sample image with the new image size
start(vid);
data=getdata(vid,1);
stop(vid);

%  to track black object
data=double(data); setuptemp=data;

%cols=[1 35];
xylims=[size(data,2) size(data,1)];

%figure(100); axis([0 xylims(1) 0 xylims(2)]);hold on
start(vid)

clc
disp (['Current file ' finalfilename])
disp (' ')
disp ('ACQUIRING DATA...')
disp (' Please Wait! ')

for lp=1:vid.FramesPerTrigger

    %wait(vid)
    data=getdata(vid,1);
    if isempty(data)==0
        %preview(vid)
        flushdata(vid)
        %data analysis
        %bw=roicolor(data,min(cols),max(cols));
        bw=roicolor(data,min(min(data)),min(min(data))+10);
        
        ncols=sum(bw);nrows=sum(bw');

      
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

lastframe=data;

save([finalfilename '.mat'],'xy','xytimes','setuptemp','imres','illumlevel','lastframe')

if ptopt==1
    figure (100); plot (xy(:,2),xy(:,1),'b.'); title([finalfilename ' studied on ' date]);
    axis square;redimscreen
    axis([2 size(setuptemp,2) 2 size(setuptemp,1)]);set(gca,'YDir','reverse');
    print;  
    
    %figure (101); plot (xy(:,2),xy(:,1),'r'); title([finalfilename ' studied on ' date]);
    %axis square;redimscreen
    %axis([2 size(setuptemp,2) 2 size(setuptemp,1)]);set(gca,'YDir','reverse');

end
clc

save([finalfilename '.mat'],'xy','xytimes','setuptemp','imres','illumlevel','lastframe')

delete(vid);


