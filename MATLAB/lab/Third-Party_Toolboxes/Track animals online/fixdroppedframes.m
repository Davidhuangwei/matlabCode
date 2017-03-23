function [xy,xytimes]=fixdroppedframes(data,ptopt)
% FIXDROPPEDFRAMES is a function in the ANALYSIS OF BEHAVIOR toolbox.  
%
% This function allows user to find the dropped frames in the data stream 
% and remove them. There is no interpolation performed by this program 
% to keep the raw data as is rather than confonding it with the function 
% assumed to interpolate the data
%
% INPUTS
% DATA is a string vector pointing the data to be analyzed.
%       i.e. 'TC50 MOOP S1'
% PTOPT is 1 if you would like to visually check the quality of the 
%       "cleaning"
%
% Sample entry
% [xy,xytimes]=fixdroppedframes ('H1KO01 PST1.mat',1);


% Tansu Celikel
% All rights reserved
% V.1 29 July 2005

if ptopt==1
    close all
end

load ([data])

ind2=find (xy(:,1)==1 & xy (:,2)==1);
xy(ind2,:)=[];
xytimes(ind2,:)=[];

return

rdata.x=xy(:,1);
rdata.y=xy(:,2);

% Calculate the timestamp for each frame
z=zeros(1,size(xytimes,2));
for lp=2:size(xytimes,1)
    z(lp)=etime(xytimes(lp,:),xytimes(lp-1,:)); % in seconds
end

rdata.duration=etime(xytimes(end,:),xytimes(1,:));
rdata.times=cumsum(z)';
keyboard
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

