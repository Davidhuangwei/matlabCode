  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %% classify neurons
  %%
  if  ~FileExists([FileBase '.NeuronQuality.mat']) | overwrite
    NeuronQuality(FileBase,[],[],[],overwrite);
  end
  AA = load([FileBase '.NeuronQuality.mat'],'-MAT');
  ALL(f).NQ = CatStruct(AA.OutArgs); 
  clear AA;
  if  ~FileExists([FileBase '.s2s']) | overwrite
    mySpike2Spike(FileBase,overwrite);
  end
  %% classify all neurons -- otherwise dimension missmatch 
  Elc = find(elc.region);
  [ctype cmono] = CellTypes(FileBase,overwrite,Elc);
  ElName='';
  for k=1:length(Elc)
    ElName=[ElName '_' num2str(Elc(k))];
  end
  ElName(1)='';
  [ALL(f).type.elec ALL(f).type.cell ALL(f).type.type ALL(f).type.act]  = textread([FileBase '.type-' ElName],'%d%d%s%d');
    
  %% transform ALL(f).type.type into numbers
  u = {'n' 'w' 'x'};
  ALL(f).type.num = [];
  for n=1:length(u)
    m = find(strcmp(ALL(f).type.type,u{n}));
    if isempty(m); continue; end
    ALL(f).type.num(m,1) = n;
  end
  
