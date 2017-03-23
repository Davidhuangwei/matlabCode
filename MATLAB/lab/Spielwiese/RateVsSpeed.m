function Speed = RateVsSpeed(FileBase,whl,trial,spike,PlaceCell,Tune,varargin)
[overwrite,Plotting] = DefaultArgs(varargin,{0,0});
% function Speed = RateVsSpeed(FileBase,whl,trial,spike,PlaceCell,varargin)
% [overwrite] = DefaultArgs(varargin,{0});
%
% Rate vs. Speed
%
% output:


RateFactor = 20000/whl.rate;

if ~FileExists([FileBase '.ratespeed']) | overwrite
  
  cells = unique(PlaceCell.ind(:,1));
  mrate = [];
  for neu=1:size(PlaceCell.ind,1)
    
    neuron = find(cells==PlaceCell.ind(neu,1));
    dire = PlaceCell.ind(neu,4);
    gtrials = find(trial.dir(find(trial.dir>1))==dire);
    
    Speed = Tune.speed(:,gtrials);
    Rate = Tune.rate(gtrials,:,neuron)';
    Count = Rate./Speed;
    
    LinPF = round(PlaceCell.lfield(neu,:));
    
    MeanRate = mean(Rate(LinPF(1):LinPF(2),:));
    MaxRate = max(Rate(LinPF(1):LinPF(2),:));
    MeanSpeed = mean(Speed(LinPF(1):LinPF(2),:));
    TotCount = sum(Count(LinPF(1):LinPF(2),:));

    mrate = [mrate; [neu*ones(size(MeanSpeed))' MeanSpeed' MeanRate' MaxRate' TotCount']];
    goodRate = find(MaxRate>5);
    
    %% Rate
    [b stat] = robustfit(MeanSpeed(goodRate),MeanRate(goodRate));
    slopeR(neu,:) = [neu b(2) stat.p(2) b(1) stat.p(1)];
    [rho, pval] = corr(MeanSpeed(goodRate)',MeanRate(goodRate)');
    rcorrR(neu,:) = [rho pval];

    %% Count
    [b stat] = robustfit(MeanSpeed(goodRate),TotCount(goodRate));
    slopeC(neu,:) = [neu b(2) stat.p(2) b(1) stat.p(1)];
    [rho, pval] = corr(MeanSpeed(goodRate)',TotCount(goodRate)');
    rcorrC(neu,:) = [rho pval];
   
    %% Plot
    if Plotting
      subplot(121)
      plot(MeanSpeed(goodRate),MeanRate(goodRate),'.')
      hold on
      plot(MeanSpeed(goodRate),MeanSpeed(goodRate)*slopeR(neu,2)+slopeR(neu,4),'r')
      hold off
      title(['cell ' num2str(PlaceCell.ind(neu,1)) ' type ' num2str(PlaceCell.ind(neu,5)) ...
	     ' || p=' num2str(round(1000*rcorrR(neu,2))/1000) ' r=' num2str(round(1000*rcorrR(neu,1))/1000)])
      
      subplot(122)
      plot(MeanSpeed(goodRate),TotCount(goodRate),'.')
      hold on
      plot(MeanSpeed(goodRate),MeanSpeed(goodRate)*slopeC(neu,2)+slopeC(neu,4),'r')
      hold off
      title(['cell ' num2str(PlaceCell.ind(neu,1)) ' type ' num2str(PlaceCell.ind(neu,5)) ... 
	     ' || p=' num2str(round(1000*rcorrC(neu,2))/1000) ' r=' num2str(round(1000*rcorrC(neu,1))/1000)])
      
      waitforbuttonpress
    end
      
    clear Speed Rate gtrials LinPF 
  end
  
  %% ountput
  Speed.slopeRate = slopeR;
  Speed.rcorrRate = rcorrR;
  Speed.slopeCout = slopeC;
  Speed.rcorrCout = rcorrC;
  Speed.mean = mrate;
  
  %% SAVE
  save([FileBase '.ratespeed'],'Speed')
else
  load([FileBase '.ratespeed'],'-MAT');
end

return

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


Speed.ind = allspeed(:,1:3);
Speed.whl = allspeed(:,4);
Speed.lwhl = allspeed(:,5);
Speed.spiketime = allspeed(:,6);
Speed.rate = allspeed(:,7);

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
