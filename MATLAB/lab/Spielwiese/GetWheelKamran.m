function wheel = GetWheelKamran(FileBase,varargin)
% function wheel = GetWheelKamran(FileBase,WhlCtr,varargin)
% [overwrite,dist] = DefaultArgs(varargin,{0,1});
%
% dist: factor to convert wheel count into meters meters = WCount*dist
% 
% output: wheel data in EegRate
[overwrite,mdist] = DefaultArgs(varargin,{0,1});

%% Wheel data - in EegRate
if overwrite
  load([FileBase '.wheel'],'-MAT')

  %% wheel count
  WCount = wheel.count;
  
  %% wheel position
  WPos = wheel.pos;
  
  %% running speed
  WSpeed = wheel.speed; 

  %% Check Eeg
  load([FileBase '.elc'],'-MAT');
  tt = [1:length(WSpeed)]/wheel.whlrate;
  m = (WCount(end)-WCount(1))/max(tt);
  yy = WCount-m*tt';
  CheckEegStates(FileBase,'Wheel',[{tt,[],WSpeed,'plot'};{tt,[],WPos(:,1),'plot'};{tt,[],yy,'plot'}],[1 100],elc.theta,1);
  go = input('go? ');

  run = load([FileBase '.sts.Wheel']); %% in Eeg rate

  %% distance
  plus = zeros(size(WCount));
  for n=1:size(run,1)-1
    plus(run(n,1):run(n+1,1)) = WCount(run(n,1));
  end
  plus(run(n+1,1):end) = WCount(run(n+1,1));
  dist = (WCount-plus)*mdist;
  
  %% get future right vers. left trial
  dir = ones(size(run,1),1)*2;
  dir(find(dist(run(:,2))<0)) = 3;
  
  wheel.distfact = mdist; % ??????? CHECK THIS!!!
  wheel.dist = abs(dist); 
  wheel.runs = run;
  wheel.dir = dir;
  
  save([FileBase '.wheel'],'wheel')
else
  load([FileBase '.wheel'],'-MAT')
end

return;

