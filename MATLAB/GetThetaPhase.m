function thetapar=GetThetaPhase(FileBase,Periods)
% function thetapar=GetThetaPhase(FileBase,Periods)
% get theta band parameters from FileBase.thpar.mat
% you shoul be in the filebase folder. 
% thetapar contains:
%   theta phase:        ThPh
%   theta amplitude:    ThAmp
%   theta frequency:    ThFr
% and the Parameter to compute it: Params
thetapar=load([FileBase,'.thpar.mat']);
nt=length(thetapar.ThPh);
if Periods(end)>nt
    error('time mismatch! you have only %d recording samples but you want %d.\n',nt,Periods(end));
end
taketime=false(nt,1);
nP=size(Periods,1);
for k=1:nP
    taketime(Periods(k,1):Periods(k,2))=true;
end
thetapar.ThAmp=thetapar.ThAmp(taketime);
thetapar.ThFr=thetapar.ThFr(taketime);
thetapar.ThPh=thetapar.ThPh(taketime);
end
