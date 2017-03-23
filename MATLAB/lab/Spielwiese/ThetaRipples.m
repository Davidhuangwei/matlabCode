function [ThPh Rip] = ThetaRipples(FileBase,elc,spike,states,f,Eeg,varargin)
[location, overwrite] = DefaultArgs(varargin,{1,0});
   
%% where: brain region (default is 1=CA1)

if ~FileExists([FileBase '.ThRip']) | overwrite
  
  for where=location
    
    elc.regionind{where};
    
    allclu = find(ismember(spike.clu(:,1),find(elc.region==where)));
    maxclu = max(allclu);
    minclu = min(allclu);
    
    %% initialize
    ThPh.Bin = [];
    ThPh.Hist = [];
    ThPh.Ind = [];
    
    m=0;
    for n=unique(states.ind)
      if n==0
	continue;
      end
      m=m+1;
      thitv = states.itv(find(states.ind==n),:)*16;
      indxx = WithinRanges(spike.t,thitv) & ismember(spike.ind,allclu);
      indx = find(indxx & spike.good);
      
      %% theta phase hist and stats
      [ThPhHist,BinCtr] = ThetaPhaseHist(spike.t(indx),spike.ind(indx),spike.ph(indx),allclu);
      ThPh.Bin = BinCtr;
      ThPh.Hist = [ThPh.Hist; ThPhHist];
      ThPh.Ind = [ThPh.Ind; [n*ones(length(allclu),1) allclu where*ones(length(allclu),1)]];
      
      Sts(n).sts = RayleighTest(spike.ph(indx),spike.ind(indx)-minclu+1,maxclu-minclu+1);
      
      %% Ripplehist
      if f<16
	%% if MZ's data, take out stimmulations!
	Evt = load([FileBase '.evt']);
	Stim = Evt(find(Evt(:,2)==88),1);
	intv = [Stim-100 Stim+1000];
	if intv(1,1)<1
	  intv(1,1)==1
	end
	Par = LoadPar([FileBase '.par']);
	EegLength = FileLength([FileBase '.eeg'])/2/Par.nChannels;
	if intv(end,2)>EegLength
	  intv(end,1)==EegLength;
	end
	intv2(:,1) = [1; intv(:,2)];
	intv2(:,2) = [intv(:,1); EegLength];
	Itv = intv2(find(diff(intv2')'>1),:);
	clear Evt Stim intv intv2;
      else
	Itv = [1 EegLength];
      end
      [RR(m).Hist RR(m).Sts] = RippleHist(FileBase,spike.t(find(indxx)),spike.ind(find(indxx)),Eeg,allclu,Itv);
    end
  end
  AA = CatStruct(Sts,[],1);
  ThPh.Sts = AA.sts;
  clear AA Sts; 
  
  AA = CatStruct(RR,[],1);
  Rip.Hist = AA.Hist;
  Rip.Sts = AA.Sts;
  clear AA RR;
  
  save([FileBase '.ThRip'],'ThPh','Rip');
  %ALL(f).ThPh = ThPh;
  %ALL(f).Rip = Rip;
  %clear ThPh Rip;
else
  load([FileBase '.ThRip'],'-MAT')
  %ALL(f).ThPh = ThPh;
  %ALL(f).Rip = Rip;
  %clear ThPh Rip;
end
