if animal is not on center arm
    
find the first trial (rl or lr first)
get eeg data for full time period of first trial + 1 time window on each side
calculate spectrogram on time chunk 

for each time in time chunk determine maze location
if animal is on xp trial assign average value to positions 1:5
if animal is on center arm,delay area, or choice point
    assign linear position (x)
else
    assign radial position
next trial

if ~exist('trialTypesBool','var') | isempty(trialTypesBool)
    trialTypesBool = [1  0  1  0  0   0   0   0   0   0   0   0  0];
                   % lr rr rl ll lrp rrp rlp llp lrb rrb rlb llb xp
end
if ~exist('mazeLocationsBool', 'var') | isempty(mazeLocationsBool)
    mazeLocationsBool = [1  1  1  1  1  1   1   1   1];
                      % rp lp dp cp ca rca lca rra lra
end
 

trialTypesBool = [1  0  0  0  0   0   0   0   0   0   0   0  0];
               % lr rr rl ll lrp rrp rlp llp lrb rrb rlb llb xp
lrTrials = loadmazetrialtypes(filebasemat(i,:),trialTypesBool,mazeLocationsBool);

trialTypesBool = [0  0  1  0  0   0   0   0   0   0   0   0  0];
               % lr rr rl ll lrp rrp rlp llp lrb rrb rlb llb xp
rlTrials = loadmazetrialtypes(filebasemat(i,:),trialTypesBool,mazeLocationsBool);

trialTypesBool = [0  0  0  0  0   0   0   0   0   0   0   0  1];
               % lr rr rl ll lrp rrp rlp llp lrb rrb rlb llb xp
xpTrials = loadmazetrialtypes(filebasemat(i,:),trialTypesBool,mazeLocationsBool);

trialTypesBool = [1  0  1  0  0   0   0   0   0   0   0   0  1];
               % lr rr rl ll lrp rrp rlp llp lrb rrb rlb llb xp
mazeLocationsBool = [1  1  1  1  1  1   1   1   1];
                  % rp lp dp cp ca rca lca rra lra
xpTrials = loadmazetrialtypes(filebasemat(i,:),trialTypesBool,mazeLocationsBool);


videoRes = [368, 240];
filebasemat = 'sm9608_301';
trialTypesBool = [1  1  1  1   1  1   1   1   1   1   1   1   0];
               % lr rr rl ll lrp rrp rlp llp lrb rrb rlb llb xp
mazeLocationsBool = [0  0  1  1  1  0   0   0   0];
                  % rp lp dp cp ca rca lca rra lra
whldat = loadmazetrialtypes(filebasemat(1,:),trialTypesBool,mazeLocationsBool);

linCenterWhl = -1*ones(length(whldat),1);
linCenterWhl = videoRes(1) - whldat(:,1);




filebasemat = 'sm9608_301';
figure(3)
hold on
trialTypesBool = [1  1  1  1   1  1   1   1   1   1   1   1   0];
               % lr rr rl ll lrp rrp rlp llp lrb rrb rlb llb xp
mazeLocationsBool = [1  1  0  0  0  1   1   1   1];
                  % rp lp dp cp ca rca lca rra lra
perimeter = loadmazetrialtypes(filebasemat(1,:),trialTypesBool,mazeLocationsBool);
plot(perimeter(:,1),perimeter(:,2),'.')

trialTypesBool = [1  1  1  1   1  1   1   1   1   1   1   1   0];
               % lr rr rl ll lrp rrp rlp llp lrb rrb rlb llb xp
mazeLocationsBool = [0  0  0  0  1  0   0   0   0];
                  % rp lp dp cp ca rca lca rra lra
centerArm = loadmazetrialtypes(filebasemat(1,:),trialTypesBool,mazeLocationsBool);

centerArmCenter = [mean(centerArm(find(centerArm(:,1)~=-1),1)) mean(centerArm(find(centerArm(:,1)~=-1),2))];
perimeterCenter = [mean(perimeter(find(perimeter(:,1)~=-1),1)) mean(perimeter(find(perimeter(:,1)~=-1),2))];

% Find the points on the maze that correspond to the Top Right Quadrant
topRightQuad = perimeter(find(perimeter(:,1)>perimeterCenter(1) & perimeter(:,2)>centerArmCenter(2)),[1 2]);
plot(topRightQuad(:,1),topRightQuad(:,2),'.','color',[1 0 0])
% Find the Bottom point in this quadrant
minTopRightPoint = [topRightQuad(find(min(topRightQuad(:,2))==topRightQuad(:,2)),1) topRightQuad(find(min(topRightQuad(:,2))==topRightQuad(:,2)),2)-1];
topRightPoint = minTopRightPoint(1,:);
plot(topRightPoint(1),topRightPoint(2),'.','color',[0 1 0],'Markersize',15)
% Find the points on the maze that correspond to the Top Left Quadrant
topLeftQuad = perimeter(find(perimeter(:,1)<perimeterCenter(1) & perimeter(:,2)>centerArmCenter(2)),[1 2]);
plot(topLeftQuad(:,1),topLeftQuad(:,2),'.','color',[0 0 0])
% Find the Bottom point in this quadrant
minTopLeftPoint = [topLeftQuad(find(min(topLeftQuad(:,2))==topLeftQuad(:,2)),1) topLeftQuad(find(min(topLeftQuad(:,2))==topLeftQuad(:,2)),2)-1];
topLeftPoint = minTopLeftPoint(1,:);
plot(topLeftPoint(1),topLeftPoint(2),'.','color',[0 1 0])
% Plot the "rezero" line that will be used to reorient the top half of the maze
plot([topRightPoint(1) topLeftPoint(1)],[topRightPoint(2) topLeftPoint(2)],'color',[0 0 0])
% Plot the origin of the rotation
topCenter = [perimeterCenter(1), mean([topRightPoint(2), topLeftPoint(2)])];
plot(topCenter(1),topCenter(2),'.','color',[1 0 0])

topLinCircleWhl = -1*ones(length(perimeter),1);
trialTypesBool = [1  1  1  1   1  1   1   1   1   1   1   1   0];
               % lr rr rl ll lrp rrp rlp llp lrb rrb rlb llb xp
mazeLocationsBool = [0  1  0  0  0  0   1   0   1];
                  % rp lp dp cp ca rca lca rra lra
topMazeArms = loadmazetrialtypes(filebasemat(1,:),trialTypesBool,mazeLocationsBool);
topMazeArms(find(topMazeArms==-1)) = NaN;
% Linearize the top half of the maze before correction
topLinCircleWhl(find(~isnan(topMazeArms(:,1)))) = (atan2(topMazeArms(find(~isnan(topMazeArms(:,1))),2)-topCenter(2),topMazeArms(find(~isnan(topMazeArms(:,1))),1)-topCenter(1)));


% Find the points on the maze that correspond to the Bottom Right Quadrant
bottomRightQuad = perimeter(find(perimeter(:,1)>perimeterCenter(1) & perimeter(:,2)<centerArmCenter(2)),[1 2]);
plot(bottomRightQuad(:,1),bottomRightQuad(:,2),'.','color',[1 0 0])
% Find the Top point in this quadrant
maxBottomRightPoint = [bottomRightQuad(find(max(bottomRightQuad(:,2))==bottomRightQuad(:,2)),1) bottomRightQuad(find(max(bottomRightQuad(:,2))==bottomRightQuad(:,2)),2)+1];
bottomRightPoint = maxBottomRightPoint(1,:);
plot(bottomRightPoint(1),bottomRightPoint(2),'.','color',[0 1 0])
% Find the points on the maze that correspond to the Bottom Left Quadrant
bottomLeftQuad = perimeter(find(perimeter(:,1)<perimeterCenter(1) & perimeter(:,2)<centerArmCenter(2)),[1 2]);
plot(bottomLeftQuad(:,1),bottomLeftQuad(:,2),'.','color',[0 0 0]) 
% Find the Top point in this quadrant
maxBottomLeftQuad =  [bottomLeftQuad(find(max(bottomLeftQuad(:,2))==bottomLeftQuad(:,2)),1) bottomLeftQuad(find(max(bottomLeftQuad(:,2))==bottomLeftQuad(:,2)),2)+1];
bottomLeftPoint = maxBottomLeftQuad(1,:);
plot(bottomLeftPoint(1),bottomLeftPoint(2),'.','color',[0 1 0])
% Plot the "rezero" line that will be used to reorient the top half of the maze
plot([bottomRightPoint(1) bottomLeftPoint(1)],[bottomRightPoint(2) bottomLeftPoint(2)],'color',[0 0 0])
% Plot the origin of the rotation
bottomCenter = [perimeterCenter(1), mean([bottomRightPoint(2), bottomLeftPoint(2)])];
plot(bottomCenter(1),bottomCenter(2),'.','color',[1 0 0])

bottomLinCircleWhl = -1*ones(length(perimeter),1);
trialTypesBool = [1  1  1  1   1  1   1   1   1   1   1   1   0];
               % lr rr rl ll lrp rrp rlp llp lrb rrb rlb llb xp
mazeLocationsBool = [1  0  0  0  0  1   0   1   0];
                  % rp lp dp cp ca rca lca rra lra
bottomMazeArms = loadmazetrialtypes(filebasemat(1,:),trialTypesBool,mazeLocationsBool);
bottomMazeArms(find(bottomMazeArms==-1)) = NaN;
bottomLinCircleWhl(find(~isnan(bottomMazeArms(:,1)))) = abs(atan2(bottomMazeArms(find(~isnan(bottomMazeArms(:,1))),2)-bottomCenter(2),bottomMazeArms(find(~isnan(bottomMazeArms(:,1))),1)-bottomCenter(1)));

linCircleWhl = -1*ones(length(perimeter),1);
linCircleWhl(find(topLinCircleWhl~=-1)) = topLinCircleWhl(find(topLinCircleWhl~=-1));
% Linearize the top half of the maze before correction
linCircleWhl(find(bottomLinCircleWhl~=-1)) = bottomLinCircleWhl(find(bottomLinCircleWhl~=-1));

figure(1)
clf
plot(linCircleWhl,'.')
hold on

%%%%%%% The Following Rotates the Perimeter Maze Arms so that Bottom %%%%%%
%%%%%%% and Top Maze Arms Use full 0-3.14 Degrees (in Radians)       %%%%%%
% The basic plan is as follows:
% subtract 'origin' from each point
% find adjustment angle
% find angle of each point relative to zero degrees
% find new location relative to origin using angle+adjustment angle
% re-add 'origin' for drawing

figure(4)
clf
hold on
plot(topMazeArms(:,1),topMazeArms(:,2),'.','color',[0 0 1])
topCenter = [perimeterCenter(1), mean([topRightPoint(2), topLeftPoint(2)])];
relTopMazeArms = [topMazeArms(:,1)-topCenter(1) topMazeArms(:,2)-topCenter(2)];
topAdjAngle = acos((topRightPoint(1)-topLeftPoint(1))/sqrt((topRightPoint(1)-topLeftPoint(1))^2+(topRightPoint(2)-topLeftPoint(2))^2));
topAdjAngle = topAdjAngle/2;
topMazeArmAmgles = acos(relTopMazeArms(:,1)./sqrt(relTopMazeArms(:,2).^2 + relTopMazeArms(:,1).^2));
testRelTopMazeArms = [(cos(topMazeArmAmgles).*sqrt(relTopMazeArms(:,2).^2 + relTopMazeArms(:,1).^2)) (sin(topMazeArmAmgles ).*sqrt(relTopMazeArms(:,2).^2 + relTopMazeArms(:,1).^2))];
adjRelTopMazeArms = [(cos(topMazeArmAmgles + topAdjAngle).*sqrt(relTopMazeArms(:,2).^2 + relTopMazeArms(:,1).^2)) (sin(topMazeArmAmgles + topAdjAngle).*sqrt(relTopMazeArms(:,2).^2 + relTopMazeArms(:,1).^2))];
adjTopMazeArms = [adjRelTopMazeArms(:,1) + topCenter(1) adjRelTopMazeArms(:,2) + topCenter(2)];
figure(4)
plot(adjTopMazeArms(:,1),adjTopMazeArms(:,2),'.','color',[1 0 0])
plot([0 368],[min(adjTopMazeArms(:,2)) min(adjTopMazeArms(:,2))],'k')

figure(5)
clf
hold on
plot(bottomMazeArms(:,1),bottomMazeArms(:,2),'.','color',[0 0 1])
bottomCenter = [perimeterCenter(1), mean([bottomRightPoint(2), bottomLeftPoint(2)])];
relBottomMazeArms = [bottomMazeArms(:,1)-bottomCenter(1) bottomMazeArms(:,2)-bottomCenter(2)];
bottomAdjAngle = acos((bottomRightPoint(1)-bottomLeftPoint(1))/sqrt((bottomRightPoint(1)-bottomLeftPoint(1))^2+(bottomRightPoint(2)-bottomLeftPoint(2))^2));
bottomAdjAngle = bottomAdjAngle/2;
bottomMazeArmAmgles = -acos(relBottomMazeArms(:,1)./sqrt(relBottomMazeArms(:,2).^2 + relBottomMazeArms(:,1).^2));
testRelBottomMazeArms = [(cos(bottomMazeArmAmgles).*sqrt(relBottomMazeArms(:,2).^2 + relBottomMazeArms(:,1).^2)) (sin(bottomMazeArmAmgles ).*sqrt(relBottomMazeArms(:,2).^2 + relBottomMazeArms(:,1).^2))];
adjRelBottomMazeArms = [(cos(bottomMazeArmAmgles + bottomAdjAngle).*sqrt(relBottomMazeArms(:,2).^2 + relBottomMazeArms(:,1).^2)) (sin(bottomMazeArmAmgles + bottomAdjAngle).*sqrt(relBottomMazeArms(:,2).^2 + relBottomMazeArms(:,1).^2))];
adjBottomMazeArms = [adjRelBottomMazeArms(:,1) + bottomCenter(1) adjRelBottomMazeArms(:,2) + bottomCenter(2)];
figure(5)
plot(adjBottomMazeArms(:,1),adjBottomMazeArms(:,2),'.','color',[1 0 0])
plot([0 368],[max(adjBottomMazeArms(:,2)) max(adjBottomMazeArms(:,2))],'k')

% Now calculate the angle of each point to linearize the perimeter
adjTopLinCircleWhl = -1*ones(length(perimeter),1);
adjBottomLinCircleWhl = -1*ones(length(perimeter),1);
adjTopLinCircleWhl(find(~isnan(adjTopMazeArms(:,1)))) = (atan2(adjTopMazeArms(find(~isnan(adjTopMazeArms(:,1))),2)-topCenter(2),adjTopMazeArms(find(~isnan(adjTopMazeArms(:,1))),1)-topCenter(1)));
adjBottomLinCircleWhl(find(~isnan(adjBottomMazeArms(:,1)))) = abs(atan2(adjBottomMazeArms(find(~isnan(adjBottomMazeArms(:,1))),2)-bottomCenter(2),adjBottomMazeArms(find(~isnan(adjBottomMazeArms(:,1))),1)-bottomCenter(1)));
adjLinCircleWhl = -1*ones(length(perimeter),1);
adjLinCircleWhl(find(adjTopLinCircleWhl~=-1)) = adjTopLinCircleWhl(find(adjTopLinCircleWhl~=-1));
adjLinCircleWhl(find(adjBottomLinCircleWhl~=-1)) = adjBottomLinCircleWhl(find(adjBottomLinCircleWhl~=-1));

% plot the adjusted linearization
figure(1)
clf
plot([1:length(adjLinCircleWhl)]+200,adjLinCircleWhl,'.','color',[1 0 0])

linearizedWhl = -1*ones(length(returnArms),1);
perimeterRadius = mean(sqrt((perimeterCenter(1)-perimeter(find(perimeter(:,1)~=-1),1)).^2 + (perimeterCenter(2)-perimeter(find(perimeter(:,1)~=-1),2)).^2));
returnArmOffset = 100;
delayPortOffset = 275;
centerArmOffset = 400;
choicePointOffset = 550;
rewardArmOffset = 600;
waterPortsOffset = 750;

trialTypesBool = [0  0  0  0  0   0   0   0   0   0   0   0   1];
               % lr rr rl ll lrp rrp rlp llp lrb rrb rlb llb xp
mazeLocationsBool = [1  1  1  1  1  1   1   1   1];
                  % rp lp dp cp ca rca lca rra lra
exploration = loadmazetrialtypes(filebasemat(1,:),trialTypesBool,mazeLocationsBool);
linearizedWhl(find(exploration(:,1) ~= -1)) = abs(exploration(find(exploration(:,1) ~= -1),1)-max(exploration(:,1)));

trialTypesBool = [1  1  1  1   1  1   1   1   1   1   1   1   0];
               % lr rr rl ll lrp rrp rlp llp lrb rrb rlb llb xp
mazeLocationsBool = [0  0  0  0  0  0   0   1   1];
                  % rp lp dp cp ca rca lca rra lra
returnArms = loadmazetrialtypes(filebasemat(1,:),trialTypesBool,mazeLocationsBool);
linearizedWhl(find(returnArms(:,1) ~= -1)) = abs(adjLinCircleWhl(find(returnArms(:,1) ~= -1)) - max(adjLinCircleWhl(find(returnArms(:,1) ~= -1))))*perimeterRadius + returnArmOffset;

trialTypesBool = [1  1  1  1   1  1   1   1   1   1   1   1   0];
               % lr rr rl ll lrp rrp rlp llp lrb rrb rlb llb xp
mazeLocationsBool = [0  0  1  0  0  0   0   0   0];
                  % rp lp dp cp ca rca lca rra lra
delayPort = loadmazetrialtypes(filebasemat(1,:),trialTypesBool,mazeLocationsBool);
linearizedWhl(find(delayPort(:,1) ~= -1)) = abs(delayPort(find(delayPort(:,1) ~= -1),1)-max(delayPort(:,1))) + delayPortOffset;

trialTypesBool = [1  1  1  1   1  1   1   1   1   1   1   1   0];
               % lr rr rl ll lrp rrp rlp llp lrb rrb rlb llb xp
mazeLocationsBool = [0  0  0  0  1  0   0   0   0];
                  % rp lp dp cp ca rca lca rra lra
centerArm = loadmazetrialtypes(filebasemat(1,:),trialTypesBool,mazeLocationsBool);
linearizedWhl(find(centerArm(:,1) ~= -1)) = abs(centerArm(find(centerArm(:,1) ~= -1),1)-max(centerArm(:,1))) + centerArmOffset;

trialTypesBool = [1  1  1  1   1  1   1   1   1   1   1   1   0];
               % lr rr rl ll lrp rrp rlp llp lrb rrb rlb llb xp
mazeLocationsBool = [0  0  0  1  0  0   0   0   0];
                  % rp lp dp cp ca rca lca rra lra
choicePoint = loadmazetrialtypes(filebasemat(1,:),trialTypesBool,mazeLocationsBool);
linearizedWhl(find(choicePoint(:,1) ~= -1)) = abs(choicePoint(find(choicePoint(:,1) ~= -1),1)-max(choicePoint(:,1))) + choicePointOffset;

trialTypesBool = [1  1  1  1   1  1   1   1   1   1   1   1   0];
               % lr rr rl ll lrp rrp rlp llp lrb rrb rlb llb xp
mazeLocationsBool = [0  0  0  0  0  1   1   0   0];
                  % rp lp dp cp ca rca lca rra lra
rewardArms = loadmazetrialtypes(filebasemat(1,:),trialTypesBool,mazeLocationsBool);
linearizedWhl(find(rewardArms(:,1) ~= -1)) = abs(adjLinCircleWhl(find(rewardArms(:,1) ~= -1)) - max(adjLinCircleWhl(find(rewardArms(:,1) ~= -1))))*perimeterRadius + rewardArmOffset;

trialTypesBool = [1  1  1  1   1  1   1   1   1   1   1   1   0];
               % lr rr rl ll lrp rrp rlp llp lrb rrb rlb llb xp
mazeLocationsBool = [1  1  0  0  0  0   0   0   0];
                  % rp lp dp cp ca rca lca rra lra
waterPorts = loadmazetrialtypes(filebasemat(1,:),trialTypesBool,mazeLocationsBool);
linearizedWhl(find(waterPorts(:,1) ~= -1)) = abs(adjLinCircleWhl(find(waterPorts(:,1) ~= -1)) - max(adjLinCircleWhl(find(waterPorts(:,1) ~= -1))))*perimeterRadius + waterPortsOffset;

figure(2)
plot(linearizedWhl,'.');