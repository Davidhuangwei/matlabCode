function CalcAlterUnitSpectrum01(analDirs)
cwd=pwd;
for a=1:length(analDirs)
    cd(analDirs{a})
    mazeFiles = LoadVar('FileInfo/AlterFiles');
    CalcUnitSpectrum01(mazeFiles);
end
cd(cwd);
