function [xspiket, xspikeind, IN]= InternSpike(FileBase,Par)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fprintf('get spike times of interneurons...\n');

%% Read in units
[spiket, spikeind, numclus, spikeph, ClustByEl] = ReadEl4CCG(FileBase,[1:Par.nElecGps]);

%% Identify cell types 
[type.elec type.cell type.type type.act]  = textread([FileBase '.type'],'%d%d%s%d');
[clutype, strlist] = String2Clu(type.type);

%%% Identify bad electrodes (missmatch of Clu and Fet)
if ~FileExists([FileBase '.cfl'])
  BadCluLen = [];
else
  CFL = load([FileBase '.cfl']);
  for j=1:size(CFL,1)
    cfll(j) = length(unique(CFL(j,2:end)));
  end
  BadCluLen = find(size(cfll)>1);
end

%% identify Interneurons [electrode custer], take out cells from bad electrodes
allIN = [type.elec(find(clutype==1)) type.cell(find(clutype==1))];
%allIN = [type.elec(find(clutype==2)) type.cell(find(clutype==2))];
IN = allIN(find(~ismember(allIN(:,1),BadCluLen)),:);
nIN = length(IN);

%% assign cluster number
for j=1:nIN
  CluIN(j,1) = find(ClustByEl(:,1)==IN(j,1)&ClustByEl(:,2)==IN(j,2));
end

%% get spike times...
xspiket = spiket(ismember(spikeind,CluIN));
xspikeind = spikeind(ismember(spikeind,CluIN));

return;

