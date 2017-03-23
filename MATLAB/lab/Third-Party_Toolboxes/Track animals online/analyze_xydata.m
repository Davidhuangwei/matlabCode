function analyze_xydata (data,ptopt)
% ANALYZE_XYDATA is a function in the ANALYSIS OF BEHAVIOR toolbox.  
%
% This function allows user to import data collected with TRACKXY program, again
% in the toolbox.  TRACKXY collects spatiotemporal pattern of movement of animals online,
% while ANALYZE_XYDATA performs statistics and visualization of the data offline. 
% 
% INPUTS
% DATA is a string vector pointing the data to be analyzed.
%       i.e. 'TC2_310304_NIE2_D21'
% PTOPT is 1 if you would like to print figures plotted by the program.  Enter 0 if you don't
%
% analyze_xydata('FF160_openfield',0)

% Tansu Celikel
% All rights reserved
% March-2004


%Evgeny Resnik: batch processing
% clr
% files = dir('FF*_openfield.mat')
% for f=1:length(files)
%     analyze_xydata(files(f).name,0); close all
% end


close all;warning off

% Clean the data off the noise
killnoise (data,0);

% Archive info about the data file
file.name=data; 
file.final=(['Analyze_XYdata_'  file.name '.mat']); 
file.dir=cd;
file.date=date; file.created_by='analyze_xydata.m';
file.data_by='Florian Freudenberg';
file.printopt=ptopt;
file.DataAnalyzedUsing='analyze_xydata';
file.DataFrom=cd;

clear finalfilename data pixelres ptopt

% Load the data
load ([file.name]);
file.resolution=imres; % in centimeters specified by user

% rdata.x=xy(1:10000,1);
% rdata.y=xy(1:10000,2);
% z=(xytimes(1:10000,5)*100)+xytimes(1:10000,6); % in seconds

rdata.x=xy(:,1);
rdata.y=xy(:,2);
z=(xytimes(1:length(rdata.x),5)*100)+xytimes(1:length(rdata.x),6); % in seconds
rdata.duration=etime(xytimes(length(rdata.x),:),xytimes(1,:));
rdata.times=[0:rdata.duration/size(z,1):rdata.duration-(rdata.duration/size(z,1))]';


clear xytimes z

% find out the density of occurences 
density_matrix=zeros(max(rdata.x),max(rdata.y)); 

for lp=1:size(rdata.x,1);
    if floor(rdata.y(lp))==0
        density_matrix(floor(rdata.x(lp)),1)=density_matrix(floor(rdata.x(lp)),1)+1;
    elseif floor(rdata.x(lp))==0
        density_matrix(1,floor(rdata.y(lp)))=density_matrix(1,floor(rdata.y(lp)))+1;
    else
        density_matrix(floor(rdata.x(lp)),floor(rdata.y(lp)))=density_matrix(floor(rdata.x(lp)),floor(rdata.y(lp)))+1;
    end
end
clear lp

% Plot raw data
figure (1); 
plot_rawmotdata (rdata,file);
set(gca,'YDir','reverse');
axis ([1 size(setuptemp,2) 1 size(setuptemp,1)]);
%print ([file.name '_Figure1.png'], '-dpng');
print ('-dill', [file.name '_Figure1.ai']);orient landscape
saveas(gcf, [file.name '_Figure1.pdf'], 'pdf')
if file.printopt==1; orient landscape; print; end

figure (2); set(gcf,'Name','Exploration data divided into subareas');redimscreen
%supert('Distribution of motor exploration ratios in subareas of the arena');
%subtitle([file.name]);

for lp=2:5
    dstamp=densitystamps(density_matrix,lp);
    subplot(2,2,lp-1); dstampnorm=(dstamp./sum(sum(dstamp)))*100;

    %  table(dstampnorm,2,'%'); original Tanus's script which is missing
    plottable(dstampnorm); title('Distribution of occupancy time (%)') % replacing script 

    stamps{lp,1}=dstamp;  
    clear dstamp xycoor ctr dstampnorm
end
%print ([file.name '_Figure2.png'], '-dpng');
print ('-dill', [file.name '_Figure2.ai']);orient landscape
saveas(gcf, [file.name '_Figure2.pdf'], 'pdf')

if file.printopt==1; orient landscape; print; end
clear lp 



% Plot trajectory
figure (3); 
plot_trajectory (rdata,file); set(gca,'YDir','reverse')
axis ([1 size(setuptemp,2) 1 size(setuptemp,1)]);
%print ([file.name '_Figure3.png'], '-dpng');
print ('-dill', [file.name '_Figure3.ai']);orient landscape
saveas(gcf, [file.name '_Figure3.pdf'], 'pdf')

if file.printopt==1; orient landscape; print; end

% Calculate and plot minute-by-minute motor activity
x1=get(gca,'XLim'); y1=get(gca,'YLim');

fullmins=floor(rdata.duration/60);

figure (4); 
set(gcf,'Name','Trajectory of movement:minute-by-minute')

for lp=1:fullmins
    subplot(ceil(fullmins/3),3,lp);
    temp=[1+(60*(lp-1)) lp*60];
    tempind=find (rdata.times>=temp(1) & rdata.times<temp(2));
    if size(rdata.times,1)>size(rdata.x,1)
    rdata.times=rdata.times(1:size(rdata.x,1));
    end

    plot3 (rdata.y(tempind),rdata.x(tempind),rdata.times(tempind),'b-'); set(gca,'YDir','reverse')
    %axis ([x1(1) x1(2) y1(1) y1(2)]);xaxisoff; yaxisoff
    axis ([1 size(setuptemp,2) 1 size(setuptemp,1)]);

    title (['Activity between (min) ' num2str(lp-1) '-' num2str(lp)])
    raw_minbymin{lp,1}=[rdata.x(tempind) rdata.y(tempind) rdata.times(tempind)];
    clear temp tempind 
end
redimscreen

%print ([file.name '_Figure4.png'], '-dpng');
print ('-dill', [file.name '_Figure4.ai']);orient landscape
saveas(gcf, [file.name '_Figure4.pdf'], 'pdf')



% Calculate "home-bases"
distance=rdata;
density_matrix=fliplr(density_matrix);
distance.DensityMatrix=density_matrix;
distance.Stamps=stamps;

clear density_matrix lp fullmins x1 y1 stamps


% calculate the density matrix with pixel resolution of 1 cm 
temp1=round(1/imres); 
stps=1:temp1:size(distance.DensityMatrix,1);

ctr=1;

for lp=2:size(stps,2); % Rows
    if lp<size(stps,2)
        temp(ctr,:)=sum(distance.DensityMatrix(stps(lp):stps(lp+1)-1,:));
    else
        temp(ctr,:)=sum(distance.DensityMatrix(stps(lp):size(distance.DensityMatrix,1)));
    end
    ctr=ctr+1;
end

clear lp ctr stps

ctr=1;
stps=1:temp1:size(temp,2);

for lp=1:size(stps,2); % COlumns
    if lp<size(stps,2)
        temp2(:,ctr)=sum(temp(:,stps(lp):stps(lp+1)-1)')';
    else
        temp2(:,ctr)=sum(temp(:,stps(lp):size(temp,2))')';
    end
    ctr=ctr+1;
end
    
distance.DensityMatrix_cmbins=temp2;
clear lp ctr stps temp temp2

figure (5); 
set(gcf, 'Name', 'Density matrix')

imagesc(fliplr(distance.DensityMatrix_cmbins));

% if you want to plot the density matrix in the original acquisition resolution, then use the following command
%imagesc(fliplr(distance.DensityMatrix));

xlabel('X coordinate'); ylabel('Y coordinate')
title(['Density data:' file.name]); colorbar; redimscreen 
%print ([file.name '_Figure5.png'], '-dpng');
print ('-dill', [file.name '_Figure5.ai']);orient landscape
saveas(gcf, [file.name '_Figure5.pdf'], 'pdf')


%%%%%%% DATA ANALYSIS
% Distance travelled
distance.raw=real(sqrt((diff(rdata.x)'.^2)-(diff(rdata.y)'.^2))*file.resolution); 
distance.duration=diff(rdata.times)'; % times stamps of the xy sampling coordinates
distance.all=sum(distance.raw);       % total distance travelled during the recording
distance.median=median(distance.raw); % median of the distance distribution, calculated from consequtive frames
distance.mean=mean(distance.raw); % mean of the distribution
distance.std=std(distance.raw);   % std of the distribution
distance.max=max(distance.raw);   % max of the distribution
distance.min=min(distance.raw);   % min of the distribution

figure(6); 
[distance]=plot_quantmov (file,distance,rdata);
if file.printopt==1; orient landscape; print; end
print ('-dill', [file.name '_Figure6.ai']);orient landscape
saveas(gcf, [file.name '_Figure6.pdf'], 'pdf')


figure(8);
[distance]=plot_motormov (distance,file); 
%print ([file.name '_Figure8.png'], '-dpng');
print ('-dill', [file.name '_Figure8.ai']);orient landscape
saveas(gcf, [file.name '_Figure8.pdf'], 'pdf')

if file.printopt==1; orient landscape; print; end

save ([file.final])

