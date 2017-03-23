function PhasePreces(FileBase,PlaceCell,whl,spike,trial,varargin)
[overwrite] = DefaultArgs(varargin,{0});
%% plot phase precession
%% 

for neu=1:length(PlaceCell)
  
  if PlaceCell(neu).ind(5)~=1
    continue;
  end
  
  dire = PlaceCell(neu).ind(4);
  indx = find(spike.ind==PlaceCell(neu).ind(1) & spike.dir==dire);
  
  plot(spike.lpos(indx,1),180/pi*spike.ph(indx,1),'.')
  hold on
  plot(spike.lpos(indx,1),180/pi*spike.ph(indx,1)+360,'.')
  plot(spike.lpos(indx,1),180/pi*spike.ph(indx,1)+720,'.')
  Lines(PlaceCell(neu).lfield(1,:));%{'g','r'},{'-','-'},[2 2]);
  Lines(trial.event(dire).lin,[],'b','--',2*ones(size(trial.event(dire).lin)));
  xlim([0 max(spike.lpos)]);
  hold off;
  
  waitforbuttonpress;
  
end