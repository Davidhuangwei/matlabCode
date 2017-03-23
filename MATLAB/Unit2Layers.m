function Unit2Layers(FileBase,varargin)
Par = LoadPar([FileBase '.xml']);

[Electrodes] = DefaultArgs(varargin,{[1:Par.nElecGps]});
nEl = length(Electrodes);

Channels = load([FileBase '.cluloc']);
Channels = Channels(ismember(Channels(:,1),Electrodes),:);

figure(212111);clf
Map = SiliconMap(FileBase);
chstr = num2str(Channels(:,1:2));
[dummy ChanInd] = ismember(Channels(:,3),Map.Channels);
rn = rand(length(ChanInd),1)-0.5;
jittx(rn>0) = (0.1+rn(rn>0))*0.4*Map.Step(1);
jittx(rn<0) = (-0.1+rn(rn<0))*0.4*Map.Step(1);
rn = rand(length(ChanInd),1)-0.5;
jitty(rn>0) = (0.2+rn(rn>0))*0.5*Map.Step(2);
jitty(rn<0) = (-0.2+rn(rn<0))*0.5*Map.Step(2);

h = text(Map.Coord(ChanInd,1)+jittx', Map.Coord(ChanInd,2)+jitty', chstr);
set(h,'FontSize',5);
maxc = max(Map.Coord);
minc = min(Map.Coord);

%       axis equal
xr = (maxc(1)-minc(1));
yr = (maxc(2)-minc(2));
axis([minc(1)-0.1*xr maxc(1)+0.1*xr minc(2)-0.1*yr maxc(2)+0.1*yr]);
set(gca,'YDir','reverse')