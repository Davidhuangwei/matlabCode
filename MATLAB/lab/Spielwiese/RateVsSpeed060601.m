function Speed = RateVsSpeed(FileBase,whl,trial,spike,PlaceCell,varargin)
[Plotting,overwrite] = DefaultArgs(varargin,{1,0});
% function Speed = RateVsSpeed(FileBase,whl,trial,spike,PlaceCell,varargin)
% [overwrite] = DefaultArgs(varargin,{0});
%
% Rate vs. Speed
%
% output:
% Speed.ind       
% Speed.whl 
% Speed.lwhl
% Speed.spiketime
% Speed.rate
%

RateFactor = 20000/whl.rate;

if ~FileExists([FileBase '.ratespeed']) | overwrite
  
  count = 0;
  allspeed = [];
  for neu=1:length(PlaceCell.ind)
    if PlaceCell.ind(neu,5) ~= 1
      continue
    end
    
    fprintf([num2str(neu) '... ']);
    
    neuron = PlaceCell.ind(neu,1);
    dire = PlaceCell.ind(neu,4);
    trials = PlaceCell.trials(find(PlaceCell.trials(:,1)==neu),2:3);
    for tr = 1:length(trials)
      indx = find(spike.ind==neuron & spike.good & WithinRanges(round(spike.t/RateFactor),trials(tr,:)));
      
      if length(indx)<2 | unique(diff(spike.pos(indx)))==0
	continue
      end
      
      %% Spike Count
      speed(1:3) = [neu tr length(indx)];
      
      %% ave Speed of each trial in PF from whl.speed and lwhl
      speed(4) = mean(whl.speed(trials(tr,1):trials(tr,2),1));
      speed(5) = (PlaceCell.lfield(neu,2)-PlaceCell.lfield(neu,1))/(trials(tr,2)-trials(tr,1))*whl.rate;
      
      %% av. Speed of each spike time in trial 
      speed(6) = mean(whl.speed(round(spike.t(indx)/20000*whl.rate),1));
	
      %% av. Rate during trial
      %speed(7) = length(indx)/(trials(tr,2)-trials(tr,1))*whl.rate;
      
      allspeed = [allspeed;speed];
    end
    
    %% SLOPE
    %indx2 = find(allspeed(:,3)>0);
    indx2 = find(allspeed(:,1)==neu);
    [b stat] = robustfit(allspeed(indx2,4),allspeed(indx2,7));
    Speed.slopeWR(neu,:) = [neu b(2) stat.p(2) b(1) stat.p(1)];
    [b stat] = robustfit(allspeed(indx2,5),allspeed(indx2,7));
    Speed.slopeLWR(neu,:) = [neu b(2) stat.p(2) b(1) stat.p(1)];
    [b stat] = robustfit(allspeed(indx2,6),allspeed(indx2,7));
    Speed.slopeSWR(neu,:) = [neu b(2) stat.p(2) b(1) stat.p(1)];
    
    [b stat] = robustfit(allspeed(indx2,4),allspeed(indx2,3));
    Speed.slopeWC(neu,:) = [neu b(2) stat.p(2) b(1) stat.p(1)];
    [b stat] = robustfit(allspeed(indx2,5),allspeed(indx2,3));
    Speed.slopeLWC(neu,:) = [neu b(2) stat.p(2) b(1) stat.p(1)];
    [b stat] = robustfit(allspeed(indx2,6),allspeed(indx2,3));
    Speed.slopeSWC(neu,:) = [neu b(2) stat.p(2) b(1) stat.p(1)];
  end

  Speed.ind = allspeed(:,1:3);
  Speed.whl = allspeed(:,4);
  Speed.lwhl = allspeed(:,5);
  Speed.spiketime = allspeed(:,6);
  Speed.rate = allspeed(:,7);

  %% SAVE
  save([FileBase '.ratespeed'],'Speed')
else
  load([FileBase '.ratespeed'],'-MAT');
end

%% PLOT
if Plotting
  figure
  for neu=1:length(PlaceCell.ind)
    if PlaceCell.ind(neu,5) ~= 1
      continue
    end
    
    indx2 = find(Speed.ind(:,1)==neu);
    
    clf
    subplot(321)
    title(num2str(neu))
    plot(Speed.whl(indx2,1),Speed.rate(indx2,1),'.');hold on;
    plot(Speed.whl(indx2,1),Speed.slopeWR(neu,2)*Speed.whl(indx2,1)+Speed.slopeWR(neu,4),'r');
    subplot(322)
    plot(Speed.whl(indx2,1),Speed.ind(indx2,3),'.');hold on;
    plot(Speed.whl(indx2,1),Speed.slopeWC(neu,2)*Speed.whl(indx2,1)+Speed.slopeWC(neu,4),'r')
    
    subplot(323)
    plot(Speed.lwhl(indx2,1),Speed.rate(indx2,1),'.');hold on;
    plot(Speed.lwhl(indx2,1),Speed.slopeLWR(neu,2)*Speed.lwhl(indx2,1)+Speed.slopeLWR(neu,4),'r');
    subplot(324)
    plot(Speed.lwhl(indx2,1),Speed.ind(indx2,3),'.');hold on;
    plot(Speed.lwhl(indx2,1),Speed.slopeLWC(neu,2)*Speed.lwhl(indx2,1)+Speed.slopeLWC(neu,4),'r')
    
    subplot(325)
    plot(Speed.spiketime(indx2,1),Speed.rate(indx2,1),'.');hold on;
    plot(Speed.spiketime(indx2,1),Speed.slopeSWR(neu,2)*Speed.spiketime(indx2,1)+Speed.slopeSWR(neu,4),'r');
    subplot(326)
    plot(Speed.spiketime(indx2,1),Speed.ind(indx2,3),'.');hold on;
    plot(Speed.spiketime(indx2,1),Speed.slopeSWC(neu,2)*Speed.spiketime(indx2,1)+Speed.slopeSWC(neu,4),'r')
    waitforbuttonpress
  end
  
  figure
  indx3 = find(Speed.slopeWR(:,1)~=0);
  subplot(121)
  hist([Speed.slopeWR(indx3,2) Speed.slopeLWR(indx3,2) Speed.slopeSWR(indx3,2)]);
  title('Slope of Rate vs. Speed');
  subplot(122)
  hist([Speed.slopeWC(indx3,2) Speed.slopeLWC(indx3,2) Speed.slopeSWC(indx3,2)]);
  title('Slope of Count vs. Speed');
  
end


return;
