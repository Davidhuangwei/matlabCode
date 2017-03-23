db = GetAwakeDataBase;

for F=db
	TRD([F.Directory '/' F.FileBase], F.Par.nChannels, 1:F.Par.nChannels-1, 10);
end