function SpkFileCSD(FileIn, FileOut)
% SpkFileCSD(FileIn, FileOut)
%
% loads a .spk file, performs a CSD on it, and saves to a new name

Spk = LoadSpk(FileIn);

SpkCSD = diff(Spk, 2);

SaveSpk(FileOut, SpkCSD);