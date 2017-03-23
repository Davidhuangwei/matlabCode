function Slope=FitPhasePrecCirc(FileBase,PlaceCell,spike,varargin)
[overwrite] = DefaultArgs(varargin,{0});

fprintf('  linear fit of phase precession...\n');

if ~FileExists([FileBase '.slopeC']) | overwrite
  
  figure;
  CatLField = CatStruct(PlaceCell,'lfield',1);
  count=0;
  for neu=1:length(PlaceCell)
    if PlaceCell(neu).indall(5) ~=1
      continue;
    end
    
    dire = PlaceCell(neu).ind(4);
    
    for dd = 1:size(PlaceCell(neu).lfield,1) 
      indx = find(WithinRanges(spike.lpos,PlaceCell(neu).lfield(dd,:)) & spike.ind==PlaceCell(neu).indall(1) & spike.dir==dire & spike.good);
      [dummy idx] = sort(spike.lpos(indx,1));
      
      spikepos = spike.lpos(indx(idx),1);
      spikeph = 180/pi*spike.ph(indx(idx),1);
      
      keyboard
   
      [B stats] = robustfit(spikepos,spikeph);
      [VMmu, VMb, VMk, VMberr] = VonMisesReg(spikeph*pi/180,[spikepos ones(size(spikepos))],[B'*pi/180 1]);
	
      count = count+1;
      subplotfit(count,length(CatLField.lfield))
      plot(spikepos,spikeph,'.')
      hold on
      plot(spikepos,spikeph-360,'.')
      plot(spikepos,spikeph+360,'.')
      plot(spikepos,B(2)*spikepos+B(1));
      plot(spikepos,(VMb(1)*spikepos+VMmu)*180/pi,'--r');
      title(['cell ' num2str(PlaceCell(neu).indall(1)) ' | dir ' num2str(PlaceCell(neu).indall(4)) ' | field ' num2str(dd)]) 
	
      Slope(count).mu =    VMmu;
      Slope(count).b =     VMb;
      Slope(count).k =     VMk;
      Slope(count).berr =  VMberr;
      
    end
  end
  save([FileBase '.slopeC'],'Slope')
  
else
  load([FileBase '.slopeC'],'-MAT');
end
  
return;
  
  
  