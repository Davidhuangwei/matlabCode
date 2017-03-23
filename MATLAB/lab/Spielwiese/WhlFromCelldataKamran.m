function WhlFromCelldataKamran(FileBase,varargin)
[overwrite] = DefaultArgs(varargin,{0});

if ~FileExists([FileBase '.whl']) | overwrite
  
  load([FileBase '.celldata'],'-MAT');
  if max(diff([celldata.xyt(:,3) celldata.xyt2(:,3)]'))
    error('there is a mismatch in back and front light!')
  end
  X = mean([celldata.xyt(:,1) celldata.xyt2(:,1)],2);
  Y = mean([celldata.xyt(:,2) celldata.xyt2(:,2)],2);
  WhlMean = [X Y];
  % -- interpolate/resample data
  T = (celldata.xyt(:,3)-celldata.xyt(1,3))/1000000;
  WhlT = [min(T):1/WhlRate:max(T)]';
  xNWhl = interp1(T,[celldata.xyt(:,[1 2]) celldata.xyt2(:,[1 2])],WhlT);
  % -- cut beginning and end according to celldata.tbegin and celldata.tend
  xb = (celldata.tbegin-celldata.xyt(1,3))/1000000;
  xe = (celldata.ftend-celldata.xyt(1,3))/1000000;
  NWhl = xNWhl(find(WhlT>=xb & WhlT<=xe),:);
  
  %WhlCtr(:,1) = mean(NWhl(:,[1 3]),2);
  %WhlCtr(:,2) = mean(NWhl(:,[2 4]),2);
  WhlCtr = NWhl(:,[1 2]);

  %% the position is scaled such that the origien is at [1 1]
  WhlCtr(:,1) = (WhlCtr(:,1)-min(WhlCtr(:,1)))*100+1;
  WhlCtr(:,2) = (WhlCtr(:,2)-min(WhlCtr(:,2)))*100+1;

  msave([FileBase '.whl'],WhlCtr)
%else
%  WhlCtr = load([FileBase '.whl']);
end
 
