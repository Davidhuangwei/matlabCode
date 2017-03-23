function MonoCell(FileBase,spike)

par = LoadPar([FileBase '.par']);
SpikesFs = 1e6/par.SampleTime;

%% load electrode info
load([FileBase '.elc'],'-MAT')

%% CA1 cells:
ca1elc = find(elc.region==1);
ca1clu = spike.clu(find(ismember(spike.clu(:,1),ca1elc)));
ca1cells = ismember(spike.ind,ca1clu));

Ncells = length(ca1clu);

%% load MonoConnections
Eloc='';
for n=1:length(ca1elc)
  Eloc=[Eloc '_' num2str(ca1elc(n))];
end
Eloc(1)='';
load([FileBase '.mono-' Eloc]);
type = load([FileBase '.type-' Eloc]);

%% load state info
load([FileBase '.states'],'-MAT')
States = unique(states.ind);

%% loop through states
for n=1:length(States)
  indx = find(WithinRanges(round(spike.t/16),states.itv(find(states.ind==n),:)) & ca1cells);
  
  [ccg t] = CCG(spike.t(indx),spike.ind(indx),round(SpikesFs/1000),50,SpikesFs,[],'count') 
  
  stccg(n).t = t;
  stccg(n).ccg = ccg;
  stccg(n).ind = unique(spike.ind(indx));
  stccg(n).state = States(n);
end

%% Plot
for n=1:length(ca1clu);
  
  
  
  
end