function DatFileCSD(FileIn, FileOut, nChannels, Channels2Use)
% does a CSD on a .dat file

BlockSize = 2^16;

InFp = fopen(FileIn, 'r');
OutFp = fopen(FileOut, 'w');

while(~feof(InFp))
	Block = fread(InFp, [nChannels, BlockSize], 'short');
	CSDBlock = diff(Block(Channels2Use,:), 2);
	fwrite(OutFp, CSDBlock, 'short');
	
end;

fclose(InFp);
fclose(OutFp);