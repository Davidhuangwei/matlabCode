function RmGLMPlots(chanLocVersion,analRoutine,analNote,spectAnalDir,fileExtCell,regExp)
for j=1:length(chanLocVersion)
    for k=1:length(analRoutine)
        for m=1:length(spectAnalDir)
            for n=1:length(fileExtCell)
                dirName = Dot2Underscore([chanLocVersion{j} '/' analRoutine{k} analNote '/' spectAnalDir{m} fileExtCell{n} '/']);
                files = dir([dirName regExp]);
                for p=1:length(files)
                    fprintf(['!rm -r ' dirName files(p).name '\n'])
                    eval(['!rm -r ' dirName files(p).name]);
                end
            end
        end
    end
end