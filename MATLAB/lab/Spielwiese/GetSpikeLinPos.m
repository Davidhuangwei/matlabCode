function lspike = GetSpikeLinPos(spikepos,trials,ltrials,varargin)
[maxl] = DefaultArgs(varargin,{10000}); 
%%
%%
%newpos = spikepos;

%keyboard;

countmax = floor(size(spikepos,1)/maxl);
  
if countmax >0 
  for nn=1:countmax
    indx = [(nn-1)*maxl+1:maxl*nn];
    dx = spikepos(indx,1)*ones(size(trials,1),1)'-ones(maxl,1)*trials(:,1)';
    dy = spikepos(indx,2)*ones(size(trials,1),1)'-ones(maxl,1)*trials(:,2)';
    dist = sqrt(dx.^2 + dy.^2);
    [clpoint clindx] = sort(dist,2);
    
    point1(indx,:) = [clpoint(:,1) clindx(:,1)];
    point2(indx,:) = [clpoint(:,2) clindx(:,2)];
    
    %point1(indx,:) = trials(clindx(:,1),:);
    %point2(indx,:) = trials(clindx(:,2),:);
  end
  clear indx dx dy dist clpoint clindx;
else
  maxl=0;
  nn=0;
end

indx = [nn*maxl+1:size(spikepos,1)];
dx = spikepos(indx,1)*ones(size(trials,1),1)'-ones(length(indx),1)*trials(:,1)';
dy = spikepos(indx,2)*ones(size(trials,1),1)'-ones(length(indx),1)*trials(:,2)';
dist = sqrt(dx.^2 + dy.^2);
[clpoint clindx] = sort(dist,2);
point1(indx,:) = [clpoint(:,1) clindx(:,1)];
point2(indx,:) = [clpoint(:,2) clindx(:,2)];


%% now, use the whole thing:

%% compute angle between point and spike
angl1 = angle((spikepos(:,1)-trials(point1(:,2),1)) + i*(spikepos(:,2)-trials(point1(:,2),2)));
angl2 = angle((trials(point2(:,2),1)-trials(point1(:,2),1)) + i*(trials(point2(:,2),2)-trials(point1(:,2),2)));

%% angle difference:
dangl(:,1) = angl1-angl2;

%dangl(find(dangl>180),1) = 360 - (angl1(find(dangl>180),1)-angl2(find(dangl>180),1));
%dangl(find(dangl>-180),1) = 360 + (angl1(find(dangl>-180),1)-angl2(find(dangl>-180),1));

dxx(:,1) = cos(dangl).*point1(:,1);


lspike = ltrials(point1(:,2),1)+dxx.*sign(ltrials(point2(:,2),1)-ltrials(point1(:,2),1));

%keyboard

return;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




for nn=1:length(spikepos)
  %% find the closest trace-point
  dx = trials(:,1)-spikepos(nn,1);
  dy = trials(:,2)-spikepos(nn,2);
  dist = sqrt(dx.^2 + dy.^2);
  %% the two interesting points are: clindx(1) and clindx(2)
  [clpoint clindx] = sort(dist);
  
  %% the two closest points:
  point1 = trials(clindx(1),:);
  point2 = trials(clindx(2),:);
      
  %% compute angle between point and spike
  angl1 = angle((spikepos(nn,1)-point1(1)) + i*(spikepos(nn,2)-point1(2)));
  angl2 = angle((point2(1)-point1(1)) + i*(point2(2)-point1(2)));
  
  %% angle difference:
  dangl = angl1-angl2;
  if dangl>180
    dangl = 360 - (angl1-angle2);
  elseif dangl<-180
    dangl = 360 + (angl1-angle2);
  end
  
  dxx = cos(abs(dangl))*clpoint(1);
  linxx = ltrials(clindx(1),1)+dxx*sign(ltrials(clindx(2),1)-ltrials(clindx(2),1));
  
  lspike(nn,1) = linxx;
end

return;
