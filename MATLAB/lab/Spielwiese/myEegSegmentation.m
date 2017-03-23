% function myEegSegmentation(FileBase, Control, Overwrite, Channels, nPCA,  Window, nChannels,SignalType, GoodPeriods,Labels,FreqRange)
%
% performes the segmentation of the eeg by states that correspond to 
%certain power spectral features combimation
%
% Control = 1 for some control  (0 - Default)
% Window (in seconds) for the spectrogram calculation
% nChannels - number of channels in file, if different from .par or it is absent
% SignalType = 'eeg' (def) or 'csd'
% GoodPeriods = [beg end] by # periods in eeg sampling - selects only segments within those periods for analysis
% Labels = cell array of labels to use to cluster
%
function  myEegSegmentation(FileBase, varargin)
%
DefLabels = {'SWS', 'IMM', 'REM', 'RUN' , 'AWK', 'HVS' , 'ART' ,'DES'};
esr = 1250;
[Control, Overwrite, Channels, nPCA, Window, nChannels, SignalType, GoodPeriods, Labels,    FreqRange] = DefaultArgs(varargin, ...
{ 0,       1,         [],       5,    1,      [],        'eeg',      [],          DefLabels, [1 100]});

if isempty(find(strcmp(Labels,'ART'))) & isempty(find(strcmp(Labels,'art')))
  Labels{end+1}= 'ART';
end    
save([FileBase '.statelabels.mat'],'Labels');
saveFn = [FileBase '.eegseg.mat'];
JustDone=0;
EegFileName = [FileBase '.' SignalType];
if ~FileExists([FileBase '.par'])
  EegFs = 1250;
else
  EegFs = GetEegFs(FileBase);
end
if ~Control | ~FileExists(saveFn) | Overwrite% compute stuff and save
  if ~FileExists([FileBase '.par']) & isempty(nChannels)
    error('par file does not exist and nChannels not set');
  end
  if FileExists([FileBase '.par']) & isempty(nChannels)
    Par = LoadPar([FileBase '.par']);
    nChannels = Par.nChannels;
  end
  if isempty(Channels)
    if FileExists([FileBase '.eegseg.par']);
      Channels = load([FileBase '.eegseg.par']);
      Channels = Channels+1;
    elseif FileExists([FileBase '.eeg.0']) % & ~FileExists([FileBase '.eeg'])
      EegFileName = [FileBase '.eeg.0'];
      nChannels = 1;
      Channels =1;
    else
      error('Couldnt figure out the Channels to use!!! \n');
      return
    end
  end
  nChanSel = length(Channels);
  
  Eeg = readmulti(EegFileName, nChannels, Channels);
  % compute power in segments and get stats on it
  nFFT = 2^round(log2(2^11*EegFs/1250)); %compute nFFT according to different sampling rates
  Window = 2^round(log2(Window*EegFs));% choose window length as power of two
  weeg = WhitenSignal(Eeg,[],1);
  [y,f,t]=mtcsglong(weeg,nFFT,EegFs,Window,[],2,'linear',[],FreqRange);
  %keyboard
  %[y,f,t]=mtcsglong(eeg,2^11,1250,2^10,2^9,1.5,'linear',4,[1 100]);
  GoodF = find(f<57 | f>63); 
  %    GoodT = find(WithinRegions(t*Window-Window/2, GoodPeriods));
  % now do the svd on non-60Hz freq. on each channel
  for iCh = 1:nChanSel
    %        [u,s,v] = svd(log(y(GoodT,GoodF,iCh)),0);
    [u,s,v] = svd(unity(squeeze(log(y(:,GoodF,iCh)))),0);
    Fet(:,:,iCh) =u(:,1:nPCA);
    sv=diag(s); sv = sv./sum(sv);
    EigVal(:,iCh) = sv;
    EigVec(:, :, iCh) = v(:,1:nPCA);
  end
  %    t =t(GoodT);
  
  % norm Fet
  AllFet =reshape(Fet,size(Fet,1),[]);
  AllFet = round(AllFet*2^15/max(abs(AllFet(:))));
  %    AllFet = [AllFet round(t(:)*1250)];
  if 0 % do gmm clustering
    nStates = 6;
    nDim = 10;
    mix = gmm(nDim,nStates, 'full');
    opt = zeros(15,1); opt(14)=100;
    mix = gmminit(mix, AllFet,opt);
    clu = gmmclu(mix, AllFet);
  elseif 1 % or KlustaKwik
    clu = KlustaKwik(AllFet, 5);
  end
  
  
  %save stuff
  if Overwrite | ~FileExists(saveFn) 
    save(saveFn, 'y','f','t','Fet','clu','EigVal','EigVec');
  end
  JustDone=1;
end 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% END OF COMPUTATION    
if Control % load stuff and plot
  if ~JustDone & FileExists(saveFn)  
    load(saveFn);
  end   
  %      Par = LoadPar([FileBase '.par']);
  
  %     % clean clu
  %     for i=4:length(clu)
  %         if clu(i)~=clu(i-1) & length(unique(clu([- 2, -1 1 2]+i)))==1
  %             clu(i)=clu(i-1);
  %         end
  %     end
  %     % plot eigenstuff
  %     figure(171)
  %     subplotfit(1,nPCA+1);
  %     plot(log(EigVal),'.');
  %     title('Eigenvalues');
  %     GoodF = find(f<57 | f>63); 
  %     for i=1:nPCA
  %         subplotfit(i+1,nPCA+1);
  %         plot(f(GoodF),abs(sq(EigVec(:,i,:))));
  %         title([num2str(i) ' PCA']);
  %     end
  
  % % now compute the power in particular freq. ranges.
  %      for i=1:nChannels
  %         powst(:,:,:,i) = cat(PowerPeakStats(log(y(:,:,i)),f, FreqRanges);
  %      end
  %      figure
  % HistMatrix(sq(permute(powst(:,:,5,:),[2 1 4 3])),100);
  t =  t+ t(2)-t(1);
  Kluster([FileBase '.seg'],{Fet, permute(log10(y(:,:,:)),[3,2,1]), t ,clu},'klusters',EegFs);
  
  answ = input('Do you want to save clustering changes?\n (1/0)');
  if answ
    clu = load([FileBase '.seg.clu.1']);
    nclu = clu(1); clu = clu(2:end);
  end
  uclu = unique(clu);
  nclu = max(clu);
  hclu = hist(clu,uclu);
  if length(hclu)<nclu
    hclu = [0; hclu(:)];
  end
  figure(172)
  subplotfit(1,nclu);
  bar([1:nclu],hclu)
  title('proportion of time for each state');
  
  for i=2:nclu
    subplotfit(i,nclu)
    my = find(clu==i);
    mypow = sq(mean(20*log(y(my,:,:)),1));
    mypowerr = sq(std(20*log(y(my,:,:)),0,1))/hclu(i);
    plot(f,mypow);
    hold on
    plot(f,mypow - mypowerr,'--');
    plot(f,mypow + mypowerr,'--');
    title(['cluster # ' num2str(i)]);
  end
  
  figure(173)
  CCG(t,clu,1,100,1,uclu,'count');
  ForAllSubplots('axis off');
  
  figure(174)
  AllFet =reshape(Fet,size(Fet,1),[]);
  KlustaSistData(AllFet, clu);
  %keyboard    
  EegFs = 1250;
  
  msave('t',round(t*EegFs),'w');
  msave('c',[nclu; clu(:)],'w');
  Par = LoadPar([FileBase '.par']);
  
  if FileExists([FileBase '.eeg']) 
    cmd = sprintf('regaa -16 %s.eeg %d %d &', FileBase, Par.nChannels, 1e6/EegFs);
  elseif FileExists([FileBase '.eeg.0'])
    cmd = sprintf('regaa -16 %s.eeg.0 %d %d &', FileBase, 1, 1e6/EegFs);
  end
  system(cmd);
  
  
  %now join times in segments
  % add zeros at the ends to fix the borders
  Change = diff([ 0; clu(:); 0]);
  ChangeInd  = find(abs(Change)>0.5);
  ChangeISI = diff(ChangeInd);
  Seg = [ChangeInd(1:end-1) ChangeInd(1:end-1)+ChangeISI(:)-1];
  SegClu = clu(ChangeInd(1:end-1));
  SegLen = ChangeISI(:);
  hSegClu = hist(SegClu,uclu);
  if length(hSegClu)<nclu
    hSegClu = [0; hSegClu(:)];
  end
  
  
  HintStr = '';
  for i=1:length(Labels)
    HintStr  = [HintStr Labels{i} ' (' num2str(i) '), '];
  end
  
  % make browsing sequence for each cluster
  for i=2:nclu
    myclu = find(SegClu==i);
    myt = t(round(mean(Seg(myclu,:),2)));
    [dummy ind] = sort(SegLen(myclu));
    nb = min(20, hSegClu(i));
    % take half from the top
    settop = ind(end-round(nb/2):end);
    % and another half randomly from the bottom half
    setbottom = round( rand(round(nb/2),1) * hSegClu(i)/2)+1;
    set = [settop(:) ; setbottom(:)];
    b = round(myt(set(:))*EegFs);
    msave(['b' num2str(i)],b(:),'w');
    msave('b' ,b(:),'w');
    fprintf('assign label to the cluster %d\n', i);
    
    fprintf('chose: %s \n', HintStr );
    CluLabel(i) = input(' ----> ');
  end
  if ~isempty(find(strcmp(Labels,'ART')))
    ArtLabelInd = find(strcmp(Labels,'ART'));
  else
    ArtLabelInd = find(strcmp(Labels,'art'));
  end
  CluLabel(1)= ArtLabelInd;
  
  fprintf(' you assigned: \n');
  for i=1:nclu
    fprintf('Cluster %d ---> %s\n', i, Labels{CluLabel(i)});
  end
  answ = 1;
  while answ
    answ = input('Do you want to reasign ? (1/0)')
    if answ 
      whichclu = input('what cluster? \n');
      fprintf('assign label to the cluster %d\n', whichclu);
      fprintf('chose: %s \n', HintStr );
      CluLabel(i) = input(' ----> ');
    end
  end
  CluLabelStr = Labels(CluLabel);
  SegClu = CluLabel(SegClu(:));
  
  
  if 0    
    %Set the running borders
    Par = LoadPar([FileBase '.par']);
    SyncChannel = Par.nChannels; % assume for now;
    Sync = readsinglech([FileBase '.eeg'],Par.nChannels,SyncChannel);
  end
  %     figure(175)
  %     subplot(3,1, [1 2];
  %     stairs(Seg(:,1)*(t(2)-t(1)),CluLabel(SegClu));
  %     ylim([0 8]);
  % %     ylables =get(gca, ;
  % %     for i=1:6
  % %         ylabels(i,:) = Labels{i};
  % %     end
  % %     ylabels = ['  ';ylabels; '   '];
  % %     set(gca,'YTickLabel', ylabels)
  %     subplot(3,1,3);
  %     plot([1:length(Sync)], Sync);
  %     [runbound,dummy] = ginput(2);
  
  if 0 
    % skip for now.
    % merging rules
    % SWS - HVS, SWS - IMM, ART-AWK,/RUN, DES-AWK/RUN/REM 
    nSegClu = length(Labels);
    %rename the segments
    SegClu = SegClu(:);
    Merge1= [ 1 6; 1 2; 7 4; 7 5;  8 4; 8 5; 8 3]; 
    Merge1 = [ Merge1 ; fliplr(Merge1)];
    
    
    figure(175)
    stairs(Seg(:,1)*(t(2)-t(1)),SegClu);
    ylim([0 9]);
    fprintf('Now will merge the single eopchs (of length 1) (hit key) \n');
    % now sort out the segments according to labels
    %length one segments
    
    WasMerge = 2;
    while WasMerge>0
      
      for i=[-1 1]
	Seg1Ind = find(SegLen<3 );
	Seg1NeighbInd = Seg1Ind + i;
	NeighbLen  = SegLen(Seg1NeighbInd);
	NeighbClu = SegClu(Seg1NeighbInd);
	% wjat to merge
	IfMerge = ismember([NeighbClu SegClu(Seg1Ind)], Merge1,'rows') & (NeighbLen>2);
	if sum(IfMerge)==0 
	  WasMerge = WasMerge -1 ;     
	  break;
	end
	MergeInd = Seg1Ind(find(IfMerge)); 
	% in Seg indexing
	% now we merge
	Remaining = setdiff([1:length(SegLen)], MergeInd);
	SegClu = SegClu(Remaining);
	if i==-1
	  Seg(MergeInd-1, 2) = Seg(MergeInd-1, 2)+1;
	  SegLen(MergeInd-1) = SegLen(MergeInd-1)+1;
	else
	  Seg(MergeInd+1, 1) = Seg(MergeInd-1, 2) -1;
	  SegLen(MergeInd+1) = SegLen(MergeInd+1)+1;
	end
	SegLen = SegLen(Remaining);
	Seg = Seg(Remaining,:);
      end
      hold on
      stairs(Seg(:,1)*(t(2)-t(1)),SegClu, 'r');
      hold off
      pause
      stairs(Seg(:,1)*(t(2)-t(1)),SegClu, 'b');
    end
    
  end 
  % end of merge section
  %close all
  figure(172);clf;figure(173);clf;figure(174);clf;
  %    plot(Seg(:,1),SegClu,'.','MarkerSize',3)
  
  Seg = round(Seg*(t(2)-t(1))*1250);
  msave([FileBase '.states.res'], Seg, 'w');
  msave([FileBase '.states.len'], SegLen(:),'w');
  msave([FileBase '.states.clu'], SegClu(:),'w');
end



return

