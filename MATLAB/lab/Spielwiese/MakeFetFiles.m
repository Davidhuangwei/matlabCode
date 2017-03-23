function MakeFetFiles(FileBase, varargin)
[overwrite,cklust] = DefaultArgs(varargin,{0,0});
%% generate *.fet files from *.spk 

Par = LoadPar([FileBase '.xml']);

%% loop through tetrodes
for n=1:Par.nElecGps
  if ~FileExists([FileBase '.fet.' num2str(n)]) | overwrite 
    
    fprintf(['... make ' FileBase '.fet.' num2str(n) ' file\n'])
    
    Spk = LoadSpk([FileBase '.spk.' num2str(n)],length(Par.ElecGp{n}));
    Res = load([FileBase '.res.' num2str(n)]);
    Clu = LoadClu([FileBase '.clu.' num2str(n)]); 
    
    %% loop though channels
    newFet = [];
    for m=1:length(Par.ElecGp{n})
      [Coeff, Score, Latent] = princomp(sq(Spk(m,:,:))');
      Fet(:,:,m) = Score(:,[1:3]);
      newFet = [newFet Fet(:,:,m)];
    end
    
    if cklust
      Kluster([FileBase '-klust'],{Fet,Spk,Res,Clu},'klusters',20000);
      waitforbuttonpress
    end
    clear Fet
    
    %% add to newFet: [newFet, amplitudes, ... ,T]
    %% amplitude:
    mSpk = sq(mean(Spk,1));
    maxAmp = max(mSpk);
    [minAmp minInd] = min(mSpk);
    Amp = abs(minAmp-maxAmp);
    
    %% get spike width at zero
    AA = mSpk(minInd)
    BB = 
    
    %% max right and max left ->> asymetry
    
    %msave([FileBase '.fet.' num2str(n)],size(newFet,2));
    %msave([FileBase '.fet.' num2str(n)],newFet,'a');
  end
end

return;
