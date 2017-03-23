function [Eeg,Trialsp]=PhasePressLap(base,unit)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% GET SPIKES, EEG ETC FOR EACH LAP


keys = {['A' 'N'],['A' 's'],['A' 'S'],['B' 'N'],['B' 's'],['B' 'S']};

Base = {'CS150618' 'CS150620' 'CS150628' 'CS150629' 'CS210829'};

%%files = unique(goodcells(:,1));

window = [-2 2];

basename = Base{base}
path = ['/u42/caro/Michael_data/data/' basename '/analyses/'];

SetCurrentSession(basename,path)
  
stimuli1 = GetEvents('keys',keys{1});
stimuli2 = GetEvents('keys',keys{4});

%clf
spikes = GetSpikes('units',unit);
pos = GetPositions('clean');

avpos(:,1) = pos(:,1);                %% time  
avpos(:,2) = (pos(:,2)+pos(:,4))/2;   %% x
avpos(:,3) = (pos(:,3)+pos(:,5))/2;   %% y
avpos(:,4) = sign(mySmooth(pos(:,2),20)-mySmooth(pos(:,4),20)); %% direction

inpolstim1 = interp1(avpos(:,1),avpos(:,2:end),stimuli1(:,1));
inpolstim2 = interp1(avpos(:,1),avpos(:,2:end),stimuli2(:,1));
inpolspike = interp1(avpos(:,1),avpos(:,2:end),spikes(:,1));

plot(inpolstim1(:,1),inpolstim1(:,2));

plot(avpos(:,2),avpos(:,3),'.',inpolstim1(:,1),inpolstim1(:,2),'r.');
plot(avpos(:,2),avpos(:,3),'.',inpolstim2(:,1),inpolstim2(:,2),'r.');
plot(avpos(:,2),avpos(:,3),'.',inpolspike(:,1),inpolspike(:,2),'r.');

[goodRuns,direction]=GoodRun(avpos(:,1),avpos(:,2),[],[50 100],0,0,length(avpos(:,1)));

%% get time intervals of episods to use
%% for the control case:

clf
plot(avpos(:,1),avpos(:,2))   
hold on
%Lines(goodRuns(:,1),[],'m');
%Lines(goodRuns(:,2),[],'y');
Lines(stimuli1(:,1),[],'g');
Lines(stimuli2(:,1),[],'r');



stim = sort([stimuli1(:,1);stimuli2(:,1)]);

[Burst, BurstLen, SpkPos, OutOf] = SplitIntoBursts(stim,100);

goodBurst = Burst(find(BurstLen>1));
goodBurstLen = BurstLen(find(BurstLen>1));

interval(:,1)=stim(goodBurst);
interval(:,2)=stim(goodBurst+goodBurstLen-1);

gspikes=[];
gsppos=[];
gphases=[];
for i=1:length(goodBurst)
  spikeph = [];
  timeInvl(i,1) = goodRuns(max(find((interval(i,1)-goodRuns(:,1))>0)),1);
  timeInvl(i,2) = goodRuns(min(find((interval(i,2)-goodRuns(:,2))<0)),2);

  Wspikes = spikes(find(spikes(:,1)>timeInvl(i,1)&spikes(:,1)<timeInvl(i,2)),1);
  gspikes = [gspikes;spikes(find(spikes(:,1)>timeInvl(i,1)&spikes(:,1)<timeInvl(i,2)),1)];
  gsppos = [gsppos;inpolspike(find(spikes(:,1)>timeInvl(i,1)&spikes(:,1)<timeInvl(i,2)),:)];
  
  % THETA
  eeg = GetEEG(timeInvl(i,:),'channels',9);
  if isempty(eeg), disp('No EEG'); continue; end
  % Get phases at these spike timestamps
  phases = myThetaPhase2(eeg(:,2),[4 20])*180/pi;
  phases(phases<0) = phases(phases<0)+360;
  phases = [eeg(:,1) phases(:,1)];
  %% spikeph = Interpolate(phases,gspikes,'trim','off')
  %% spikeph = Interpolate(phases,gspikes,'trim','off')
  spikeph(:,1) = Wspikes;
  spikeph(:,2) = interp1(phases(:,1),phases(:,2),Wspikes);
  gphases = [gphases; spikeph];

  %cfigure
  %plot(eeg(:,1),(eeg(:,2)-mean(eeg(:,2)))/std(eeg(:,2))*360);
  %hold on
  %plot(eeg(:,1),phases(:,2),'r');
  %waitforbuttonpress;

end

%% cut space
goodspikes = gspikes(find(gsppos(:,1)>50&gsppos(:,1)<250));
goodsppos = gsppos(find(gsppos(:,1)>50&gsppos(:,1)<250),:);
goodphase = gphases(find(gsppos(:,1)>50&gsppos(:,1)<250),2);

goodsp = [goodspikes goodsppos goodphase];

%% sort for arm and direction
goodsp1r = goodsp(find(goodsp(:,3)>140 & goodsp(:,4)<0),:);
goodsp1l = goodsp(find(goodsp(:,3)>140 & goodsp(:,4)>=0),:);

goodsp2r = goodsp(find(goodsp(:,3)<140 & goodsp(:,4)<0),:);
goodsp2l = goodsp(find(goodsp(:,3)<140 & goodsp(:,4)>=0),:);

goodsp = {goodsp1r goodsp1l goodsp2r goodsp2l};

cfigure
subplot(2,2,1)
plot(goodsp1r(:,2),goodsp1r(:,5),'.',goodsp1r(:,2),goodsp1r(:,5)+360,'.');
subplot(2,2,2)
plot(goodsp1l(:,2),goodsp1l(:,5),'.',goodsp1l(:,2),goodsp1l(:,5)+360,'.');
subplot(2,2,3)
plot(goodsp2r(:,2),goodsp2r(:,5),'.',goodsp2r(:,2),goodsp2r(:,5)+360,'.');
subplot(2,2,4)
plot(goodsp2l(:,2),goodsp2l(:,5),'.',goodsp2l(:,2),goodsp2l(:,5)+360,'.');

%% look trial by trial
selectstate = input('which state (1:4)? ');

tis1r = [goodsp1r(:,1)-1 goodsp1r(:,1)+1];
tis1l = [goodsp1l(:,1)-1 goodsp1l(:,1)+1];
tis2r = [goodsp2r(:,1)-1 goodsp2r(:,1)+1];
tis2l = [goodsp2l(:,1)-1 goodsp2l(:,1)+1];

tis = {tis1r tis1l tis2r tis2l};

Trials1r = ConsolidateTimeIntervals(tis1r);
Trials1l = ConsolidateTimeIntervals(tis1l);
Trials2r = ConsolidateTimeIntervals(tis2r);
Trials2l = ConsolidateTimeIntervals(tis2l);

Trial = {Trials1r Trials1l Trials2r Trials2l};

Eeg = [];
Trialsp=[];

cfigure;
for j=1:length(Trial)
  if isempty(tis{j})
    continue;
  end
  
  for i=1:length(Trial{j})
    eeg =  GetEEG(Trial{j}(i,:),'channels',9);
    eeg(:,3) = i;
    
    findsp = find(goodsp{j}(:,1)>Trial{j}(i,1)&goodsp{j}(:,1)<Trial{j}(i,2));

    if j==selectstate
      Eeg = [Eeg;eeg];

      trialsp=[];
      
      trialsp(:,1) = goodsp{j}(findsp,1);
      trialsp(:,2) = goodsp{j}(findsp,2);
      trialsp(:,3) = goodsp{j}(findsp,5);
      trialsp(:,4) = i;
      
      Trialsp = [Trialsp;trialsp];
      
    end    
    
    clf;
    subplot(3,1,1)
    plot(goodsp{j}(findsp,1),goodsp{j}(findsp,5),'.',goodsp{j}(findsp,1),goodsp{j}(findsp,5)+360,'.');
    xlim([min(eeg(:,1)) max(eeg(:,1))]);
    title(['task ' num2str(j) ' trial ' num2str(i)]);  
    subplot(3,1,2)
    plot(eeg(:,1),eeg(:,2))
    xlim([min(eeg(:,1)) max(eeg(:,1))]);
    subplot(3,1,3)
    Lines(goodsp{j}(find(goodsp{j}(:,1)>Trial{j}(i,1)&goodsp{j}(:,1)<Trial{j}(i,2)),1),[0 1],'r');
    xlim([min(eeg(:,1)) max(eeg(:,1))]);
    waitforbuttonpress;
  end
end

return;
