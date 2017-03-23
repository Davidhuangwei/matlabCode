function newpc = CheckPCIN(CatAll,varargin)
[overwrite,PrintBase] = DefaultArgs(varargin,{0,'NewPC.mat'});


if ~FileExists(PrintBase) | overwrite

  figure(347856);clf
  
  PC = CatAll.type.num==2; 
  IN = CatAll.type.num==1; 
  
  XX = CatAll.NQ.SpkWidthR;
  YY = CatAll.NQ.AmpSym;
  ZZ = CatAll.NQ.FirRate;
  
  plot(XX(PC),YY(PC),'^','color',[1 0 0],'markersize',5)
  hold on
  plot(XX(IN),YY(IN),'^','color',[0 0 1],'markersize',5)
  title('cycle pyramidal cells (wide) - all other will be interneurons')
  
  newpc = ClusterPoints([XX YY],0);
  newpc = newpc+1;
    
  save(PrintBase,'newpc');
  
else
  
  load(PrintBase,'-MAT');
  
end


return;
