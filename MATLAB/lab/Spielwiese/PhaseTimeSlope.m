function PhaseTimeSlope(FileBase,spike,Eeg,type,varargin)
[overwrite,plotting] = DefaultArgs(varargin,{0,0});

if ~FileExists([FileBase '.PhaseTimeSlope']) | overwrite
  
  load([FileBase '.elc'],'-MAT');
  allclu = find(ismember(spike.clu(:,1),find(elc.region==1)));
  maxclu = max(allclu);
  minclu = min(allclu);
  
  %% compute spectra for overlapping windows for each state
  %% using only spikes within good theta. 
  
  indx = find(ismember(spike.ind,allclu) & spike.good);
  
  %% cut into segments for whole file!!! do state
  %% segmentation afterwards! 
  Itvs = [1:length(Eeg)];
  
  %% compute spectra of spikes and field for all segments which contain spikes.
  
  %% compute phase precession slope for all  
  Res = round(spike.t(indx));
  Clu = spike.ind(indx);
  WinLength = 2^11;
  nOverlap = WinLength/2; % WinLength*(1-1/8)
  CluSubset = allclu;
  CluSubset2 = CluSubset(1:2);
  
  NumSegs = length(Eeg)/nOverlap;
  time = ([1:NumSegs]*nOverlap + (WinLength/2-nOverlap))/1000;
  
  %% loop through cells and segments..... slow?????
  for cc=CluSubset2'
    for seg=1:NumSegs
      
      indx = find(spike.ind==cc & spike.good); 
      
      if isempty(indx)
	slope(seg,cc) = NaN;
	stats(seg,cc,:) = [NaN NaN NaN];
      else
	
	segphase = unwrap(spike.ph(indx));
	
	[b stat] = robustfit(spike.t(indx),segphase); 
      	
	%slope(seg,cc) = AA;
      
	keyboard
	
      end
    end
  end
  
  
  Slope.y = y;
  Slope.t = t;
  Slope.f = f;
  Slope.cells = CluSubset2;
  
  save([FileBase '.PhaseTimeSlope'],'Spect');
else
  load([FileBase '.PhaseTimeSlope'],'-MAT');
end
  
%if plotting
%end

return;