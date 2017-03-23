function Rat = PosConv(whl,varargin)
%%
[FIGURE] =  DefaultArgs(varargin,{0});
%%
%% takes whl data (circular track and converts into linear
%%
%% input: whl data
%%
%% output:
%%
%% Rat = [time angle direction radius speed]

%fprintf('convert position....');

%% get position
[t,Apos] = Circ2LinPF(whl);

%% interpolate position, filter 
for i=1:size(Apos,2)
  [nt,intpos,fintpos]=Interpol(t,Apos(:,i));
  Pos(:,i) = intpos';
  FPos(:,i) = fintpos';
end

%% get direction from the two LED lights 
Direct = (Pos(:,2)-Pos(:,3));
FDirect =(FPos(:,2)-FPos(:,3));

Rat(:,1) = nt'; %% time bin
Rat(:,2) = Pos(:,1); %% angle

%% filter direction and take sign
[b,a]=butter(4,0.05/20,'low');
FFDirect = filtfilt(b,a,Direct);
%Rat(:,3) = sign(FFDirect);
Rat(:,3) = sign(Direct); %% direction

Rat(:,4) = Pos(:,4); %% radius

%% SPEED
FDeg = mySmooth(Rat(:,2),500);
fspeed1 = diff(FDeg)*39.065;
fspeed1(end+1) = fspeed1(end);
fspeed2 = mySmooth(fspeed1,5);

Rat(:,5) = fspeed2; %% speed

if FIGURE
  clf
  cfigure(FIGURE)
  plot(Rat(:,1)/40,FDeg,'.',Rat(:,1)/40,fspeed1,'-')
end

return

