function wheel = GetWheelEva(FileBase,WhlCtr,varargin)
% function wheel = GetWheelEva(FileBase,WhlCtr,varargin)
% [overwrite,EegRate,WhlRate,dist] = DefaultArgs(varargin,{0,1250,1250,1});
%
% dist: factor to convert wheel count into meters meters = WCount*dist
% 
% output: wheel data in EegRate
[overwrite,EegRate,WhlRate,mdist] = DefaultArgs(varargin,{0,1250,1250,1});

RateFact = EegRate/WhlRate;


%% Wheel data - in EegRate
if ~FileExists([FileBase '.wheel']) | overwrite
  
  %% load wheel-count data (data in 20000 sampling rate)
  %load([FileBase '_WheelLapsCW.mat'],'-MAT');
  load([FileBase '_WheelPulses.mat'],'-MAT');
  % transform into EegRate:
  Wee = unique(round(OneUp/16)); 
  %Wee2 = OneDown; Wee3 = TwoUp; Wee4 = TwoDown;
  
  %% take only OneUp....
  [t,intcount] = Interpol(Wee,[1:length(Wee)]');
  WCount = zeros(size(WhlCtr*RateFact,1),1);
  WCount(t,1) = intcount;
  WCount(t(end):end) = length(Wee);
    
  %% running distance in m;
  WDist = WCount*mdist;
  
  %% wheel position
  Weep = WhlCtr(:,:);
  
  %% running speed
  sWCount = smooth(WCount,500,'lowess');
  WSpeed(:,1) = mean([[diff(sWCount); 0] [0; diff(sWCount)]],2); 

  %% wheel running episodes (use CheckEegStates)
  if ~FileExists([FileBase '.sts.Wheel']) %| overwrite
    
    dist = 2*EegRate;
    dW = diff(Wee);
    Wint1 = Wee(find(dW>dist)+1);
    Wint2 = Wee(find(dW>dist));
    Wint = [Wint1(1:min([length(Wint1) length(Wint2)])) Wint2(1:min([length(Wint1) length(Wint2)])) ];
    %msave([FileBase '.sts.Wheel'],sort(Wint,2))
    
    load([FileBase '.elc'],'-MAT');
    Teeg = [1:length(WSpeed(:,1))]'/EegRate;
    xx = Wee/EegRate; yy = [1:length(Wee)]';
    m = (yy(end)-yy(1))/(xx(end)-xx(1)); b = yy(1)-m*xx(1);
    nyy = yy - m*xx-b;
    CheckEegStates(FileBase,'Wheel',[{Teeg,[],WSpeed,'plot'};{[1:length(WhlCtr)]/WhlRate,[],WhlCtr(:,1),'plot'};{xx,[],nyy','plot'}],[1 100],elc.theta,1);
    go = input('go? ');
  end
  run = load([FileBase '.sts.Wheel']); %% in Eeg rate

  %% get future right vers. left trial
  ask = input('select directions? [0/1] ');
  if ask
    figure(444);clf;
    plot(WhlCtr(:,1),WhlCtr(:,2),'.')
    title('mark (1) piece of right track, then (2) piece of left track')
    %% mark piece of right track
    [right rply] = myClusterPoints(WhlCtr,0);
    %% mark piece of left track
    [left lply] = myClusterPoints(WhlCtr,0);
    krun(:,1) = run(:,2);
    krun(:,2) = [run(2:end,1); size(WhlCtr,1)];
    for n=1:size(krun,1)
      figure(444);clf;
      plot(WhlCtr(1:100:end,1),WhlCtr(1:100:end,2),'.')
      hold on
      plot(WhlCtr(krun(n,1):krun(n,2),1),WhlCtr(krun(n,1):krun(n,2),2),'r.')
      if ~isempty(find(ismember(find(right),[krun(n,1):krun(n,2)])))
	wheel.dir(n) = 2;
      end
      if ~isempty(find(ismember(find(left),[krun(n,1):krun(n,2)])))
	wheel.dir(n) = 3;
      end
      if ~isempty(find(ismember(find(right),[krun(n,1):krun(n,2)]))) & ~isempty(find(ismember(find(left),[krun(n,1):krun(n,2)])))
	wheel.dir(n) = 0;
      elseif isempty(find(ismember(find(right),[krun(n,1):krun(n,2)]))) & isempty(find(ismember(find(left),[krun(n,1):krun(n,2)])))
	wheel.dir(n) = 0;
      end
      WaitForButtonpress
    end
  else
    wheel.dir = zeros(size(run,1),1);
  end
  
  %% distance
  plus = zeros(size(WCount));
  for n=1:size(run,1)-1
    plus(run(n,1):run(n+1,1)) = WCount(run(n,1));
  end
  plus(run(n+1,1):end) = WCount(run(n+1,1));
  
  wheel.count = WCount;
  wheel.pos = Weep;
  wheel.speed = WSpeed;
  wheel.whlrate = EegRate;
  wheel.distfact = mdist; % ??????? CHECK THIS!!!
  wheel.dist = (WCount-plus)*wheel.distfact; 
  wheel.runs = run;
  
  save([FileBase '.wheel'],'wheel')
else
  load([FileBase '.wheel'],'-MAT')
end

return;

%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%
%% in case somethin is wring with the distance:
dist = WCount;                                                          
for n=1:40
  dist(wheel.runs(n,1):end) = WCount(wheel.runs(n,1):end)-WCount(wheel.runs(n,1));
end
save([FileBase '.wheel'],'wheel')



