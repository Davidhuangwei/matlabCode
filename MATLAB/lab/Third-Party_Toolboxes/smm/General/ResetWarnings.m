function prevWarnSettings = ResetWarnings(prevWarnSettings)

for j=1:length(prevWarnSettings)
    prevWarnSettings(j) = warning(warningsCell{j,1},warningsCell{j,2});
end
return