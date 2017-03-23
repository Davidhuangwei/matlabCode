function PhaseTimeSpectRav(FileBase,varargin)
[spike,Eeg,type,overwrite] = DefaultArgs(varargin,{[],[],[],0});

if ~FileExists([FileBase '.PhaseTimeSpect']) | overwrite
  
  
  if isempty(spike) | isempty(Eeg) | isempty(type)
    load([FileBase '.ravdat'],'-MAT');
  else
    load([FileBase '.elc'],'-MAT');
    if ~FileExists([FileBase '.elc'])
      error(['The file ' FileBase '.elc does not exists!\n'])
    end
  end
  
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
  Res = round(spike.t(indx)/16);
  Clu = spike.ind(indx);
  nFFT = 2^12; %1024;
  Fs = 1250;
  WinLength = nFFT/2;%1250;
  nOverlap = [];%625;
  NW = 3;
  Detrend = 'linear';
  nTapers = [];
  FreqRange = [1 20];
  CluSubset = allclu;%(find(type.num==1));
  CluSubset2 = CluSubset(1:2);
  %CluSubset2 = [1:2];
  
  [y,f,t] = mtptcsdGnew(Eeg,Res,Clu,nFFT,Fs,WinLength,nOverlap,NW,Detrend,nTapers,FreqRange,CluSubset2);
  
  Spect.y = y;
  Spect.t = t;
  Spect.f = f;
  Spect.cells = CluSubset2;
  
  save([FileBase '.PhaseTimeSpect'],'Spect');

end