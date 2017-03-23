% FileQuality(FileBase, ElecNo, Fets2Use)
%
% a wrapper function that runs LClusterQuality for every cluster in a file.
%
% BurstTimeWin defaults to 120 (6 ms at 20 kHz)
% Fets2Use defaults to 1:12
% results are printed to the console
%
% optional output Out is a 4-column array with 1 row per cell
% (starting from 2) with columns CluNo, eDist, bRat, fraction of ISIs < Refrac
% (default 40, i.e. 2ms @ 20kHz);

function Out = FileQuality(FileBase, ElecNo, Fets2Use)

if nargin<3
    Par1 = LoadPar1([FileBase '.par.' num2str(ElecNo)]);    
    Fets2Use = 1:(Par1.nSelectedChannels*Par1.nPCs); 
end;

Fet = LoadFet([FileBase '.fet.' num2str(ElecNo)]);
Clu = LoadClu([FileBase '.clu.' num2str(ElecNo)]);

Fet = Fet(:,Fets2Use);

for CluNo = 2:max(Clu)
	[Lextra(CluNo-1), Lintra(CluNo-1), n(CluNo-1)] = LClusterQuality(Fet, find(Clu==CluNo));
end

if nargout>=1
    Out = [2:max(Clu) ; Lextra; Lintra; n]';
else
    fprintf('Cell %d: Lextra %f Lintra %f\n', [2:max(Clu) ; Lextra; Lintra]);
end