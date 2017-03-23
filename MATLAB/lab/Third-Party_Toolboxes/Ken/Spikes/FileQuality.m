% FileQuality(FileBase, ElecNo, BurstTimeWin, Fets2Use, Refrac)
%
% a wrapper function that runs ClusterQuality for every cluster in a file.
%
% BurstTimeWin defaults to 120 (6 ms at 20 kHz)
% Fets2Use defaults to 1:12
% results are printed to the console
%
% optional output Out is a 4-column array with 1 row per cell
% (starting from 2) with columns CluNo, eDist, bRat, fraction of ISIs < Refrac
% (default 40, i.e. 2ms @ 20kHz);

function Out = FileQuality(FileBase, ElecNo, BurstTimeWin, Fets2Use, Refrac)

Fet = LoadFet([FileBase '.fet.' num2str(ElecNo)]);
Clu = LoadClu([FileBase '.clu.' num2str(ElecNo)]);
Res = load([FileBase '.res.' num2str(ElecNo)]);

if nargin<3, BurstTimeWin = 120; end;
if nargin<4, 
    Par1 = LoadPar1([FileBase '.par.' num2str(ElecNo)]);
    Fets2Use = 1:(Par1.nSelectedChannels*Par1.nPCs);
end
if nargin<5, Refrac = 40; end;

Fet = Fet(:,Fets2Use);

for CluNo = 2:max(Clu)
	[eDist(CluNo-1), bRat(CluNo-1)] = ...
		ClusterQuality(Fet, find(Clu==CluNo), Res, BurstTimeWin);
		
    MyISI = diff(Res(find(Clu==CluNo)));
    RefracViol(CluNo-1) = sum(MyISI<Refrac)/length(MyISI);
end

if nargout>=1
    Out = [2:max(Clu) ; eDist ; bRat; RefracViol]';
else
    fprintf('Cell %d: eDist %f bRat %f RefViol %f\n', ...
        [2:max(Clu) ; eDist ; bRat; RefracViol]);
end