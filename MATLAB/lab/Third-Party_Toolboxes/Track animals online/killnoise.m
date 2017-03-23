function killnoise (data,ptopt)
% KILLNOISE is a function in the ANALYSIS OF BEHAVIOR toolbox.  
%
% This function allows user to clean the data collected from noise by removing high-speed noise
% in the data.  The cleaned data points are filled in using nearest neighbour interpolation to 
% keep the frame rate of the data the same across animals. 
%
% INPUTS
% DATA is a string vector pointing the data to be analyzed.
%       i.e. 'TC50 MOOP S1'
% PTOPT is 1 if you would like to plot the trace of exploration, before and after the noise cleaning
% killnoise ('TC50 MOOP S3')

% Tansu Celikel
% All rights reserved
if ptopt==1
    close all
end

load ([data])
% plot(xy(:,1),xy(:,2),'b.-')


cleanxy=xy; cleanxytimes=xytimes; xy_noisy=xy;
% First filter for those frames which were missed during acquisition.  The missing frames might be
% due to hardware limitations or other factors most of which relates to softwares.  
% The missing frames acquire the position of the animal as xy 1:1.  
ind2=find(xy(:,1)==1&xy (:,2)==1);
cleanxy(ind2,:)=[];
clear xy 

xy(:,1)=smooth(cleanxy(:,1),8);
xy(:,2)=smooth(cleanxy(:,2),8);
% plot(xy(:,1),xy(:,2),'b.-')

xy_noisy=xy;

if ptopt==1
    figure; plot (xy(:,2), xy(:,1), 'b.-'); redimscreen; title ('Raw data cleaned from noisy enteries');
    orient landscape
    print
end
save ([data],'illumlevel','imres','lastframe','setuptemp','xy','xytimes','xy_noisy')

disp(['Missed frames were discarded.'])
return


load ([data])
% First filter for those frames which were missed during acquisition.  The missing frames might be
% due to hardware limitations or other factors most of which relates to softwares.  
% The missing frames acquire the position of the animal as xy 1:1.  

ind2=find(xy(:,1)==1&xy (:,2)==1);
if isempty(ind2)==0
    for lp=1:size(ind2,1)
        xy(ind2(lp),:)=xy(ind2(lp)-1,:);
    end
end

rdata.x=xy(:,1);
rdata.y=xy(:,2);
z=(xytimes(:,5)*100)+xytimes(:,6); % in seconds
rdata.duration=etime(xytimes(end,:),xytimes(1,:));
rdata.times=[0:rdata.duration/size(z,1):rdata.duration-(rdata.duration/size(z,1))]';

distance.raw=real(sqrt((diff(rdata.x)'.^2)-(diff(rdata.y)'.^2))*imres); 
distance.duration=diff(rdata.times)'; % times stamps of the xy sampling coordinates

distance.histc.x=[0:100];
distance.histc.y=histc(distance.raw,[0:100]);


%nind=find(distance.raw>(mean(distance.raw)+(std(distance.raw)*10))); % indices of those noisy data points.
nind=[];
nind2=find(diff(xy(:,1))>10);
nind3=find(diff(xy(:,2))>10);
nind=sort([nind nind2' nind3']);


if ptopt==1
    figure; plot (xy(:,2), xy(:,1), 'b.-'); redimscreen; title ('Raw data')
end


if isempty(nind)==0 & max(distance.raw>10)
    xy_noisy=xy;
    ctr=1;
    
    % In the case of odd number of noisy points, remove the last noisy data entry 
    % in respect to the following frame
    if mod(size(nind,2),2)==1
        nind=[nind nind(end)+1];
    end
        
    for lp=1:2:length(nind)
        ctr=ctr+1;
        temp=[nind(lp)+1:nind(lp+1)];
        for lp2=1:length(temp)
            xy(temp(lp2),:)=xy(nind(lp),:);   % Nearest neighbour interpolation 
        end
    end
else
    xy_noisy=[];
end


if ptopt==1
    figure; plot (xy(:,2), xy(:,1), 'b.-'); redimscreen; title ('Raw data cleaned from noisy enteries')
end


save ([data],'illumlevel','imres','lastframe','setuptemp','xy','xytimes','xy_noisy')
disp(['Speed outliers were discarded.'])
return

if isempty(nind)==0 & max(distance.raw>10)
    dnind=diff(nind);
    onecond=find (dnind==1);
    if isempty(onecond)==1
        % Nearest neighbour interpolation
        
        rdata.x(nind,1)=rdata.x(nind+1,1);
        rdata.y(nind,1)=rdata.y(nind+1,1);
        % Recalculating the distance travelled
        distance.raw2=real(sqrt((diff(rdata.x)'.^2)-(diff(rdata.y)'.^2))*imres); 
        tempx=[0:100];
        tempy=histc(distance.raw2,[0:100]);
        nind=find (distance.raw>(mean(distance.raw)+std(distance.raw)*5)); % indices of those noisy data points.
    end
    
end
plot (tempx,tempy,'r'); hold on;


