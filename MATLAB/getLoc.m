function [loc, lnames]=getLoc(chanLoc,chan)
% [loc, lnames]=getLoc(chanLoc,chan)
% calculate layers of channels, with chanLoc get from chaninfo folder. 
% if channel information is not contained in chanLoc, loc=0. YY

lnames=fieldnames(chanLoc);
for k=1:length(lnames);
    loc(chanLoc.(lnames{k}))=k;
end
if max(chan)>length(loc)
    loc(max(chan))=0;
end
loc=loc(chan);