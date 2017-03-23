function [HH Bin] = SVMUphhist(FileBase,spikeph,spikei,varargin)
[overwrite,GoodCells,PLOT,phbin,Smoother] = DefaultArgs(varargin,{0,[],0,10});
%%
%%
%%

%% find phase range
if (max(spikeph)-min(spikeph))<=2*pi
  PH = mod(spikeph,2*pi)*180/pi;
else
  PH = mod(spikeph,360);
end

%% phase bins
RPH = round(PH/phbin);
RPH(find(RPH==0)) = max(RPH);

keyboard

%% make histog
HH = Accumulate([RPH spikei],1);
Bin = ([1:size(HH,1)])*phbin;

%SHH = reshape(smooth(HH,5,'lowess'),size(HH,1),size(HH,2));

SHH = [];
for n=1:size(HH,2);
  SHH(:,n) = smooth(HH(:,n),Smoother,'lowess');
end
