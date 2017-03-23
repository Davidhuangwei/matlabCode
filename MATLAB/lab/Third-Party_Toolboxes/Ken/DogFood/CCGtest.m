% CCG test program ... will evolve

function out=CCGtest(Res, Clu, BinSize, HalfBins)

FileBase = tempname;

ResFile = [FileBase, '.res'];
CluFile = [FileBase, '.clu'];
OutFile = [FileBase, '.out'];

bsave(ResFile, Res, 'double');
bsave(CluFile, Clu, 'uint');

nSpikes = length(Res);

Command = sprintf('!/u5/b/ken/bin/CCGEngine %d %s %s %f %d %s', nSpikes, ResFile, CluFile, BinSize, HalfBins, OutFile);

eval(Command);

fp = fopen(OutFile, 'r');
out = fread(fp, inf, 'uint');
fclose(fp);

nBins = 1+2*HalfBins;
nMarks = max(Clu);
out = reshape(out,[nBins nMarks nMarks]); 

Command = sprintf('!rm %s %s %s', ResFile, CluFile, OutFile);
eval(Command);