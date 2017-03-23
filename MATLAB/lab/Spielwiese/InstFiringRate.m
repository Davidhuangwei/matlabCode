function [Rate,Aspike] = InstFiringRate(tx,Rat,Res)

%% computes the instantaneous firing rate of neuron with spikes Res
%% Res = spiket(find(spikeind==i)); using tx as time bins
%%
%% returns Rate in whl sampling rate
%% 

nt = Rat(:,1);
dt = tx(2)-tx(1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% spike times, spike locations

%% get the spike times for ith neuron
NRes = round(Res/512);
NNRes = NRes(find(NRes>=nt(1) & NRes<=nt(end)));

%% get bins in whl (wich starts at e.g. t(1)=177)
NNRes = NNRes -nt(1)+1;

Aspike(:,1) = Rat(NNRes,1); %% spike time-bins (wheel-unit)
Aspike(:,2) = Rat(NNRes,2); %% angle
Aspike(:,3) = Rat(NNRes,3); %% direction
Aspike(:,4) = Rat(NNRes,4); %% radius
Aspike(:,5) = Rat(NNRes,5); %% speed
    
%plot(Aspike(:,1)/40,Aspike(:,2),'.')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% compute instantaneous firing rate 

%% turn spikes into continuous instantaneous firing rate
[hspike] = histcI(Aspike(:,1),tx);
hspike = hspike/dt*40;
fhspike = mySmooth(hspike,2);

%% use for analysis histogram or smoothed histgaram
Rate = hspike;


return;



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% AVERAGES etc:
AvAsp(i,:) = mean(Aspike(:,2:5),1);

%% Triogometry
s1 = mean(cos(Aspike(:,2)*pi/180));
s2 = mean(sin(Aspike(:,2)*pi/180));
if s1>0 & s2>0
  mphase = atan(s2/s1);
elseif s1<0
  mphase = atan(s2/s1)+pi;
elseif s2<0 & s1>0
  mphase = atan(s2/s1)+2*pi;
end
centphase = Aspike(:,2)*pi/180-mphase; %% centered phase
m1Phase = mean(cos(centphase));        %% first moment
m2Phase = mean(cos(2*centphase));      %% second moment
dispPhase = (1-m2Phase)/(2*m1Phase^2); %% dispersion

Phase(i,1) = RSRat(find(max(rate)));   %% phase of max firing rate
Phase(i,2) = AvAsp(i,1);               %% averaged phase
Phase(i,3) = mphase*180/pi;            %% mean phase
Phase(i,4) = dispPhase;                %% dispersion

%end


%%%%
%%%% !!! take out outliers
%%%% 
%%%% [Included Excluded] = OutlierRemove(Data, pVal)



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

return;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  %% place-phase for each time bin 
  %tphase = Rat(tx2-nt(1)+1,2);
  
  %% select the phases of the occupied bins
  %phase = tphase(find(hhspike>0));
  %tbin = tx2(find(hhspike>0));
   
  %cfigure
  %subplot(211)
  %plot(Aspike(:,1)/40,Aspike(:,2),'g.',tbin/40,phase,'ro');
  %subplot(212)
  %plot(phase,rate,'.')
  
  %% get speed from the phase intervals, smooth
  %speed1 = diff(tphase)/dt*40;
  %speed1(end+1) = speed1(end);
  %smspeed = mySmooth(speed1,2);
  %speed= fspeed3(find(hhspike>0))';
    
  %foo = fspeed1(NNRes);
  %speed = foo()
  

  
  
  
      %for ii=1:3
    %  jj=jj+1;
    %  subplot(3,3,jj)
    %  iBins = {inBins{1}; inBins{4}};
    %  %[Av Std Bins] = myMakeAve([RSRat(:,1) RSRat(:,4)],log(RPStat(ii,:,6)),iBins);
    %  [Av Std Bins OcMap] = myMakeAve([RSRat(:,1) RSRat(:,ii)],rate,iBins);
    %  %imagesc(Bins{1},Bins{2},mySmooth(Av,1)');
    %  imagesc(Bins{1},Bins{2},Av');
    %  set(gca, 'ydir', 'normal')
    %  colorbar
    %  clear Av Std Bins
    %end
    

    
    
    
        
    %cfigure(2)
    %%scatter(RPStat(1,:,1),RPStat(2,:,1),20,RPStat(3,:,1));
    %jj = 0;
    %for ii=1:3
    %  jj=jj+1;
    %  subplot(3,3,jj)  
    %  scatter(RSRat(:,4),rate,50,RPStat(ii,:,6));
    %  set(gca, 'ydir', 'normal')
    %  colorbar
    %end
    %for ii=1:3
    %  jj=jj+1;
    %  subplot(3,3,jj)  
    %  scatter(RSRat(:,4),rate,50,RPStat(ii,:,3));
    %  set(gca, 'ydir', 'normal')
    %  colorbar
    %end
  
  
