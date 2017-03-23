%function mySpikes2Spike(FileBase,Overwrite, El)
% Computes the CCG for spikes of each electrode
function s2s = mySpike2Spike(FileBase,varargin)

par = LoadPar([FileBase '.par']);
[Overwrite,El] = DefaultArgs(varargin,{1, [1:par.nElecGps]});

SpikesFs = 1e6/par.SampleTime;
SaveFn = [FileBase '.s2s'];
if ~FileExists(SaveFn) | Overwrite
    [Res,Clu,nClu,dummy, ClustByEl, cID] = ReadEl4CCG(FileBase, El);
    uClu = unique(Clu);
    nClu = length(uClu);
    nBins = 50;
    [ccg, t] = CCG(Res, Clu, round(SpikesFs/1000), nBins, SpikesFs, uClu, 'count');
    
    s2s.ccg(:,:,:,4) = ccg;
    s2s.tbin = t;
    s2s.cID = cID(uClu);
    s2s.ElClu = ClustByEl;
    save(SaveFn,'s2s','-v6');

elseif nargout>0
    load(SaveFn,'-MAT');
end
