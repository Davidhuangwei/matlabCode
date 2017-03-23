function CalcMazeSpectrum(taskType,fileBaseMat,excludeLocations,minSpeed)

whlSamp = 39.065;
win = 626;
eegSamp = 1250;


if ~exist('minSpeed','var') | isempty(minSpeed)
    minSpeed = 0;
end
if ~exist('excludeLocations','var') | isempty(excludeLocations)
    excludeLocations = [1 1 1 0 0 0 0 0 0];
end

trialTypesBool = [1 1 1 1 1 1 1 1 1 1 1 1 1];
%trialTypesBool = [0 0 0 0 0 0 0 0 0 0 0 0 1];
%mazeLocationsBool = [0   0   0  1  1   1   1   1   1];

runningB = [];
figure;
hold on;


for j=1:size(fileBaseMat,1)
    fileBase = fileBaseMat(j,:);
    inName = [fileBase '_specgram_win' num2str(win) '.mat'];
    fprintf('Loading: %s\n' ,inName)
    load(inName);

    %running = LoadMazeTrialTypes(fileBase, trialTypesBool);
    drinking = LoadMazeTrialTypes(fileBase, trialTypesBool,excludeLocations);
    %running = LoadMazeTrialTypes(fileBase, trialTypesBool,[0 0 0 1 1 1 1 1 1]);
    %firstRun = find(running>-1);
    whldata = LoadMazeTrialTypes(fileBase, trialTypesBool,[1 1 1 1 1 1 1 1 1]);
    [speed accel] = MazeSpeedAccel(whldata);

    for i=1:length(t)
        whlIndexStart = max(1,round(whlSamp.*(t(i)-win/eegSamp)));
        whlIndexEnd = min(size(drinking,1),round(whlSamp.*(t(i)+win/eegSamp)));
        if ~isempty(find(whldata(whlIndexStart:whlIndexEnd,1) > -1)) & ...
                isempty(find(drinking(whlIndexStart:whlIndexEnd,1) > -1)) & ...
                isempty(find(speed(whlIndexStart:whlIndexEnd)<minSpeed & speed(whlIndexStart:whlIndexEnd)~=-1))
            runningB = cat(2,runningB,b(:,i,:));
            plot(whldata(whlIndexStart:whlIndexEnd,1),whldata(whlIndexStart:whlIndexEnd,2),'k.');
            %runningB = runningB+1;
        end
    end
    size(runningB)
end
 
b = 10.*log10(squeeze(mean(abs(runningB).^2,2)));

if minSpeed ~=0
    speedText = ['_minSpeed' num2str(minSpeed)];
else
    speedText = [];
end
keyboard
outName = [taskType speedText '_PSpectrum_Win_' num2str(win) 'DB.mat'];
fprintf('Saving: %s\n',outName);
save(outName, 'b','f','channels');
return
