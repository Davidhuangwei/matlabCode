function chanCell = MakeChanCell(nShanks,chansPerShank)
% function chanCell = MakeChanCell(nShanks,chansPerShank)

chanCell = mat2cell(MakeChanMat(nShanks,chansPerShank),chansPerShank,repmat(1,nShanks,1));

return