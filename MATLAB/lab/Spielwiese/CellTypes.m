function [type mono] = CellTypes(FileBase,varargin)
[overwrite,Elec] = DefaultArgs(varargin,{0,[]});

%keyboard

%% Cell Type:
% IN = celltype==1;
% PC = celltype==2;
% UN = celltype==3;


%% get file name (see NeuroClass.m)
if isempty(Elec)
  Par = LoadPar([FileBase '.par']);
  Elec = [1:Par.nElecGps];
end

ElName='';
for k=1:length(Elec)
  ElName=[ElName '_' num2str(Elec(k))];
end
ElName(1)='';

if ~FileExists([FileBase '.type-' ElName]) | overwrite
  fprintf('Classify neurons...\n');
  if  ~FileExists([FileBase '.NeuronQuality.mat']) %| overwrite
    NeuronQuality(FileBase,[],[],[],overwrite);
  end
  if  ~FileExists([FileBase '.s2s']) %| overwrite
    mySpike2Spike(FileBase,overwrite);
  end
  NeuroClass(FileBase,Elec,overwrite);
  go=input('go: ');
end

[type.elec type.cell type.type type.act]  = textread([FileBase '.type-' ElName],'%d%d%s%d');
[type.num, type.list] = String2Clu(type.type);

for n=1:length(type.type)
  type.animal{n} = FileBase;
end

load([FileBase  '.mono-' ElName],'-MAT')

return;