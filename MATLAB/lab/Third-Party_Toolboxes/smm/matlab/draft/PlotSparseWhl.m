function PlotSparseWhl(fileBaseMat,newFs)

whlFs = 39.065;
sampInterval = round(39.065/newFs);
lowCut1 = 6;
highCut1 = 14;
lowCut2 = 40;
highCut2 = 100;
nchannels = 97;
fileExt = '.eeg';
figure(10)
clf
hold on;
channels = 49:64;
centerArmComodData = [];
rReturnArmComodData = [];
lReturnArmComodData = [];
rGoalArmComodData = [];
lGoalArmComodData = [];
TjunctionComodData = [];
for i=1:size(fileBaseMat,1)
    whldat = LoadMazeTrialTypes(fileBaseMat(i,:));
        notMinusOnes = whldat(:,1)~=-1;

    plot(whldat(notMinusOnes,1),whldat(notMinusOnes,2),'.','color',[0.5 0.5 0.5]);
end
for j=1:length(channels)
    channel = channels(j);
for i=1:size(fileBaseMat,1)
    whldat = LoadMazeTrialTypes(fileBaseMat(i,:));
    centerArm = LoadMazeTrialTypes(fileBaseMat(i,:),[],[0   0   0  0  1   0   0   0  0]);
                                                     % rwp lwp  da Tj ca rga lga rra lra
    rReturnArm = LoadMazeTrialTypes(fileBaseMat(i,:),[],[0   0   0  0  0  0   0  1   0]);
    lReturnArm = LoadMazeTrialTypes(fileBaseMat(i,:),[],[0   0   0  0  0  0   0  0   1]);
    rGoalArm = LoadMazeTrialTypes(fileBaseMat(i,:),  [],[0   0   0  0  0  1   0   0  0]);
    LGoalArm = LoadMazeTrialTypes(fileBaseMat(i,:),  [],[0   0   0  0  0  0   1   0  0]);
    Tjunction = LoadMazeTrialTypes(fileBaseMat(i,:), [],[0   0   0  1  0  0   0   0  0]);
    dspowname1 = [fileBaseMat(i,:) '_' num2str(lowCut1) '-' num2str(highCut1) 'Hz' fileExt '.100DBdspow'];
    fprintf('Loading: %s\n',dspowname1);
    powerdat1 = ((bload(dspowname1,[nchannels inf],0,'int16')')/100);
  
    dspowname2 = [fileBaseMat(i,:) '_' num2str(lowCut2) '-' num2str(highCut2) 'Hz' fileExt '.100DBdspow'];
    fprintf('Loading: %s\n',dspowname2);
    powerdat2 = ((bload(dspowname2,[nchannels inf],0,'int16')')/100);


    sampledPoints = zeros(size(whldat,1),1);
    sampledPoints(1:sampInterval:end) = 1;
    notMinusOnes = whldat(:,1)~=-1;
    figure(10)
    plot(whldat(notMinusOnes & sampledPoints,1),whldat(notMinusOnes & sampledPoints,2),'.','color',[1 0 0]);
    
    centerArmComodData = cat(1,centerArmComodData,[whldat(centerArm(:,1)~=-1 & sampledPoints,1), whldat(centerArm(:,1)~=-1 & sampledPoints,2), ...
        powerdat1(centerArm(:,1)~=-1 & sampledPoints,channel), powerdat2(centerArm(:,1)~=-1 & sampledPoints,channel)]);
    rReturnArmComodData = cat(1,rReturnArmComodData,[whldat(rReturnArm(:,1)~=-1 & sampledPoints,1), whldat(rReturnArm(:,1)~=-1 & sampledPoints,2), ...
        powerdat1(rReturnArm(:,1)~=-1 & sampledPoints,channel), powerdat2(rReturnArm(:,1)~=-1 & sampledPoints,channel)]);
    lReturnArmComodData = cat(1,lReturnArmComodData,[whldat(lReturnArm(:,1)~=-1 & sampledPoints,1), whldat(lReturnArm(:,1)~=-1 & sampledPoints,2), ...
        powerdat1(lReturnArm(:,1)~=-1 & sampledPoints,channel), powerdat2(lReturnArm(:,1)~=-1 & sampledPoints,channel)]);
    rGoalArmComodData = cat(1,rGoalArmComodData,[whldat(rGoalArm(:,1)~=-1 & sampledPoints,1), whldat(rGoalArm(:,1)~=-1 & sampledPoints,2), ...
        powerdat1(rGoalArm(:,1)~=-1 & sampledPoints,channel), powerdat2(rGoalArm(:,1)~=-1 & sampledPoints,channel)]);
    lGoalArmComodData = cat(1,lGoalArmComodData,[whldat(LGoalArm(:,1)~=-1 & sampledPoints,1), whldat(LGoalArm(:,1)~=-1 & sampledPoints,2), ...
        powerdat1(LGoalArm(:,1)~=-1 & sampledPoints,channel), powerdat2(LGoalArm(:,1)~=-1 & sampledPoints,channel)]);
    TjunctionComodData = cat(1,TjunctionComodData,[whldat(Tjunction(:,1)~=-1 & sampledPoints,1), whldat(Tjunction(:,1)~=-1 & sampledPoints,2), ...
        powerdat1(Tjunction(:,1)~=-1 & sampledPoints,channel), powerdat2(Tjunction(:,1)~=-1 & sampledPoints,channel)]);
end

figure(10+j)
clf
subplot(3,3,5)
plot(centerArmComodData(:,3),centerArmComodData(:,4),'.')
subplot(3,3,9)
plot(rReturnArmComodData(:,3),rReturnArmComodData(:,4),'.')
subplot(3,3,7)
plot(lReturnArmComodData(:,3),lReturnArmComodData(:,4),'.')
subplot(3,3,3)
plot(rGoalArmComodData(:,3),rGoalArmComodData(:,4),'.')
subplot(3,3,1)
plot(lGoalArmComodData(:,3),lGoalArmComodData(:,4),'.')
subplot(3,3,2)
plot(TjunctionComodData(:,3),TjunctionComodData(:,4),'.')
centerArmComodData = [];
rReturnArmComodData = [];
lReturnArmComodData = [];
rGoalArmComodData = [];
lGoalArmComodData = [];
TjunctionComodData = [];

end
