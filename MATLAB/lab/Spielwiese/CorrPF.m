function Corr=CorrPF(FileBase,PlaceCell,whl,spike,Corr,varargin)
[overwrite] = DefaultArgs(varargin,{0});

%% Auto- and  Cross-Correlogramm during PlaceFiled!
%% 

if ~FileExists([FileBase '.xcorrel']) | overwrite
  
  RateFactor = 20000/whl.rate;
  Ind = PlaceCell.ind;
  neurons = unique(Ind(:,1));
  Trials = PlaceCell.trials;
  
  ccgind = [];
  for neu=1:size(Ind,1)
    %% take all good spikes:
    TrialIdx = find(Trials(:,1)==neu);
    nTrials = Trials(TrialIdx,2:3);
    nitrials = find(nTrials(:,1));
    aindx = WithinRanges(round(spike.t/RateFactor),nTrials,[nitrials],'vector')'.*(spike.ind==Ind(neu,1) & spike.good);
    goodtrials = unique(aindx(find(aindx>0)));
    
    gspiket = spike.t(find(aindx));
    [ccg, t] = CCG(gspiket,aindx(find(aindx)),100,200,20000);
    ccgind = [ccgind; [neu*ones(size(goodtrials)) nitrials(goodtrials)]];
    
    for tr=1:size(ccg,2)
 	smccg(neu,tr,:) = smooth(ccg(:,tr,tr),20,'lowess');
    end
    %neu
    %subplot(121)
    %imagesc(sq(smccg(neu,:,:)))
    %subplot(122)
    %imagesc(unity(sq(smccg(neu,:,:))')')
    %waitforbuttonpress;
    
  end
  
  Corr.ccgpf = smccg;
  Corr.ccgpft = t;
  Corr.ccgpfind = ccgind;
  
  save([FileBase '.xcorrel'],'Corr');
  
else
  load([FileBase '.xcorrel'],'-MAT');
end




return;

%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%
  
  