function MkSpectAnalDirsBat(fileBaseCell,spectAnalDirName)

for j=1:length(fileBaseCell)
    mkdir([fileBaseCell{j} '/' spectAnalDirName])
end

