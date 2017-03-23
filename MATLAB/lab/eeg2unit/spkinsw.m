function [hs ,fr]=spkinsw(spk,sw)
hs=cell(2,1);
hipsw=[];
hipnonsw=[];
spk=spk(:);
frin=0;
frout=0;
for i=1:size(sw,1)
    spkindin = find(spk<sw(i,3)& spk>sw(i,1));
    hipsw=[hipsw;spk(spkindin)];
end

hipnonsw = setdiff(spk,hipsw);
trangein = sum(sw(:,3)-sw(:,1))/20000;
trangeout = (spk(end)-spk(1) - sum(sw(:,3)-sw(:,1)))/20000;
frin =  length(hipsw)/trangein;
frout = length(hipnonsw)/trangeout;

hs{1}=hipsw(:);
hs{2}=hipnonsw(:);

if nargout>1
    fr = [frin frout];
end
