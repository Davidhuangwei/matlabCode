function CalcUnitFreq(fileBaseCell,analDirName)



datSamp = 20000;
newSamp = 1250;
timeWin = 0.5;

clu = load('sm9603-237.clu.7');
res = load('sm9603-237.res.7');
res7_1 = res7(find(clu7==1)-1);
spikeBin = Accumulate(round(res7_1/(datSamp/newSamp)));
spikeBinTime = (1:max(res7_1))/(datSamp/newSamp);
%res7_1/(datSamp/newSamp);

paramb = [];
paramb.fs = 500;
paramb.pad = 1;
paramb.tapers = [3 5];

time = LoadVar('/BEEF01/smm/sm9603_Analysis/3-21-04/analysis/sm9603m2_237_s1_281/CalcRunningSpectra9_noExp_MidPoints_MinSpeed0Win626.eeg/time.mat');
eegSegTime =  LoadVar('/BEEF01/smm/sm9603_Analysis/3-21-04/analysis/sm9603m2_237_s1_281/CalcRunningSpectra9_noExp_MidPoints_MinSpeed0Win626.eeg/eegSegTime.mat');
mazeLocation = LoadVar('/BEEF01/smm/sm9603_Analysis/3-21-04/analysis/sm9603m2_237_s1_281/CalcRunningSpectra9_noExp_MidPoints_MinSpeed0Win626.eeg/mazeLocation.mat');
trialType = LoadVar('/BEEF01/smm/sm9603_Analysis/3-21-04/analysis/sm9603m2_237_s1_281/CalcRunningSpectra9_noExp_MidPoints_MinSpeed0Win626.eeg/trialType.mat');

centerArm = sum(mazeLocation.*repmat([0 0 0 0 1 0 0 0 0],length(time),1),2)>0.6 & ...
    sum(trialType.*repmat([1 0 1 0 0 0 0 0 0 0 0 0 0],length(time),1),2)>0.7;
returnArm = sum(mazeLocation.*repmat([0 0 0 0 0 1 1 0 0],length(time),1),2)>0.6 & ...
    sum(trialType.*repmat([1 0 1 0 0 0 0 0 0 0 0 0 0],length(time),1),2)>0.7;
tJunction = sum(mazeLocation.*repmat([0 0 0 1 0 0 0 0 0],length(time),1),2)>0.6 & ...
    sum(trialType.*repmat([1 0 1 0 0 0 0 0 0 0 0 0 0],length(time),1),2)>0.7;
goalArm = sum(mazeLocation.*repmat([0 0 0 0 0 0 0 1 1],length(time),1),2)>0.6 & ...
    sum(trialType.*repmat([1 0 1 0 0 0 0 0 0 0 0 0 0],length(time),1),2)>0.7;

spikeBinBegins = time-timeWin;
trialBin = [];
for j=1:length(time)
    try trialBin(j,:) = spikeBin(find(spikeBinTime>(time(j)-timeWin) & spikeBinTime<(time(j)+timeWin)));
    catch
        j
        length(find(spikeBinTime>(time(j)-timeWin) & spikeBinTime<(time(j)+timeWin)))
    end
end

[S,f,R]=mtspectrumpb(trialBin',paramb);

for j=1:size(S,2)
plot(f*newSamp,S(:,j))
set(gca,'ylim',[0 1])
if ~isempty(input('anything Breaks: ','s'));
    break
end
end

plot(f*newSamp,mean(S,2))

mean(R(centerArm))
mean(R(returnArm))
mean(R(tJunction))
mean(R(goalArm))


arms = cat(2,returnArm,centerArm,tJunction,goalArm);
colors = [0 0 1;1 0 0;0 1 0;0.5 0.5 0.5];
clf
hold on
plot(f*newSamp,mean(S,2),'ko')
for j=1:size(arms,2)
    plot(f*newSamp,mean(S(:,arms(:,j)),2),'o','color',colors(j,:))
end
   


