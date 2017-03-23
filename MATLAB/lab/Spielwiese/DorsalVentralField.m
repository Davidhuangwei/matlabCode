function DorsalVentralField(FileBase,elc,varargin)
overwrite = DefaultArgs(varargin,{0});

RFactEeg = 20000/1250;
RFactWhl = 1250/39.0625;

AMP=0;

%if ~FileExists([FileBase '.sts.' 'RUN']) | overwrite
%CheckEegStates(FileBase,'RUN',[],[1 100],elc,4);
%go = input('go? ');
%end

for n=1:length(elc)
  [ThPh(:,n), ThAmp(:,n), ThFr(:,n)] = ThetaParams(FileBase,elc(n),overwrite,[],'max');
end
  
if AMP
  subplot(311)
  plot(ThPh(:,1))
  hold on
  plot(ThPh(:,2),'r')
  hold off
  
  subplot(312)
  plot(ThAmp(:,1))
  hold on
  plot(ThAmp(:,2),'r')
  hold off
  
  subplot(313)
  plot(ThFr(:,1))
  hold on
  plot(ThFr(:,2),'r')
  hold off
end

Par = LoadPar(FileBase);
Eeg = LoadBinary([FileBase '.eeg'],elc,Par.nChannels);

[yo, fo, to, phi, FStats]=mtchglong(Eeg,[],1250,[],[],[],[],[],[1 100]);

CheckEegStates(FileBase,'RUN',{to,fo,yo(:,:,1,2), 'imagesc'},[1 100],elc,1);
states = load([FileBase '.sts.RUN']);


%% unit-phase
[SpT,SpG,SpMap,SpPar]=LoadCluRes(FileBase,[1:8]);

for n=1:length(elc)+1
  SpPh(:,n) = ThPh(round(SpT/20000*1250),n); 
end

keyboard

for m=1:size(Map,1)
  indx = find(SpG==m & WithinRanges(round(SpT/20000*1250)));
  
  [ThPh(:,n), ThAmp(:,n), ThFr(:,n)] = ThetaParams(FileBase,elc(n),overwrite,[],'max');
  Eeg = LoadBinary([FileBase '.eeg'],Map(m,2),Par.nChannels);
  %phase = ;
  
end


return;