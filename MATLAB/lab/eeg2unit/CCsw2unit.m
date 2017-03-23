%function CCsw2unit(filename,unitel,unitclu,tbin,halfbinnum)
%plots the corsscorrelogram betwin SPW beginning and unit from unitel from cluster unitclu
function CCsw2unit(filename,unitel,unitclu,tbin,halfbinnum)

if nargin<4 
    tbin=0.02;
    halfbinnum=20;
end
filename=[pwd '/' filename '/' filename];

sw=load([filename '.sw']);
sw=sw(:,1);
res=load([filename '.res.' num2str(unitel)]);
if unitclu==-1
    spk=res;
else
    clu=load([filename '.clu.' num2str(unitel)]);
    clu=clu(2:end);
    spk=res(find(clu==unitclu));
end
PointCorrelA(sw,spk,tbin*20000,halfbinnum,0,20000,'count');

